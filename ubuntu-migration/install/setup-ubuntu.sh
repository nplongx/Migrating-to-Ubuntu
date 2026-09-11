#!/usr/bin/env bash
# =============================================================================
# Ubuntu 24.04 Migration Setup Script
# Migrating from EndeavourOS (Arch Linux) on ThinkPad T480
#
# This script is IDEMPOTENT — safe to run multiple times.
# It will NOT: format disks, modify partitions, delete data, remove packages,
#              modify bootloader, or overwrite files without backup.
#
# Usage: bash setup-ubuntu.sh
# Do NOT run as root. The script uses sudo only where needed.
# =============================================================================

set -euo pipefail

# --- Configuration ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MIGRATION_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
BACKUP_DIR="$HOME/.migration-backup-$(date +%Y%m%d-%H%M%S)"
LOG_FILE="$MIGRATION_DIR/install/setup.log"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log()   { echo -e "${GREEN}[✓]${NC} $*" | tee -a "$LOG_FILE"; }
warn()  { echo -e "${YELLOW}[!]${NC} $*" | tee -a "$LOG_FILE"; }
err()   { echo -e "${RED}[✗]${NC} $*" | tee -a "$LOG_FILE"; }
info()  { echo -e "${BLUE}[i]${NC} $*" | tee -a "$LOG_FILE"; }
section() { echo -e "\n${BLUE}=== $* ===${NC}" | tee -a "$LOG_FILE"; }

# --- Pre-flight checks ---
preflight() {
    section "Pre-flight Checks"

    if [[ $EUID -eq 0 ]]; then
        err "Do NOT run this script as root. It uses sudo where needed."
        exit 1
    fi

    if [[ ! -f /etc/os-release ]]; then
        err "Cannot detect OS."
        exit 1
    fi

    source /etc/os-release
    if [[ "$ID" != "ubuntu" ]]; then
        err "This script is for Ubuntu. Detected: $ID"
        exit 1
    fi

    if [[ "$VERSION_ID" != "24.04" ]]; then
        warn "Designed for Ubuntu 24.04. Detected: $VERSION_ID. Proceeding anyway..."
    fi

    if [[ ! -d "$MIGRATION_DIR" ]]; then
        err "Migration bundle not found at: $MIGRATION_DIR"
        exit 1
    fi

    mkdir -p "$BACKUP_DIR"
    log "Backup directory: $BACKUP_DIR"
    log "Pre-flight checks passed. OS: Ubuntu $VERSION_ID"
}

# --- Helper: backup before overwrite ---
backup_file() {
    local src="$1"
    if [[ -e "$src" ]]; then
        local rel="${src#$HOME/}"
        mkdir -p "$BACKUP_DIR/$(dirname "$rel")"
        cp -a "$src" "$BACKUP_DIR/$rel"
        info "Backed up: $src"
    fi
}

# --- Step 1: System update ---
system_update() {
    section "System Update"
    sudo apt update
    sudo apt upgrade -y
    log "System updated."
}

# --- Step 2: Essential packages ---
install_essentials() {
    section "Essential Packages"
    sudo apt install -y \
        build-essential \
        curl \
        wget \
        git \
        zsh \
        fzf \
        jq \
        htop \
        glances \
        rsync \
        unzip \
        unrar \
        xclip \
        strace \
        lsof \
        ccache \
        meld \
        okular \
        copyq \
        scrcpy \
        kdeconnect \
        duf \
        aria2 \
        neovim \
        nano \
        whois \
        net-tools \
        speedtest-cli \
        openssh-client \
        gnupg \
        ca-certificates \
        apt-transport-https \
        software-properties-common \
        python3-pip \
        python3-venv \
        pipx \
        pkg-config \
        libssl-dev \
        libfontconfig1-dev \
        cmake \
        postgresql \
        postgresql-client
    log "Essential packages installed."
}

# --- Step 3: Zsh setup ---
setup_zsh() {
    section "Zsh Configuration"

    if [[ "$SHELL" != *"zsh"* ]]; then
        chsh -s "$(which zsh)"
        log "Default shell changed to zsh. Will take effect on next login."
    else
        log "Zsh is already the default shell."
    fi

    # Restore .zshrc
    if [[ -f "$MIGRATION_DIR/dotfiles/.zshrc" ]]; then
        backup_file "$HOME/.zshrc"
        cp "$MIGRATION_DIR/dotfiles/.zshrc" "$HOME/.zshrc"

        # Patch: remove archlinux OMZ snippet, not relevant on Ubuntu
        sed -i 's/zinit snippet OMZP::archlinux/# zinit snippet OMZP::archlinux  # Arch-specific, disabled on Ubuntu/' "$HOME/.zshrc"

        log "Restored .zshrc (patched archlinux snippet)."
    fi

    # Restore p10k config
    if [[ -f "$MIGRATION_DIR/dotfiles/.p10k.zsh" ]]; then
        backup_file "$HOME/.p10k.zsh"
        cp "$MIGRATION_DIR/dotfiles/.p10k.zsh" "$HOME/.p10k.zsh"
        log "Restored .p10k.zsh"
    fi

    # Restore bash configs
    for f in .bashrc .bash_profile .profile; do
        if [[ -f "$MIGRATION_DIR/dotfiles/$f" ]]; then
            backup_file "$HOME/$f"
            cp "$MIGRATION_DIR/dotfiles/$f" "$HOME/$f"
            log "Restored $f"
        fi
    done
}

# --- Step 4: Git configuration ---
setup_git() {
    section "Git Configuration"

    if [[ -f "$MIGRATION_DIR/dotfiles/.gitconfig" ]]; then
        backup_file "$HOME/.gitconfig"
        cp "$MIGRATION_DIR/dotfiles/.gitconfig" "$HOME/.gitconfig"
        log "Restored .gitconfig"
    fi

    if [[ -f "$MIGRATION_DIR/dotfiles/.gitignore" ]]; then
        backup_file "$HOME/.gitignore"
        cp "$MIGRATION_DIR/dotfiles/.gitignore" "$HOME/.gitignore"
        log "Restored global .gitignore"
    fi

    # Install GitHub CLI
    if ! command -v gh &>/dev/null; then
        info "Installing GitHub CLI..."
        (type -p wget >/dev/null || sudo apt install -y wget) \
            && sudo mkdir -p -m 755 /etc/apt/keyrings \
            && out=$(mktemp) \
            && wget -nv -O "$out" https://cli.github.com/packages/githubcli-archive-keyring.gpg \
            && cat "$out" | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
            && sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
            && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
            && sudo apt update \
            && sudo apt install -y gh
        log "GitHub CLI installed."
    else
        log "GitHub CLI already installed."
    fi
}

# --- Step 5: SSH keys ---
setup_ssh() {
    section "SSH Configuration"

    if [[ -d "$MIGRATION_DIR/ssh" ]]; then
        mkdir -p "$HOME/.ssh"
        chmod 700 "$HOME/.ssh"

        if [[ -f "$MIGRATION_DIR/ssh/id_ed25519" ]]; then
            if [[ -f "$HOME/.ssh/id_ed25519" ]]; then
                warn "SSH key already exists. Backing up and skipping to avoid overwrite."
                backup_file "$HOME/.ssh/id_ed25519"
                backup_file "$HOME/.ssh/id_ed25519.pub"
                warn "Existing SSH key backed up. Manually copy if you want to replace."
            else
                cp "$MIGRATION_DIR/ssh/id_ed25519" "$HOME/.ssh/id_ed25519"
                cp "$MIGRATION_DIR/ssh/id_ed25519.pub" "$HOME/.ssh/id_ed25519.pub"
                chmod 600 "$HOME/.ssh/id_ed25519"
                chmod 644 "$HOME/.ssh/id_ed25519.pub"
                log "SSH keys restored."
            fi
        fi

        if [[ -f "$MIGRATION_DIR/ssh/known_hosts" ]]; then
            if [[ -f "$HOME/.ssh/known_hosts" ]]; then
                # Merge rather than overwrite
                cat "$MIGRATION_DIR/ssh/known_hosts" >> "$HOME/.ssh/known_hosts"
                sort -u "$HOME/.ssh/known_hosts" -o "$HOME/.ssh/known_hosts"
                log "Merged known_hosts."
            else
                cp "$MIGRATION_DIR/ssh/known_hosts" "$HOME/.ssh/known_hosts"
                log "Restored known_hosts."
            fi
        fi
    fi
}

# --- Step 6: NVM + Node.js ---
setup_nodejs() {
    section "Node.js (via NVM)"

    export NVM_DIR="$HOME/.config/nvm"
    if [[ ! -d "$NVM_DIR" ]]; then
        info "Installing NVM..."
        mkdir -p "$NVM_DIR"
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
        log "NVM installed."
    else
        log "NVM already installed."
    fi

    # Source NVM
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    if ! nvm ls v24 &>/dev/null; then
        info "Installing Node.js v24..."
        nvm install 24
        nvm use 24
        nvm alias default 24
        log "Node.js v24 installed."
    else
        log "Node.js v24 already installed."
    fi

    # Install dprint
    if ! command -v dprint &>/dev/null; then
        info "Installing dprint..."
        curl -fsSL https://dprint.dev/install.sh | sh
        log "dprint installed."
    fi
}

# --- Step 7: Rust ---
setup_rust() {
    section "Rust (via rustup)"

    if ! command -v rustup &>/dev/null; then
        info "Installing Rust..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable
        source "$HOME/.cargo/env"
        log "Rust installed."
    else
        log "Rust already installed."
    fi

    source "$HOME/.cargo/env" 2>/dev/null || true

    # Install nightly toolchain
    rustup toolchain install nightly 2>/dev/null || true

    # Install RISC-V targets for ESP32
    rustup target add riscv32imac-unknown-none-elf 2>/dev/null || true
    rustup target add riscv32imafc-unknown-none-elf 2>/dev/null || true
    rustup target add riscv32imc-unknown-none-elf 2>/dev/null || true

    # Install cargo tools
    info "Installing cargo tools (this may take a while)..."
    for tool in cargo-generate espflash espup ldproxy sqlx-cli zellij; do
        if ! command -v "$tool" &>/dev/null && ! cargo install --list 2>/dev/null | grep -q "^$tool "; then
            info "Installing $tool..."
            cargo install "$tool" || warn "Failed to install $tool"
        else
            log "$tool already installed."
        fi
    done

    # ESP Rust toolchain
    if ! rustup toolchain list | grep -q "esp"; then
        info "Installing ESP Rust toolchain via espup..."
        espup install || warn "espup install failed. Run manually later."
    fi
    log "Rust ecosystem configured."
}

# --- Step 8: Docker ---
setup_docker() {
    section "Docker"

    if ! command -v docker &>/dev/null; then
        info "Installing Docker CE..."
        sudo install -m 0755 -d /etc/apt/keyrings
        sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
        sudo chmod a+r /etc/apt/keyrings/docker.asc

        echo \
            "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
            $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
            sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

        sudo apt update
        sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

        sudo usermod -aG docker "$USER"
        log "Docker installed. Log out and back in for group membership."
    else
        log "Docker already installed."
    fi
}

# --- Step 9: Fcitx5 + Vietnamese input ---
setup_fcitx5() {
    section "Fcitx5 (Vietnamese Input)"

    sudo apt install -y \
        fcitx5 \
        fcitx5-unikey \
        fcitx5-config-qt \
        fcitx5-frontend-gtk3 \
        fcitx5-frontend-gtk4 \
        fcitx5-frontend-qt5

    # Restore config
    if [[ -d "$MIGRATION_DIR/configs/fcitx5" ]]; then
        mkdir -p "$HOME/.config/fcitx5"
        cp -r "$MIGRATION_DIR/configs/fcitx5/"* "$HOME/.config/fcitx5/"
        log "Restored fcitx5 config."
    fi

    # Set environment variables for fcitx5
    FCITX_ENV_FILE="/etc/environment.d/50-fcitx5.conf"
    if [[ ! -f "$FCITX_ENV_FILE" ]]; then
        sudo mkdir -p /etc/environment.d
        echo 'GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx
INPUT_METHOD=fcitx' | sudo tee "$FCITX_ENV_FILE" > /dev/null
        log "Fcitx5 environment variables configured."
    fi
    log "Fcitx5 + Unikey installed."
}

# --- Step 10: Fonts ---
setup_fonts() {
    section "Fonts"

    # System fonts
    sudo apt install -y \
        fonts-noto \
        fonts-noto-cjk \
        fonts-noto-color-emoji \
        fonts-dejavu \
        fonts-liberation

    # User fonts from migration bundle
    if [[ -d "$MIGRATION_DIR/fonts" ]] && ls "$MIGRATION_DIR/fonts/"*.ttf &>/dev/null; then
        mkdir -p "$HOME/.local/share/fonts"
        cp "$MIGRATION_DIR/fonts/"*.ttf "$HOME/.local/share/fonts/"
        fc-cache -fv "$HOME/.local/share/fonts" > /dev/null 2>&1
        log "JetBrains Mono Nerd Font installed from migration bundle."
    fi
    log "Fonts configured."
}

# --- Step 11: Google Chrome ---
setup_chrome() {
    section "Google Chrome"

    if ! command -v google-chrome &>/dev/null; then
        info "Installing Google Chrome..."
        wget -q -O /tmp/google-chrome.deb "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
        sudo apt install -y /tmp/google-chrome.deb
        rm -f /tmp/google-chrome.deb
        log "Google Chrome installed."
    else
        log "Google Chrome already installed."
    fi
}

# --- Step 12: WezTerm ---
setup_wezterm() {
    section "WezTerm"

    if ! command -v wezterm &>/dev/null; then
        info "Installing WezTerm..."
        curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /etc/apt/keyrings/wezterm-fury.gpg
        echo 'deb [signed-by=/etc/apt/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
        sudo apt update
        sudo apt install -y wezterm
        log "WezTerm installed."
    else
        log "WezTerm already installed."
    fi

    # Restore config
    if [[ -d "$MIGRATION_DIR/configs/wezterm" ]]; then
        mkdir -p "$HOME/.config/wezterm"
        cp "$MIGRATION_DIR/configs/wezterm/wezterm.lua" "$HOME/.config/wezterm/"
        log "Restored WezTerm config."
    fi
}

# --- Step 13: Editor configs ---
setup_editors() {
    section "Editor Configurations"

    # Helix
    if ! command -v helix &>/dev/null && ! command -v hx &>/dev/null; then
        info "Installing Helix..."
        sudo add-apt-repository -y ppa:maveonair/helix-editor 2>/dev/null || true
        sudo apt update
        sudo apt install -y helix 2>/dev/null || warn "Helix PPA not available. Install manually or via snap."
    fi

    if [[ -d "$MIGRATION_DIR/configs/helix" ]]; then
        mkdir -p "$HOME/.config/helix"
        cp "$MIGRATION_DIR/configs/helix/"* "$HOME/.config/helix/"
        log "Restored Helix config."
    fi

    # VS Code config
    if [[ -f "$MIGRATION_DIR/configs/vscode/settings.json" ]]; then
        mkdir -p "$HOME/.config/Code/User"
        backup_file "$HOME/.config/Code/User/settings.json"
        cp "$MIGRATION_DIR/configs/vscode/settings.json" "$HOME/.config/Code/User/"
        log "Restored VS Code settings."
    fi

    # Zellij config
    if [[ -f "$MIGRATION_DIR/configs/zellij/config.kdl" ]]; then
        mkdir -p "$HOME/.config/zellij"
        cp "$MIGRATION_DIR/configs/zellij/config.kdl" "$HOME/.config/zellij/"
        log "Restored Zellij config."
    fi

    # Zed editor
    if ! command -v zed &>/dev/null; then
        info "Installing Zed editor..."
        curl -f https://zed.dev/install.sh | sh || warn "Zed install failed."
    fi
    log "Editor configurations restored."
}

# --- Step 14: Claude Desktop ---
setup_claude_desktop() {
    section "Claude Desktop (Official Anthropic)"

    if ! command -v claude-desktop &>/dev/null && ! dpkg -l | grep -q claude-desktop; then
        info "Installing Claude Desktop..."
        curl -fsSL https://storage.googleapis.com/anthropic-desktop-releases/claude-desktop/latest/linux/claude-desktop_amd64.deb -o /tmp/claude-desktop.deb
        sudo apt install -y /tmp/claude-desktop.deb
        rm -f /tmp/claude-desktop.deb
        log "Claude Desktop installed."
    else
        log "Claude Desktop already installed."
    fi
}

# --- Step 15: Ollama ---
setup_ollama() {
    section "Ollama"

    if ! command -v ollama &>/dev/null; then
        info "Installing Ollama..."
        curl -fsSL https://ollama.com/install.sh | sh
        log "Ollama installed. Previously used models: llama3.1:8b, qwen2.5-coder:7b"
        info "Pull models with: ollama pull llama3.1:8b && ollama pull qwen2.5-coder:7b"
    else
        log "Ollama already installed."
    fi
}

# --- Step 16: Obsidian ---
setup_obsidian() {
    section "Obsidian"

    if ! command -v obsidian &>/dev/null && ! flatpak list 2>/dev/null | grep -q obsidian; then
        info "Installing Obsidian via Flatpak..."
        sudo apt install -y flatpak
        flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
        flatpak install -y flathub md.obsidian.Obsidian
        log "Obsidian installed via Flatpak."
    else
        log "Obsidian already installed."
    fi
}

# --- Step 17: Additional desktop apps ---
setup_desktop_apps() {
    section "Desktop Applications"

    # Flatpak + Gear Lever
    sudo apt install -y flatpak 2>/dev/null || true
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo 2>/dev/null || true
    flatpak install -y flathub it.mijorus.gearlever 2>/dev/null || warn "Gear Lever Flatpak install failed."

    # KiCad
    if ! command -v kicad &>/dev/null; then
        info "Installing KiCad..."
        sudo add-apt-repository -y ppa:kicad/kicad-8.0-releases 2>/dev/null || true
        sudo apt update
        sudo apt install -y kicad 2>/dev/null || warn "KiCad PPA install failed. Use AppImage instead."
    fi

    # Erlang + Gleam
    if ! command -v erl &>/dev/null; then
        info "Installing Erlang..."
        sudo apt install -y erlang 2>/dev/null || true
    fi
    if ! command -v gleam &>/dev/null; then
        info "Installing Gleam..."
        curl -fsSL https://gleam.run/install.sh | sh || warn "Gleam install failed. See https://gleam.run/getting-started/installing/"
    fi

    # PlatformIO via pipx
    if ! command -v pio &>/dev/null; then
        pipx install platformio 2>/dev/null || warn "PlatformIO install via pipx failed."
    fi

    # thefuck
    sudo apt install -y thefuck 2>/dev/null || pipx install thefuck 2>/dev/null || true

    # zoxide
    if ! command -v zoxide &>/dev/null; then
        sudo apt install -y zoxide 2>/dev/null || curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
    fi

    # yazi
    if ! command -v yazi &>/dev/null; then
        cargo install --locked yazi-fm yazi-cli 2>/dev/null || warn "yazi install failed."
    fi

    # tldr
    if ! command -v tldr &>/dev/null; then
        sudo apt install -y tldr 2>/dev/null || npm install -g tldr 2>/dev/null || true
    fi

    log "Desktop applications configured."
}

# --- Step 18: ThinkPad T480 optimizations ---
setup_thinkpad() {
    section "ThinkPad T480 Configuration"

    # Intel VA-API driver for hardware video decode
    sudo apt install -y \
        intel-media-va-driver \
        vainfo \
        thermald \
        powertop \
        tlp \
        tlp-rdw \
        bolt 2>/dev/null || true

    # Enable TLP
    sudo systemctl enable tlp 2>/dev/null || true

    log "ThinkPad T480 packages installed."
    info "Run 'sudo powertop --auto-tune' for power optimization."
    info "Configure battery thresholds via TLP: /etc/tlp.conf"
}

# --- Step 19: Verify installation ---
verify_installation() {
    section "Verification"

    local failed=0
    local commands=(
        "git:git --version"
        "zsh:zsh --version"
        "node:node --version"
        "npm:npm --version"
        "rustc:rustc --version"
        "cargo:cargo --version"
        "docker:docker --version"
        "gh:gh --version"
        "fzf:fzf --version"
        "jq:jq --version"
        "helix:hx --version"
        "zellij:zellij --version"
    )

    for entry in "${commands[@]}"; do
        local name="${entry%%:*}"
        local cmd="${entry#*:}"
        if eval "$cmd" &>/dev/null; then
            log "$name: $(eval "$cmd" 2>&1 | head -1)"
        else
            warn "$name: NOT FOUND"
            ((failed++)) || true
        fi
    done

    if [[ $failed -gt 0 ]]; then
        warn "$failed tools not found. Some may need a shell restart or manual install."
    else
        log "All tools verified successfully!"
    fi
}

# --- Step 20: Summary ---
print_summary() {
    section "Migration Summary"
    echo ""
    log "Migration setup complete!"
    echo ""
    info "Backup of original files: $BACKUP_DIR"
    info "Migration log: $LOG_FILE"
    echo ""
    warn "Post-setup checklist:"
    echo "  1. Log out and back in (for zsh, docker group)"
    echo "  2. Run: gh auth login"
    echo "  3. Run: ssh-add ~/.ssh/id_ed25519"
    echo "  4. Pull Ollama models: ollama pull llama3.1:8b"
    echo "  5. Set up fcitx5: fcitx5-configtool"
    echo "  6. Clone your projects (see projects/README.md)"
    echo "  7. Set up ESP-IDF if needed (see development/README.md)"
    echo "  8. Open Claude Desktop and sign in"
    echo ""
}

# =============================================================================
# Main execution
# =============================================================================
main() {
    echo "============================================"
    echo "  Ubuntu 24.04 Migration Setup"
    echo "  From: EndeavourOS on ThinkPad T480"
    echo "  Date: $(date)"
    echo "============================================"
    echo ""

    preflight
    system_update
    install_essentials
    setup_zsh
    setup_git
    setup_ssh
    setup_nodejs
    setup_rust
    setup_docker
    setup_fcitx5
    setup_fonts
    setup_chrome
    setup_wezterm
    setup_editors
    setup_claude_desktop
    setup_ollama
    setup_obsidian
    setup_desktop_apps
    setup_thinkpad
    verify_installation
    print_summary
}

main "$@"
