# Migration Summary

**Source**: EndeavourOS (Arch Linux) — ThinkPad T480  
**Target**: Ubuntu 24.04 LTS  
**Generated**: 2026-09-11  
**Bundle Size**: ~230 MB (fonts)  
**Total Files**: 133

---

## What Was Migrated

### Configuration Files (MUST_MIGRATE)
| File | Purpose | Location in Bundle |
|------|---------|-------------------|
| `.zshrc` | Zsh config (zinit, p10k, plugins, aliases) | `dotfiles/` |
| `.p10k.zsh` | Powerlevel10k prompt theme | `dotfiles/` |
| `.bashrc` | Bash config | `dotfiles/` |
| `.bash_profile` | Bash login profile | `dotfiles/` |
| `.profile` | Login profile | `dotfiles/` |
| `.gitconfig` | Git user, credential helpers, HTTP settings | `dotfiles/` |
| `.gitignore` | Global gitignore | `dotfiles/` |
| `config.toml` | Helix editor config (vim keybindings) | `configs/helix/` |
| `languages.toml` | Helix LSP/formatter config | `configs/helix/` |
| `wezterm.lua` | WezTerm terminal config | `configs/wezterm/` |
| `config.kdl` | Zellij multiplexer config | `configs/zellij/` |
| `settings.json` | VS Code settings | `configs/vscode/` |
| fcitx5 config | Vietnamese input method | `configs/fcitx5/` |
| `claude.json` | Claude Code MCP server config | `configs/` |

### SSH Keys (SENSITIVE)
| File | Notes |
|------|-------|
| `id_ed25519` | Private key — chmod 600 |
| `id_ed25519.pub` | Public key |
| `known_hosts` | SSH known hosts |

### Fonts
| Font | Files |
|------|-------|
| JetBrains Mono Nerd Font | 99 .ttf files |

### Package Manifests
| File | Contents |
|------|----------|
| `pacman-explicit.txt` | 256 explicitly installed packages |
| `pacman-all.txt` | 1256 total packages |
| `aur-packages.txt` | 5 AUR packages |
| `flatpak-apps.txt` | 1 Flatpak app (Gear Lever) |
| `systemd-enabled.txt` | 16 enabled system services |
| `systemd-user-enabled.txt` | 7 enabled user services |

---

## What Was Skipped

| Category | Reason |
|----------|--------|
| XFCE desktop environment | Ubuntu uses GNOME |
| EndeavourOS packages (eos-*, endeavouros-*) | Arch-specific |
| Arch package management (yay, pacman-contrib, reflector) | No AUR on Ubuntu |
| Kernel/bootloader config | Ubuntu manages its own |
| System `/etc/` configuration | Arch-specific paths/formats |
| Browser profiles/history | Platform-specific caches |
| Docker images | Re-pull on Ubuntu |
| Ollama models (llama3.1:8b, qwen2.5-coder:7b) | Re-pull on Ubuntu |
| ESP-IDF installations (3 versions) | Reinstall fresh |
| PlatformIO cache (~/.platformio) | Recreated automatically |
| Node modules, Rust targets, build caches | Recreated by package managers |
| neovim config | None found (no custom config) |
| GPG keys | None found |
| Custom user systemd services | None found |
| Cron jobs | None found |

---

## What Must Be Manually Handled

### ⚠️ CRITICAL — Before Wiping EndeavourOS

1. **HYDRAGROW project**: 27 uncommitted files on branch `feat/remove-manual-api-key`
   ```bash
   cd ~/HYDRAGROW && git add -A && git commit -m "pre-migration" && git push
   ```

2. **frontend project**: 6 uncommitted files AND **no remote repository**
   ```bash
   cd ~/frontend && gh repo create nplongx/frontend --private --source=. --push
   ```

3. **Obsidian vault** (`~/Documents/Take-notes-or-die-main`): Verify if git-tracked and copy manually.

4. **Personal files**: Copy `~/Documents/`, `~/Pictures/`, `~/Videos/`, `~/Music/` as needed.

### Post-Migration Manual Steps

1. `gh auth login` — re-authenticate GitHub CLI
2. `ssh-add ~/.ssh/id_ed25519` — add SSH key to agent
3. `fcitx5-configtool` — configure Vietnamese input
4. `ollama pull llama3.1:8b` — re-download AI models
5. Sign in to Claude Desktop
6. Sign in to Google Chrome and Firefox
7. Open Obsidian and point to vault location

---

## Arch-Specific Items (Not Applicable on Ubuntu)

| Item | Notes |
|------|-------|
| `yay` AUR helper | No AUR on Ubuntu |
| `dracut` initramfs | Ubuntu uses `initramfs-tools` |
| `lightdm` + slick-greeter | Ubuntu uses GDM3 |
| XFCE4 desktop (28+ packages) | Ubuntu uses GNOME |
| `pacman-contrib` | Arch package tools |
| `reflector` | Arch mirrorlist optimizer |
| `downgrade` | Arch package downgrader |
| `export-esp.sh` Arch paths | Paths will differ on Ubuntu |
| `OMZP::archlinux` zsh snippet | Auto-patched out by setup script |

---

## Sensitive Files Included

| File | Location | Risk |
|------|----------|------|
| SSH private key | `ssh/id_ed25519` | **HIGH** — contains private key |
| SSH public key | `ssh/id_ed25519.pub` | Low — public information |
| SSH known hosts | `ssh/known_hosts` | Low — server fingerprints |

**No passwords, API keys, or tokens were included in the bundle.**

---

## Estimated Migration Time

| Step | Time |
|------|------|
| Fresh Ubuntu 24.04 install | ~20 min |
| Run `setup-ubuntu.sh` | ~30-45 min (downloads) |
| Rust toolchain + cargo tools | ~15-20 min |
| Clone projects + npm/cargo install | ~10-15 min |
| Manual configuration (fcitx5, logins) | ~10 min |
| **Total** | **~1.5-2 hours** |

---

## Major Applications Detected

| Application | Version | Migration Method |
|-------------|---------|-----------------|
| Firefox | 154.0 | Preinstalled on Ubuntu |
| Google Chrome | 152.0 | Official .deb repo |
| LibreOffice | 26.8 | Preinstalled on Ubuntu |
| Obsidian | 1.13.7 | Flatpak |
| WezTerm | git build | Official apt repo |
| Helix | 25.07 | PPA or snap |
| Zed | latest | Official installer |
| VS Code | installed | Snap or .deb |
| Docker | 29.7.2 | Official Docker repo |
| Ollama | latest | Official installer |
| Claude Desktop | — | Official Anthropic .deb |
| KiCad | 10.0 | PPA or AppImage |
| FreeCAD | 1.1.1 | AppImage |

## Major Development Tools Detected

| Tool | Version | Migration Method |
|------|---------|-----------------|
| Git | 2.55 | apt |
| GitHub CLI | 2.98 | Official repo |
| Node.js | v24.19.0 | NVM |
| Python | 3.14 | apt (system) |
| Rust | stable + nightly + esp | rustup |
| Erlang | 29 | apt |
| Gleam | 1.18.1 | Official binary |
| Docker Compose | 5.5 | Docker plugin |
| PostgreSQL | 18 | apt |
| PlatformIO | latest | pipx |
| ESP-IDF | v5.0.7, v5.2.3, v5.3.4 | Fresh install |

---

## Next Steps on Ubuntu

```bash
# 1. Copy migration bundle to Ubuntu
# 2. Run the setup script:
cd ~/ubuntu-migration/install
bash setup-ubuntu.sh

# 3. Log out and back in (for zsh + docker group)

# 4. Post-setup:
gh auth login
ssh-add ~/.ssh/id_ed25519
ssh -T git@github.com

# 5. Clone projects:
cd ~
git clone https://github.com/nplongx/HYDRAGROW.git
git clone git@github.com:nplongx/c-in-rust-esp32.git test-c-in-rust
git clone https://github.com/Antonytm/figma-mcp-server.git
git clone https://github.com/obra/superpowers.git

# 6. Pull Ollama models:
ollama pull llama3.1:8b
ollama pull qwen2.5-coder:7b

# 7. Configure input method:
fcitx5-configtool
```
