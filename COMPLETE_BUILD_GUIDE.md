# mythOS Complete Build Guide

**Building a Fully Functional Operating System from Scratch**

This guide covers building mythOS with all features implemented:
- ✅ Disk installer for permanent installation
- ✅ WebDT 366 hardware support (i586/i686)
- ✅ All 5 editions (Chase, Pegasus, Nekomata, Hydra, Dragon)
- ✅ Complete GUI desktop environment
- ✅ Audio subsystem (ALSA)
- ✅ Network configuration tools
- ✅ System administration tools
- ✅ Testing infrastructure

---

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Quick Start](#quick-start)
3. [Building Individual Editions](#building-individual-editions)
4. [Building All Editions](#building-all-editions)
5. [Testing](#testing)
6. [Installation](#installation)
7. [Features Guide](#features-guide)
8. [Troubleshooting](#troubleshooting)

---

## Prerequisites

### Build Machine Requirements

- **OS:** Linux (Ubuntu 20.04+ recommended)
- **CPU:** 4+ cores (for parallel builds)
- **RAM:** 8GB minimum, 16GB recommended
- **Disk:** 30GB free space (15GB per edition)
- **Time:** 1-3 hours per edition

### Install Dependencies

```bash
sudo apt-get update
sudo apt-get install -y \
    build-essential gcc g++ make patch perl python3 python3-pip \
    wget rsync cpio unzip bc flex bison \
    libncurses5-dev libssl-dev device-tree-compiler \
    qemu-system-x86 qemu-system-i386 \
    genisoimage syslinux isolinux \
    parted dosfstools mtools \
    imagemagick optipng \
    git
```

---

## Quick Start

### 1. Clone Repository

```bash
cd ~/
git clone https://github.com/Nightmare17726/mythOS.git
cd mythOS/build-system
```

### 2. Generate Placeholder Mascots

```bash
cd scripts
./generate-placeholder-mascots.sh
```

### 3. Build Chase Edition (Fastest)

```bash
./build-mythos-chase.sh
```

This builds the minimal terminal-only edition (~50MB).

### 4. Test in QEMU

```bash
cd ../testing
./test-chase.sh
```

---

## Building Individual Editions

Each edition has its own build script:

### Chase Edition (50MB, Terminal Only)

```bash
cd build-system/scripts
./build-mythos-chase.sh
```

**Build time:** 30-60 minutes
**Target:** Minimal, fast, terminal-only
**Features:** BusyBox, Links browser, SSH, networking

### Pegasus Edition (85MB, Simple GUI)

```bash
./build-mythos-pegasus.sh
```

**Build time:** 60-90 minutes
**Target:** Elderly-friendly, high accessibility
**Features:** GUI, large fonts, Firefox, simple file manager

### Nekomata Edition (120MB, Productivity)

```bash
./build-mythos-nekomata.sh
```

**Build time:** 90-120 minutes
**Target:** Professional productivity
**Features:** Office suite, VPN, email client, development tools

### Hydra Edition (150MB, Education)

```bash
./build-mythos-hydra.sh
```

**Build time:** 120-180 minutes
**Target:** Educational, multi-disciplinary
**Features:** Programming tools, science apps, networking tools, AI Hub

### Dragon Edition (250MB, Gaming)

```bash
./build-mythos-dragon.sh
```

**Build time:** 180-240 minutes
**Target:** Gaming and entertainment
**Features:** Emulators, SDL games, audio/video, OpenGL

---

## Building All Editions

To build all 5 editions in sequence:

```bash
cd build-system/scripts
./build-all-editions.sh
```

**Total time:** 6-12 hours (depending on hardware)

This will create ISOs for all editions in `build-system/output/`:
- `mythOS-chase-v1.0.0.iso`
- `mythOS-pegasus-v1.0.0.iso`
- `mythOS-nekomata-v1.0.0.iso`
- `mythOS-hydra-v1.0.0.iso`
- `mythOS-dragon-v1.0.0.iso`

---

## Testing

### Quick Testing with QEMU

#### Test Individual Edition

```bash
cd build-system/testing

# Test Chase
./test-chase.sh

# Test any edition
./test-all-editions.sh
```

#### Test WebDT 366 Simulation

Emulates old tablet hardware (128MB RAM, i586 CPU):

```bash
./test-webdt366.sh chase
./test-webdt366.sh dragon
```

### Comprehensive Testing

See `build-system/testing/README.md` for complete test scenarios:

- Boot tests
- Network connectivity tests
- GUI tests (for GUI editions)
- Theme switcher tests
- Installer tests
- Hardware-specific tests

---

## Installation

### Method 1: Install to Real Hardware

1. **Write ISO to USB:**

```bash
# Linux
sudo dd if=output/mythOS-chase-v1.0.0.iso of=/dev/sdX bs=4M status=progress
sync

# macOS
sudo dd if=output/mythOS-chase-v1.0.0.iso of=/dev/diskX bs=4m
```

2. **Boot from USB:**
   - Insert USB into target computer
   - Enter BIOS/boot menu (usually F12, F2, or Del)
   - Select USB drive
   - Boot into mythOS Live environment

3. **Run Installer:**

```bash
# Once booted into mythOS
sudo mythos-installer
```

The installer will:
- Show available disks
- Partition disk (100MB /boot, edition-sized /system, remaining /home)
- Format partitions (ext4)
- Install system files
- Install SYSLINUX bootloader
- Create fstab
- Make disk bootable

4. **Reboot:**

Remove USB and reboot. mythOS will boot from the internal disk.

### Method 2: Virtual Machine Installation

1. **Create Virtual Disk:**

```bash
qemu-img create -f qcow2 mythos-disk.qcow2 10G
```

2. **Boot Installer:**

```bash
qemu-system-i386 \
    -m 512M \
    -cdrom output/mythOS-chase-v1.0.0.iso \
    -hda mythos-disk.qcow2 \
    -boot d
```

3. **Run Installer** (as above)

4. **Boot from Disk:**

```bash
qemu-system-i386 \
    -m 512M \
    -hda mythos-disk.qcow2 \
    -boot c
```

---

## Features Guide

### 1. Disk Installer (`mythos-installer`)

**Location:** `/usr/local/bin/mythos-installer`

Full-featured disk installer with:
- Interactive disk selection
- Automatic partitioning (boot/system/home layout)
- Filesystem formatting (ext4)
- SYSLINUX bootloader installation
- Read-only system partition
- Persistent home partition

**Usage:**
```bash
sudo mythos-installer
```

### 2. Network Configuration (`network-config-ui`)

**Location:** `/usr/local/bin/network-config-ui`

Dual-mode network wizard (GUI + Terminal):
- WiFi network scanning and configuration
- WPA/WPA2 password entry
- Ethernet configuration (DHCP or static)
- Network status display
- Works with or without GUI

**Usage:**
```bash
# Automatically detects GUI/terminal mode
sudo network-config-ui

# Or from terminal
sudo network-config-ui
```

### 3. System Administration (`mythos-admin`)

**Location:** `/usr/local/bin/mythos-admin`

Complete system administration tool:

- **User Management:**
  - List users
  - Add/delete users
  - Change passwords

- **Firewall Configuration:**
  - View iptables rules
  - Enable basic firewall
  - Allow/block specific ports

- **Service Management:**
  - Start/stop SSH server
  - Restart network services
  - View running processes

- **Storage Management:**
  - View disk usage
  - Show mounted filesystems

**Usage:**
```bash
sudo mythos-admin
```

### 4. Audio Setup (`audio-setup`)

**Location:** `/usr/local/bin/audio-setup`

Audio configuration and testing:
- Detect audio hardware
- Test audio output
- Unmute channels
- Set volume levels
- Launch alsamixer

**Usage:**
```bash
# Interactive mode
audio-setup

# Quick setup mode
audio-setup --quick
```

### 5. Theme Selector

**Terminal:** `/usr/local/bin/theme-selector-terminal`
**GUI:** `/usr/local/bin/theme-selector-gui`

Switch between mythOS editions:
- Storage-aware compatibility checking
- Download editions from GitHub releases
- Automatic installation with backup
- Data preservation (/home partition)

### 6. GUI Desktop Environment

**Components:**
- **Window Manager:** Openbox
- **X11 Config:** `/etc/X11/xinit/xinitrc`
- **Menu:** Right-click desktop for application menu
- **Keyboard Shortcuts:**
  - `Win+T` - Terminal
  - `Win+F` - File Manager
  - `Win+B` - Browser
  - `Alt+Tab` - Switch windows
  - `Alt+F4` - Close window

**Starting GUI:**
```bash
startx-mythos
```

### 7. AI Hub Launcher

**Location:** `/usr/local/bin/ai-hub-launcher.py`

Quick access to AI assistants:
- Claude, ChatGPT, Gemini, Perplexity
- NotebookLM, HuggingChat, Ollama
- GUI and CLI modes

**Usage:**
```bash
# Launch selector
ai-hub-launcher.py

# Direct launch
ai-hub-launcher.py --ai claude
```

---

## Hardware Support

### WebDT 366 Optimizations

**Kernel:** i586 optimized (see `configs/linux-webdt366-fragment.config`)

**Features:**
- ✅ Power management (ACPI, APM)
- ✅ Battery monitoring
- ✅ CPU frequency scaling
- ✅ Touchscreen support (USB composite, Egalax, etc.)
- ✅ WiFi drivers (IPW2100/2200, Atheros, Realtek, etc.)
- ✅ PCMCIA/CardBus support
- ✅ ALSA audio (Intel HD Audio, AC97)
- ✅ Framebuffer graphics (VESA)
- ✅ Low memory optimization

### Tested WiFi Chipsets

- Intel IPW2100, IPW2200
- Atheros AR5xxx, AR9xxx
- Realtek RTL818x, RTL819x
- Broadcom B43
- Ralink/MediaTek
- USB WiFi adapters (ZD1211, RT2800USB)

---

## Architecture

### Partition Layout

mythOS uses a three-partition layout:

```
/dev/sdX1  100MB   /boot    ext4, bootable    Kernel and bootloader
/dev/sdX2  50-350MB /system  ext4, read-only   OS files (immutable)
/dev/sdX3  Remaining /home   ext4, read-write  User data (persistent)
```

**Benefits:**
- Immutable system (harder to break)
- Easy edition switching (replace /system only)
- Data preservation (/home survives edition changes)
- Small system footprint (50-350MB depending on edition)

### Build System

**Structure:**
```
build-system/
├── configs/               Buildroot configurations
│   ├── mythos-base.config         Common settings
│   ├── mythos-chase.config        Chase-specific
│   ├── mythos-*.config            Other editions
│   └── linux-webdt366-fragment.config   Kernel config
├── scripts/               Build automation
│   ├── build-common.sh            Shared functions
│   ├── build-mythos-*.sh          Per-edition builders
│   └── build-all-editions.sh      Build all
├── buildroot-overlay/     System file overlay
│   ├── etc/                       Config files
│   ├── usr/local/bin/             Custom tools
│   └── usr/share/mythOS/          Resources
└── testing/               Test scripts
    ├── test-*.sh                  QEMU test runners
    └── README.md                  Test guide
```

---

## Troubleshooting

### Build Fails

**Error:** Missing dependencies
```bash
sudo apt-get install build-essential wget rsync cpio unzip bc
sudo apt-get install libncurses5-dev libssl-dev
```

**Error:** Out of disk space
```bash
# Need 15GB per edition
df -h
# Clean old builds
rm -rf build-system/buildroot-*/
```

**Error:** Build hangs
```bash
# Reduce parallel jobs
# Edit build script: change -j$(nproc) to -j2
```

### ISO Won't Boot

**Check:**
- BIOS boot enabled (not UEFI)
- ISO burned correctly to USB
- Boot order set correctly

**Fix:**
```bash
# Re-create ISO with hybrid support
isohybrid output/mythOS-chase-v1.0.0.iso
```

### No WiFi

**Check:**
```bash
# List WiFi interfaces
iw dev

# If none, check kernel modules
lsmod | grep -E 'iwl|ath|rt|b43'

# Load module manually
modprobe iwlwifi  # (example for Intel)
```

### No Audio

**Fix:**
```bash
# Run audio setup
audio-setup --quick

# Or manually
amixer sset Master unmute
amixer sset Master 80%
speaker-test -c 2 -t wav
```

### GUI Won't Start

**Check:**
```bash
# Test X11
startx

# Check logs
cat /var/log/Xorg.0.log

# Verify drivers loaded
lsmod | grep -E 'vesa|fbdev|intel|radeon'
```

---

## What's Next?

### Immediate To-Dos

1. **Generate Real Mascots:**
   - Use AI tools (DALL-E, Midjourney, Stable Diffusion)
   - Follow `buildroot-overlay/usr/share/mythOS/mascots/MASCOT_GENERATION_GUIDE.md`
   - Replace placeholder SVGs with real artwork

2. **Test on Real Hardware:**
   - WebDT 366 tablets
   - Other i586/i686 systems
   - Report hardware compatibility

3. **Create GitHub Releases:**
   - Build all editions
   - Upload ISOs with checksums
   - Write release notes

### Future Enhancements

- Package manager for updates
- Automated testing CI/CD
- Additional language support
- More edition variants
- Hardware-specific optimizations
- Steam integration for Dragon
- Touch-optimized interfaces

---

## Contributing

See `CONTRIBUTING.md` for:
- Development workflow
- Coding standards
- Pull request process
- Issue reporting

---

## Support

- **Documentation:** All `*.md` files in repository
- **Issues:** https://github.com/Nightmare17726/mythOS/issues
- **Discussions:** https://github.com/Nightmare17726/mythOS/discussions

---

## License

mythOS is built on open-source components. See individual package licenses in Buildroot.

---

**Happy Building!** 🚀

*Built with ❤️ for old hardware and new possibilities*
