# Package Mapping: Arch Linux → Ubuntu 24.04

## Migration Action Legend

| Action | Meaning |
|--------|---------|
| `MUST_MIGRATE` | Actively used; must be set up on Ubuntu |
| `SHOULD_MIGRATE` | Useful; set up when convenient |
| `REINSTALL_ON_UBUNTU` | Install using the tool's own installer, not apt |
| `ARCH_SPECIFIC` | Arch/EndeavourOS only; no Ubuntu equivalent needed |
| `DO_NOT_MIGRATE` | Handled by Ubuntu automatically or not needed |
| `OPTIONAL` | Nice to have; install if desired |

---

## Core Development Tools — MUST_MIGRATE

| Arch/AUR Package | Ubuntu Equivalent | Install Method | Action | Notes |
|---|---|---|---|---|
| git 2.55 | git | `apt` | MUST_MIGRATE | Config in dotfiles/ |
| github-cli 2.98 | gh | Official GitHub repo | MUST_MIGRATE | `gh auth login` after install |
| base-devel | build-essential | `apt` | MUST_MIGRATE | Compiler toolchain |
| docker 29.7 | docker-ce | Official Docker repo | MUST_MIGRATE | Not `docker.io` from apt |
| docker-compose 5.5 | docker-compose-plugin | Official Docker repo | MUST_MIGRATE | Plugin, not standalone |
| python 3.14 | python3 | `apt` (preinstalled) | MUST_MIGRATE | Ubuntu may have older version |
| python-pip | python3-pip | `apt` | MUST_MIGRATE | |
| python-pipx | pipx | `apt` | MUST_MIGRATE | For PlatformIO |
| postgresql 18 | postgresql | `apt` | MUST_MIGRATE | |
| erlang 29 | erlang | `apt` or Erlang Solutions | MUST_MIGRATE | |
| gleam 1.18 | gleam | Official binary | REINSTALL_ON_UBUNTU | https://gleam.run |

## Shell & Terminal — MUST_MIGRATE

| Arch/AUR Package | Ubuntu Equivalent | Install Method | Action | Notes |
|---|---|---|---|---|
| zsh 5.9 | zsh | `apt` | MUST_MIGRATE | zinit auto-installs on first run |
| wezterm-git (AUR) | wezterm | Official wezterm repo | MUST_MIGRATE | Not in Ubuntu repos |
| fzf | fzf | `apt` | MUST_MIGRATE | |
| zoxide | zoxide | `apt` or cargo | MUST_MIGRATE | |
| thefuck | thefuck | `apt` | SHOULD_MIGRATE | |
| xclip | xclip | `apt` | MUST_MIGRATE | Used by zellij |

## Editors — MUST_MIGRATE

| Arch/AUR Package | Ubuntu Equivalent | Install Method | Action | Notes |
|---|---|---|---|---|
| helix 25.07 | helix | PPA or snap | MUST_MIGRATE | Primary editor |
| neovim 0.12 | neovim | `apt` | SHOULD_MIGRATE | Installed but no custom config |

## CLI Utilities — MUST_MIGRATE

| Arch/AUR Package | Ubuntu Equivalent | Install Method | Action | Notes |
|---|---|---|---|---|
| htop | htop | `apt` | MUST_MIGRATE | |
| glances | glances | `apt` | SHOULD_MIGRATE | |
| jq | jq | `apt` | MUST_MIGRATE | |
| duf | duf | `apt` | SHOULD_MIGRATE | |
| yazi | yazi | `cargo install` | MUST_MIGRATE | Not in Ubuntu repos |
| tldr | tldr | `apt` or npm | SHOULD_MIGRATE | |
| rsync | rsync | `apt` | MUST_MIGRATE | |
| wget | wget | `apt` (preinstalled) | MUST_MIGRATE | |
| aria2 | aria2 | `apt` | SHOULD_MIGRATE | |
| inxi | inxi | `apt` | OPTIONAL | |
| strace | strace | `apt` | SHOULD_MIGRATE | |
| lsof | lsof | `apt` | SHOULD_MIGRATE | |
| ccache | ccache | `apt` | SHOULD_MIGRATE | |
| less | less | `apt` (preinstalled) | DO_NOT_MIGRATE | |

## Rust Ecosystem — REINSTALL_ON_UBUNTU

| Arch/AUR Package | Ubuntu Equivalent | Install Method | Action | Notes |
|---|---|---|---|---|
| (system rust) | rustup | rustup.rs | REINSTALL_ON_UBUNTU | Do NOT use apt rust |
| cargo-generate | cargo-generate | `cargo install` | REINSTALL_ON_UBUNTU | |
| espflash | espflash | `cargo install` | REINSTALL_ON_UBUNTU | ESP32 flashing |
| espup | espup | `cargo install` | REINSTALL_ON_UBUNTU | ESP32 Rust toolchain |
| ldproxy | ldproxy | `cargo install` | REINSTALL_ON_UBUNTU | ESP32 linker |
| sqlx-cli | sqlx-cli | `cargo install` | REINSTALL_ON_UBUNTU | Database migrations |
| zellij | zellij | `cargo install` | REINSTALL_ON_UBUNTU | Terminal multiplexer |

## Node.js Ecosystem — REINSTALL_ON_UBUNTU

| Arch/AUR Package | Ubuntu Equivalent | Install Method | Action | Notes |
|---|---|---|---|---|
| (NVM) | nvm | curl installer | REINSTALL_ON_UBUNTU | v0.40.x |
| (node v24) | node v24 | via NVM | REINSTALL_ON_UBUNTU | |
| (dprint) | dprint | official installer | REINSTALL_ON_UBUNTU | Code formatter |

## Desktop Applications — MUST_MIGRATE

| Arch/AUR Package | Ubuntu Equivalent | Install Method | Action | Notes |
|---|---|---|---|---|
| firefox | firefox | snap (preinstalled) | DO_NOT_MIGRATE | Already on Ubuntu |
| google-chrome (AUR) | google-chrome-stable | Official Google repo | MUST_MIGRATE | |
| libreoffice-fresh | libreoffice | `apt` (preinstalled) | DO_NOT_MIGRATE | Already on Ubuntu |
| obsidian | Obsidian | Flatpak or AppImage | MUST_MIGRATE | Notes app |
| scrcpy | scrcpy | `apt` | SHOULD_MIGRATE | Android mirroring |
| kdeconnect | kdeconnect | `apt` | SHOULD_MIGRATE | |
| meld | meld | `apt` | MUST_MIGRATE | Diff tool |
| okular | okular | `apt` | SHOULD_MIGRATE | PDF viewer |
| copyq | copyq | `apt` | SHOULD_MIGRATE | Clipboard manager |
| flatpak | flatpak | `apt` | MUST_MIGRATE | |

## Input Method — MUST_MIGRATE

| Arch/AUR Package | Ubuntu Equivalent | Install Method | Action | Notes |
|---|---|---|---|---|
| fcitx5 | fcitx5 | `apt` | MUST_MIGRATE | Input framework |
| fcitx5-unikey | fcitx5-unikey | `apt` | MUST_MIGRATE | Vietnamese input |
| fcitx5-configtool | fcitx5-config-qt | `apt` | MUST_MIGRATE | |
| fcitx5-gtk | fcitx5-frontend-gtk3 | `apt` | MUST_MIGRATE | |
| fcitx5-qt | fcitx5-frontend-qt5 | `apt` | MUST_MIGRATE | |

## AI/Coding Tools — REINSTALL_ON_UBUNTU

| Arch/AUR Package | Ubuntu Equivalent | Install Method | Action | Notes |
|---|---|---|---|---|
| ollama | ollama | Official install script | REINSTALL_ON_UBUNTU | AI inference |
| (Claude Desktop) | claude-desktop | Official Anthropic .deb | REINSTALL_ON_UBUNTU | |
| (Claude Code CLI) | claude | Official installer | REINSTALL_ON_UBUNTU | |
| (Antigravity CLI) | agy | Official installer | REINSTALL_ON_UBUNTU | |
| (Zed) | zed | Official install script | REINSTALL_ON_UBUNTU | |

## Fonts — MUST_MIGRATE

| Arch/AUR Package | Ubuntu Equivalent | Install Method | Action | Notes |
|---|---|---|---|---|
| noto-fonts | fonts-noto | `apt` | MUST_MIGRATE | |
| noto-fonts-cjk | fonts-noto-cjk | `apt` | MUST_MIGRATE | CJK support |
| noto-fonts-emoji | fonts-noto-color-emoji | `apt` | MUST_MIGRATE | |
| ttf-dejavu | fonts-dejavu | `apt` | MUST_MIGRATE | |
| ttf-liberation | fonts-liberation | `apt` | MUST_MIGRATE | |
| (JetBrains Mono NF) | — | From migration bundle | MUST_MIGRATE | 99 font files in fonts/ |

## Hardware/Drivers — DO_NOT_MIGRATE

| Arch/AUR Package | Ubuntu Equivalent | Install Method | Action | Notes |
|---|---|---|---|---|
| intel-ucode | intel-microcode | `apt` (auto) | DO_NOT_MIGRATE | Ubuntu handles this |
| intel-media-driver | intel-media-va-driver | `apt` | DO_NOT_MIGRATE | Install for VA-API |
| vulkan-intel | mesa-vulkan-drivers | `apt` | DO_NOT_MIGRATE | |
| linux / linux-lts | linux-image-generic | `apt` (auto) | DO_NOT_MIGRATE | |
| linux-firmware | linux-firmware | `apt` (auto) | DO_NOT_MIGRATE | |
| sof-firmware | firmware-sof-signed | `apt` (auto) | DO_NOT_MIGRATE | |
| pipewire-* | pipewire (preinstalled) | — | DO_NOT_MIGRATE | Default on Ubuntu 24.04 |
| networkmanager | network-manager | — | DO_NOT_MIGRATE | Default on Ubuntu |
| bluez | bluez | `apt` (preinstalled) | DO_NOT_MIGRATE | |

## ARCH_SPECIFIC — Do Not Migrate

| Arch/AUR Package | Notes |
|---|---|
| pacman-contrib | Arch package manager utils |
| yay | AUR helper — no AUR on Ubuntu |
| reflector, reflector-simple | Arch mirrorlist tool |
| downgrade | Arch package downgrader |
| dracut, eos-dracut | Arch initramfs (Ubuntu uses initramfs-tools) |
| eos-*, endeavouros-* | EndeavourOS branding/tools (12 packages) |
| grub | Ubuntu manages its own GRUB |
| lightdm, lightdm-slick-greeter | Ubuntu uses GDM3 |
| xfce4-*, xfwm4, xfdesktop, xfconf, exo, garcon, thunar-* | XFCE desktop (Ubuntu uses GNOME) |
| rebuild-detector | Arch rebuild checker |
| pkgfile | Arch package file search |
| hwdetect | Arch hardware detection |
| iwd | Arch wireless daemon |
| netctl | Arch network config |
| welcome | EndeavourOS welcome app |
| arc-gtk-theme-eos | EndeavourOS theme |

## Flatpak Applications

| Flatpak App | Action | Notes |
|---|---|---|
| Gear Lever (it.mijorus.gearlever) | SHOULD_MIGRATE | AppImage manager |

## AppImages (Portable — Just Copy)

| AppImage | Action | Notes |
|---|---|---|
| FreeCAD 1.1.1 | OPTIONAL | Copy to ~/Applications/ |
| KiCad 10.0.x | OPTIONAL | Or install via PPA |
| MQTTX | OPTIONAL | MQTT client |
| EEZ Studio | OPTIONAL | Electronics design |
| LocalSend | OPTIONAL | File sharing |
