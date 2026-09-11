# Project Migration Guide

## ⚠️ CRITICAL — Projects with Uncommitted Changes

These projects have local modifications that will be **LOST** if not committed/pushed before wiping EndeavourOS.

### 1. HYDRAGROW — 27 uncommitted files!

| Field | Details |
|-------|---------|
| **Location** | `~/HYDRAGROW` |
| **Remote** | https://github.com/nplongx/HYDRAGROW.git |
| **Branch** | `feat/remove-manual-api-key` |
| **Status** | **27 modified files — MUST COMMIT AND PUSH** |
| **Type** | IoT/Embedded (ESP32 hydroponics system) |
| **Related** | `~/hydragrow-backend-lane`, `~/hydragrow-ci-lane`, `~/hydragrow-docs-lane`, `~/hydragrow-frontend-lane` |

**Before migration:**
```bash
cd ~/HYDRAGROW
git add -A
git commit -m "WIP: pre-migration snapshot"
git push origin feat/remove-manual-api-key
```

**On Ubuntu:**
```bash
git clone https://github.com/nplongx/HYDRAGROW.git
cd HYDRAGROW
git checkout feat/remove-manual-api-key
```

**Dependencies**: ESP-IDF, Rust ESP toolchain, Node.js, PlatformIO
**Do NOT copy**: `node_modules/`, `target/`, `build/`, `.pio/`, `__pycache__/`
**Recreate on Ubuntu**: `.env` files, ESP-IDF environment

---

### 2. frontend — 6 uncommitted files + NO REMOTE!

| Field | Details |
|-------|---------|
| **Location** | `~/frontend` |
| **Remote** | **⚠️ NONE — no remote configured!** |
| **Branch** | `master` |
| **Status** | **6 modified files** |
| **Type** | Gleam project (`gleam.toml`) |

**⚠️ This project has no remote repository! It cannot be cloned on Ubuntu.**

**Before migration, you MUST either:**

Option A — Create a GitHub repo and push:
```bash
cd ~/frontend
gh repo create nplongx/frontend --private --source=. --push
```

Option B — Copy the directory to the migration bundle:
```bash
cp -r ~/frontend /path/to/migration-bundle/projects/frontend-source/
```

**Dependencies**: Gleam, Erlang
**Do NOT copy**: `build/`, `_gleam_artefacts/`

---

## Safe to Clone — Clean Projects with Remotes

These projects are clean (no uncommitted changes) and can be cloned fresh on Ubuntu.

### 3. figma-mcp-server

| Field | Details |
|-------|---------|
| **Location** | `~/figma-mcp-server` |
| **Remote** | https://github.com/Antonytm/figma-mcp-server.git |
| **Branch** | `main` |
| **Status** | Clean |

```bash
git clone https://github.com/Antonytm/figma-mcp-server.git
```

### 4. test-c-in-rust (c-in-rust-esp32)

| Field | Details |
|-------|---------|
| **Location** | `~/test-c-in-rust` |
| **Remote** | git@github.com:nplongx/c-in-rust-esp32.git |
| **Branch** | `main` |
| **Status** | Clean |
| **Type** | Rust embedded (ESP32, Cargo.toml) |

```bash
git clone git@github.com:nplongx/c-in-rust-esp32.git test-c-in-rust
```

**Dependencies**: Rust ESP toolchain, espflash

### 5. superpowers

| Field | Details |
|-------|---------|
| **Location** | `~/superpowers` |
| **Remote** | https://github.com/obra/superpowers.git |
| **Branch** | `main` |
| **Status** | Clean |
| **Type** | Node.js (package.json) |

```bash
git clone https://github.com/obra/superpowers.git
```

### 6. Migrating-to-Ubuntu

| Field | Details |
|-------|---------|
| **Location** | `~/Migrating-to-Ubuntu` |
| **Remote** | git@github.com:nplongx/Migrating-to-Ubuntu.git |
| **Branch** | `main` |
| **Status** | Clean |

This is the current migration project. Already tracked.

---

## Recreate on Ubuntu — Do NOT Copy

### 7. ESP-IDF Frameworks

| Version | Location |
|---------|----------|
| v5.0.7 | `~/esp/esp-idf-v5.0.7` |
| v5.2.3 | `~/esp/esp-idf-v5.2.3` |
| v5.3.4 | `~/esp/esp-idf-v5.3.4` |

**Do NOT copy these.** Install fresh on Ubuntu:
```bash
mkdir -p ~/esp && cd ~/esp
git clone -b v5.3.4 --recursive https://github.com/espressif/esp-idf.git esp-idf-v5.3.4
cd esp-idf-v5.3.4 && ./install.sh
```

### 8. Espressif Tools (`~/.espressif/`)

Recreated automatically by ESP-IDF `install.sh`. Do NOT copy.

### 9. PlatformIO (`~/.platformio/`)

Recreated automatically by PlatformIO. Do NOT copy.
```bash
pipx install platformio
```

---

## Data to Migrate Manually

### 10. Obsidian Vault

| Field | Details |
|-------|---------|
| **Location** | `~/Documents/Take-notes-or-die-main` |
| **Type** | Notes (Obsidian vault) |

Check if it has a `.git` directory:
```bash
ls -la ~/Documents/Take-notes-or-die-main/.git
```
- If git-tracked → push and clone on Ubuntu
- If not → copy the directory manually or use Obsidian Sync

### 11. Documents, Pictures, Videos

Standard user data directories. Copy manually:
```bash
rsync -avz ~/Documents/ /target/Documents/
rsync -avz ~/Pictures/ /target/Pictures/
rsync -avz ~/Videos/ /target/Videos/
```

---

## Quick Clone Script

Run this on Ubuntu to clone all projects:

```bash
#!/usr/bin/env bash
# Clone all projects

mkdir -p ~/projects
cd ~

# Your repos
git clone https://github.com/nplongx/HYDRAGROW.git
cd HYDRAGROW && git checkout feat/remove-manual-api-key && cd ..

git clone git@github.com:nplongx/c-in-rust-esp32.git test-c-in-rust
git clone git@github.com:nplongx/Migrating-to-Ubuntu.git

# Third-party repos
git clone https://github.com/Antonytm/figma-mcp-server.git
git clone https://github.com/obra/superpowers.git

echo "Done! Remember to handle ~/frontend manually (no remote)."
```

---

## Summary

| Project | Has Remote | Clean | Migration Action |
|---------|-----------|-------|-----------------|
| HYDRAGROW | ✅ | ❌ 27 files | **COMMIT & PUSH first**, then clone |
| frontend | ❌ | ❌ 6 files | **CREATE REMOTE & PUSH** or copy |
| figma-mcp-server | ✅ | ✅ | Clone fresh |
| test-c-in-rust | ✅ | ✅ | Clone fresh |
| superpowers | ✅ | ✅ | Clone fresh |
| Migrating-to-Ubuntu | ✅ | ✅ | Already tracked |
| ESP-IDF (x3) | — | — | Reinstall fresh |
| Obsidian vault | ? | ? | Check & copy/sync |
