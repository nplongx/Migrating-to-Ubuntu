# Development Environment — Ubuntu 24.04 Setup Guide

This documents how to recreate the development environment found on EndeavourOS.

---

## Shell & Terminal

### Zsh + Zinit + Powerlevel10k

**What**: Zsh shell with zinit plugin manager, powerlevel10k prompt, and several plugins.

**Install on Ubuntu:**
```bash
sudo apt install zsh
chsh -s $(which zsh)
# Log out and back in
```

Zinit and plugins auto-install on first shell launch — the `.zshrc` from the migration bundle handles everything. Plugins installed:
- `romkatv/powerlevel10k` — fast prompt theme
- `zsh-users/zsh-syntax-highlighting`
- `zsh-users/zsh-completions`
- `zsh-users/zsh-autosuggestions`
- `Aloxaf/fzf-tab` — fzf-powered tab completion

**Migrated config**: `dotfiles/.zshrc`, `dotfiles/.p10k.zsh`

**Note**: The `.zshrc` references `OMZP::archlinux` snippet — this is automatically patched out by `setup-ubuntu.sh`.

### WezTerm

**What**: GPU-accelerated terminal emulator with Lua configuration.

**Install on Ubuntu:**
```bash
curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /etc/apt/keyrings/wezterm-fury.gpg
echo 'deb [signed-by=/etc/apt/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
sudo apt update && sudo apt install -y wezterm
```

**Migrated config**: `configs/wezterm/wezterm.lua`
- Custom mouse bindings (triple-click semantic zone, Ctrl+click hyperlinks)

### Zellij

**What**: Terminal multiplexer (tmux alternative) written in Rust.

**Install on Ubuntu:**
```bash
cargo install zellij
```

**Migrated config**: `configs/zellij/config.kdl`
- Uses `xclip` for clipboard (`copy_command "xclip -selection clipboard"`)

---

## Git & Authentication

### Git

**Config**: `dotfiles/.gitconfig`
- User: `nplongx` / `nplong.dev@gmail.com`
- HTTP buffer sizes configured for large repos
- GitHub credential helper via `gh auth git-credential`

### GitHub CLI (gh)

**Install:**
```bash
# Installed by setup-ubuntu.sh via official GitHub repo
gh auth login
```

### SSH

**Key type**: ed25519
**Migrated**: `ssh/id_ed25519`, `ssh/id_ed25519.pub`, `ssh/known_hosts`

After restoring:
```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub
ssh-add ~/.ssh/id_ed25519
# Test: ssh -T git@github.com
```

### GPG

**No GPG keys found** on the system. No migration needed.

---

## Editors

### Helix (Primary Editor)

**What**: Modern modal text editor (Kakoune-inspired, Rust-based). Used as primary editor with alias `hx`.

**Install on Ubuntu:**
```bash
sudo add-apt-repository ppa:maveonair/helix-editor
sudo apt update && sudo apt install helix
```

**Migrated config**: `configs/helix/config.toml`, `configs/helix/languages.toml`

Config includes:
- Vim-like keybindings in select mode
- Clipboard integration (yank/paste to system clipboard)
- Custom LSP configurations for Rust, TypeScript, JavaScript, HTML, CSS, JSON, SCSS
- Auto-format enabled
- Formatters: `dprint` (TS/JS/JSON), `prettier` (HTML/CSS)
- `rust-analyzer` with clippy checks enabled

**Language servers to install:**
```bash
npm install -g typescript-language-server typescript
npm install -g vscode-langservers-extracted  # HTML, CSS, JSON, ESLint
npm install -g emmet-ls
# rust-analyzer comes with rustup
```

### Neovim

**What**: Installed but no custom configuration was detected. Available for use.

```bash
sudo apt install neovim
```

### Zed

**What**: GPU-accelerated GUI code editor.

```bash
curl -f https://zed.dev/install.sh | sh
```

### VS Code

**What**: Minimal configuration found (Dart settings, autoSave).

**Migrated config**: `configs/vscode/settings.json`

Install VS Code from https://code.visualstudio.com/ or:
```bash
sudo snap install code --classic
```

---

## Node.js Ecosystem

### NVM + Node.js

**What**: Node Version Manager managing Node.js v24.19.0.

**Install:**
```bash
export NVM_DIR="$HOME/.config/nvm"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
source "$NVM_DIR/nvm.sh"
nvm install 24
nvm alias default 24
```

### dprint

**What**: Fast code formatter (used by Helix for TypeScript/JavaScript/JSON).

```bash
curl -fsSL https://dprint.dev/install.sh | sh
```

Installed at `~/.dprint/bin/dprint`. PATH is set in `.zshrc`.

---

## Python

### System Python
Ubuntu 24.04 ships Python 3.12. The Arch system had Python 3.14.

### pipx + PlatformIO
```bash
sudo apt install pipx
pipx install platformio
```

PlatformIO provides `pio`, `platformio` commands for embedded development.

---

## Rust Ecosystem

### rustup + Toolchains

**Install:**
```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"
```

**Toolchains to install:**
```bash
rustup toolchain install stable     # Default
rustup toolchain install nightly

# ESP32 RISC-V targets
rustup target add riscv32imac-unknown-none-elf
rustup target add riscv32imafc-unknown-none-elf
rustup target add riscv32imc-unknown-none-elf
```

### Cargo-installed tools

```bash
cargo install cargo-generate  # Project scaffolding
cargo install espflash        # ESP32 flashing
cargo install espup           # ESP32 Rust toolchain manager
cargo install ldproxy          # ESP32 linker proxy
cargo install sqlx-cli         # Database migrations (PostgreSQL)
cargo install zellij           # Terminal multiplexer
```

### ESP32 Xtensa Toolchain

After installing `espup`:
```bash
espup install
```

This creates the `esp` Rust toolchain and sets up `LIBCLANG_PATH` and Xtensa tools. The `export-esp.sh` from the old system configured:
- `LIBCLANG_PATH` → `~/.rustup/toolchains/esp/xtensa-esp32-elf-clang/...`
- `PATH` → `~/.rustup/toolchains/esp/xtensa-esp-elf/.../bin`

---

## Erlang & Gleam

```bash
# Erlang
sudo apt install erlang

# Gleam
curl -fsSL https://gleam.run/install.sh | sh

# rebar3 (Erlang build tool)
sudo apt install rebar3
# Or: mix local.rebar (if using Elixir)
```

---

## Docker

**Install via official Docker CE repo** (NOT `docker.io` from Ubuntu repos):
```bash
# Add Docker's official GPG key and repo
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker $USER
# Log out and back in
```

---

## Databases

### PostgreSQL

```bash
sudo apt install postgresql postgresql-client
sudo systemctl enable postgresql
```

### SQLx CLI (Rust)

```bash
cargo install sqlx-cli
```

---

## ESP-IDF (Embedded Development)

ESP-IDF should be installed fresh on Ubuntu. **Do not copy from Arch.**

```bash
# Install prerequisites
sudo apt install git wget flex bison gperf python3 python3-pip python3-venv cmake ninja-build ccache libffi-dev libssl-dev dfu-util libusb-1.0-0

# Clone ESP-IDF (pick version needed)
mkdir -p ~/esp
cd ~/esp
git clone -b v5.3.4 --recursive https://github.com/espressif/esp-idf.git esp-idf-v5.3.4
cd esp-idf-v5.3.4
./install.sh

# Source environment when needed:
. ~/esp/esp-idf-v5.3.4/export.sh
```

---

## AI / Coding Assistants

### Claude Desktop
```bash
curl -fsSL https://storage.googleapis.com/anthropic-desktop-releases/claude-desktop/latest/linux/claude-desktop_amd64.deb -o /tmp/claude-desktop.deb
sudo apt install -y /tmp/claude-desktop.deb
```

### Claude Code CLI
```bash
# Via official installer (check https://docs.anthropic.com/en/docs/claude-code)
npm install -g @anthropic-ai/claude-code
# Or use the native installer
```

### Ollama
```bash
curl -fsSL https://ollama.com/install.sh | sh
# Pull previously used models:
ollama pull llama3.1:8b
ollama pull qwen2.5-coder:7b
```

### Antigravity CLI (agy)
Follow official installation instructions from the Antigravity documentation.

### Codegraph
Follow installation instructions from the codegraph repository.

---

## CLI Tools Quick Reference

| Tool | Install | Purpose |
|------|---------|---------|
| fzf | `apt` | Fuzzy finder |
| zoxide | `apt` | Smart `cd` (use `z` command) |
| yazi | `cargo install yazi-fm yazi-cli` | Terminal file manager |
| jq | `apt` | JSON processor |
| htop | `apt` | Interactive process viewer |
| glances | `apt` | System monitor |
| tldr | `apt` | Simplified man pages |
| thefuck | `apt` | Command correction |
| duf | `apt` | Disk usage (modern `df`) |
| ripgrep | `apt install ripgrep` | Fast grep |
| fd-find | `apt install fd-find` | Fast find |
| gh | Official repo | GitHub CLI |

---

## Post-Setup Checklist

1. ☐ Run `setup-ubuntu.sh`
2. ☐ Log out and back in (zsh, docker group)
3. ☐ `gh auth login`
4. ☐ `ssh-add ~/.ssh/id_ed25519`
5. ☐ `ssh -T git@github.com` — verify SSH works
6. ☐ Install language servers for Helix (see Editors section)
7. ☐ Set up fcitx5: `fcitx5-configtool`
8. ☐ Install ESP-IDF if doing embedded work
9. ☐ Pull Ollama models
10. ☐ Open Claude Desktop and sign in
11. ☐ Clone projects (see `projects/README.md`)
