# Ubuntu 24.04 Migration Bundle

**Source**: EndeavourOS (Arch Linux) on ThinkPad T480  
**Target**: Ubuntu 24.04 LTS  
**Created**: 2026-09-11  
**User**: nplong (nplongx)

---

## What Is This?

This is a self-contained migration bundle for moving from EndeavourOS to Ubuntu 24.04.
It contains configuration files, scripts, documentation, and manifests — everything needed
to recreate the working environment on a fresh Ubuntu installation.

## Bundle Structure

```
ubuntu-migration/
├── README.md                          ← You are here
├── manifest/
│   ├── package-mapping.md             ← Arch → Ubuntu package mapping
│   └── SUMMARY.md                     ← Migration summary & checklist
├── packages/
│   ├── pacman-explicit.txt            ← Explicitly installed pacman packages
│   ├── pacman-all.txt                 ← All installed pacman packages
│   ├── aur-packages.txt               ← AUR packages
│   ├── flatpak-apps.txt               ← Flatpak applications
│   ├── systemd-enabled.txt            ← Enabled system services
│   └── systemd-user-enabled.txt       ← Enabled user services
├── configs/
│   ├── helix/                         ← Helix editor config
│   │   ├── config.toml
│   │   └── languages.toml
│   ├── wezterm/                       ← WezTerm terminal config
│   │   └── wezterm.lua
│   ├── zellij/                        ← Zellij multiplexer config
│   │   └── config.kdl
│   ├── vscode/                        ← VS Code settings
│   │   └── settings.json
│   ├── fcitx5/                        ← Vietnamese input method config
│   │   ├── profile
│   │   ├── config
│   │   └── conf/
│   └── claude.json                    ← Claude Code config (MCP servers)
├── dotfiles/
│   ├── .zshrc                         ← Zsh config (zinit + p10k + plugins)
│   ├── .p10k.zsh                      ← Powerlevel10k theme config
│   ├── .bashrc                        ← Bash config
│   ├── .bash_profile                  ← Bash profile
│   ├── .profile                       ← Login profile
│   ├── .gitconfig                     ← Git configuration
│   └── .gitignore                     ← Global gitignore
├── ssh/                               ← ⚠️  SENSITIVE — SSH keys
│   ├── WARNING.txt
│   ├── id_ed25519                     ← Private key (chmod 600)
│   ├── id_ed25519.pub                 ← Public key
│   └── known_hosts                    ← Known hosts
├── gpg/                               ← Empty (no GPG keys found)
├── systemd/                           ← Empty (no custom user services)
├── scripts/                           ← Custom scripts
├── fonts/                             ← JetBrains Mono Nerd Font (99 files)
├── projects/
│   └── README.md                      ← Project catalog & migration guide
├── applications/
│   └── thinkpad-t480.md               ← ThinkPad T480 Ubuntu guide
├── development/
│   └── README.md                      ← Dev environment setup guide
├── backup/
│   └── VERIFY.md                      ← Backup verification checksums
└── install/
    └── setup-ubuntu.sh                ← Main Ubuntu setup script
```

## Quick Start

### On EndeavourOS (Before Migration)

1. **⚠️ CRITICAL**: Commit and push uncommitted project changes:
   ```bash
   cd ~/HYDRAGROW && git add -A && git commit -m "pre-migration" && git push
   cd ~/frontend && gh repo create nplongx/frontend --private --source=. --push
   ```

2. Copy this `ubuntu-migration/` directory to a USB drive or cloud storage.

3. Copy personal data you need:
   ```bash
   # Obsidian vault
   rsync -avz ~/Documents/Take-notes-or-die-main /path/to/usb/

   # Other documents, pictures, videos as needed
   ```

### On Ubuntu 24.04 (After Installation)

1. Copy the `ubuntu-migration/` directory to your home folder.

2. Run the setup script:
   ```bash
   cd ~/ubuntu-migration/install
   bash setup-ubuntu.sh
   ```

3. Log out and back in (for zsh and docker group).

4. Complete post-setup:
   ```bash
   gh auth login
   ssh-add ~/.ssh/id_ed25519
   ssh -T git@github.com
   fcitx5-configtool
   ```

5. Clone your projects (see `projects/README.md`).

## Security Notes

- `ssh/` contains your **private SSH key**. Handle securely.
- No passwords, API keys, or tokens are stored in plain text.
- The `.claude.json` contains hashed IDs, not secrets.
- Delete this bundle after successful migration.

## What Was NOT Migrated

- XFCE desktop environment (Ubuntu uses GNOME)
- Arch-specific packages (pacman, yay, AUR, dracut, etc.)
- Kernel and bootloader configuration
- System-level `/etc/` configuration
- Build caches, node_modules, target/, .pio/
- Docker images (can be re-pulled)
- Ollama models (can be re-pulled)
- ESP-IDF installations (reinstall fresh)
- Browser profiles and history
- Application caches
