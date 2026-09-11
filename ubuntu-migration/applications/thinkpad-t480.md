# ThinkPad T480 — Ubuntu 24.04 Configuration Guide

## Hardware Summary

| Component | Details | Ubuntu 24.04 Status |
|---|---|---|
| CPU | Intel Core (Kaby Lake-R, 8th Gen) | ✅ Works out of box |
| GPU | Intel UHD Graphics 620 | ✅ Works out of box |
| Wi-Fi | Intel Wireless 8265/8275 | ✅ Works out of box |
| Bluetooth | Intel (via 8265 combo card) | ✅ Works out of box |
| Ethernet | Intel I219-V | ✅ Works out of box |
| Audio | Intel Sunrise Point-LP HD Audio | ✅ PipeWire (default) |
| Storage | Samsung NVMe SSD 980 (476.9 GB) | ✅ Works out of box |
| Thunderbolt | Intel JHL6240 Alpine Ridge LP | ✅ Works (install `bolt`) |
| Webcam | Integrated | ✅ Works out of box |

**The ThinkPad T480 is exceptionally well-supported on Ubuntu 24.04. Most hardware works with zero configuration.**

---

## 1. Intel UHD 620 Graphics

**Status**: Works out of the box with the `i915` kernel driver.

**Hardware video acceleration** (optional, recommended):
```bash
sudo apt install intel-media-va-driver vainfo
# Verify:
vainfo
```

**External monitors**: Supported via Thunderbolt 3 / USB-C port. Use GNOME Settings → Displays or `xrandr` for configuration.

No additional drivers or PPAs are needed.

## 2. Wi-Fi (Intel 8265)

**Status**: Works out of the box with the `iwlwifi` driver. Firmware is included in Ubuntu's `linux-firmware` package.

No action required.

## 3. Bluetooth

**Status**: Works out of the box via the Intel 8265 combo card.

Ubuntu's GNOME desktop includes Bluetooth settings. If using a different desktop:
```bash
sudo apt install blueman
```

## 4. Touchpad

**Status**: Works out of the box with `libinput`.

Configure via GNOME Settings → Mouse & Touchpad. For fine-tuning:
```bash
# List devices
xinput list
# Show properties
xinput list-props "SynPS/2 Synaptics TouchPad"
```

## 5. Keyboard & Function Keys

**Status**: ThinkPad-specific keys (brightness, volume, mic mute, etc.) work out of the box via the `thinkpad_acpi` kernel module.

**Fn-Lock toggle**: Press `Fn + Esc` or change in BIOS (F1 at boot → Config → Keyboard).

The `thinkpad_acpi` module loads automatically. No configuration needed.

## 6. Suspend/Resume

**Status**: Generally works well on T480.

**If you experience issues**, check the sleep mode:
```bash
cat /sys/power/mem_sleep
# Should show: s2idle [deep]
# "deep" (S3) is more reliable on T480
```

To force deep sleep if needed:
```bash
# Add to kernel parameters via GRUB:
# GRUB_CMDLINE_LINUX_DEFAULT="... mem_sleep_default=deep"
# Then: sudo update-grub
```

Most T480 users have no suspend issues on Ubuntu 24.04.

## 7. Battery & Power Management

**Status**: Dual battery system works out of the box.

**Install TLP for better battery life:**
```bash
sudo apt install tlp tlp-rdw
sudo systemctl enable tlp
sudo systemctl start tlp
```

**Battery charge thresholds** (extend battery lifespan):
```bash
# Edit /etc/tlp.conf:
START_CHARGE_THRESH_BAT0=75
STOP_CHARGE_THRESH_BAT0=80
START_CHARGE_THRESH_BAT1=75
STOP_CHARGE_THRESH_BAT1=80
```

**Power analysis:**
```bash
sudo apt install powertop
sudo powertop  # Interactive view
sudo powertop --auto-tune  # Apply all optimizations (review first)
```

## 8. Power Management

Ubuntu 24.04 includes `power-profiles-daemon` by default (Balanced / Power Saver / Performance).

**If using TLP instead**, disable `power-profiles-daemon`:
```bash
sudo systemctl mask power-profiles-daemon
```

**Intel thermal management:**
```bash
sudo apt install thermald
sudo systemctl enable thermald
```

## 9. External Monitor

- **USB-C / Thunderbolt 3**: Direct DisplayPort Alt Mode. Works with USB-C to HDMI/DP adapters.
- **ThinkPad dock**: Works via Thunderbolt. Install `bolt` if dock isn't recognized.

```bash
sudo apt install bolt
# List Thunderbolt devices:
boltctl list
```

Use GNOME Settings → Displays or `xrandr`:
```bash
xrandr --output DP-1 --auto --right-of eDP-1
```

## 10. Audio

**Status**: Works out of the box with PipeWire (default on Ubuntu 24.04).

**Volume control:**
```bash
sudo apt install pavucontrol
```

If audio output isn't detected after suspend/resume:
```bash
systemctl --user restart pipewire pipewire-pulse wireplumber
```

## 11. Webcam

**Status**: Works out of the box via `uvcvideo` driver.

Test with:
```bash
# GNOME: Cheese app
# CLI: ffplay /dev/video0
```

## 12. Thunderbolt 3

**Status**: Works. Install `bolt` for device authorization management:

```bash
sudo apt install bolt
boltctl list       # List devices
boltctl authorize  # Authorize a device
```

---

## Recommended Post-Install Packages

```bash
sudo apt install \
    intel-media-va-driver \
    vainfo \
    thermald \
    tlp \
    tlp-rdw \
    powertop \
    bolt
```

## What NOT to Do

- ❌ Don't install proprietary NVIDIA drivers (no NVIDIA GPU in T480)
- ❌ Don't apply random kernel boot parameters without reason
- ❌ Don't disable the `i915` module
- ❌ Don't install `xf86-video-intel` — the modesetting driver is better on modern kernels
- ❌ Don't downgrade the kernel unless specifically troubleshooting
