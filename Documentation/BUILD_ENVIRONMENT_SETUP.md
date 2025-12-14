# mythOS Build Environment Setup Guide
# ======================================

## Overview
This guide will help you set up a complete build environment for mythOS using Buildroot.
Buildroot allows us to create a minimal, custom Linux system optimized for constrained hardware like the WebDT 366.

## System Requirements

### Host System
- Linux distribution (Ubuntu 20.04+ or Debian 11+ recommended)
- 4GB+ RAM (8GB+ recommended)
- 20GB+ free disk space
- Fast internet connection for downloading packages

### Required Packages
```bash
sudo apt-get update
sudo apt-get install -y \
    build-essential \
    git \
    wget \
    cpio \
    unzip \
    rsync \
    bc \
    libncurses5-dev \
    libssl-dev \
    python3 \
    python3-pip \
    flex \
    bison \
    device-tree-compiler \
    qemu-system-x86 \
    qemu-system-arm \
    parted \
    dosfstools \
    mtools
```

## Step 1: Download Buildroot

```bash
# Create mythOS workspace
mkdir -p ~/mythOS-workspace
cd ~/mythOS-workspace

# Download Buildroot (LTS version 2024.02)
wget https://buildroot.org/downloads/buildroot-2024.02.tar.gz
tar xzf buildroot-2024.02.tar.gz
mv buildroot-2024.02 buildroot
cd buildroot
```

## Step 2: Initial Configuration

### For x86 Systems (WebDT 366 compatible)
```bash
# Start with a minimal x86 configuration
make pc_x86_64_bios_defconfig

# Enter menuconfig to customize
make menuconfig
```

### For ARM Systems (if needed)
```bash
# For ARM-based devices
make qemu_arm_versatile_defconfig
make menuconfig
```

## Step 3: menuconfig Settings for Chase Edition

Navigate through the menuconfig interface and configure:

### Target Options
- Target Architecture: (i386) or (x86_64) depending on WebDT 366
- Target Architecture Variant: i586 or i686
- Target ABI: Use hardware FPU

### Build Options
- Enable compiler cache (ccache) for faster rebuilds
- Strip target binaries
- gcc optimization level: -Os (optimize for size)

### Toolchain
- C library: musl (smaller than glibc)
- Enable WCHAR support
- Enable C++ support (for some GUI libraries)

### System Configuration
- System hostname: mythos-chase
- System banner: Welcome to mythOS Chase Edition
- Init system: BusyBox (minimal)
- /dev management: Dynamic using devtmpfs
- Root password: (set one for testing)

### Kernel
- Linux Kernel: Latest version (or 6.1 LTS)
- Kernel configuration: Using an in-tree defconfig
- Defconfig name: i386 or x86_64_defconfig
- Build a Device Tree Blob: NO (for x86)

### Target Packages

#### BusyBox Configuration
- Full busybox with networking utilities
- Enable: wget, ping, ifconfig, route, dhcp client

#### Networking Applications
- Package: dropbear (lightweight SSH server)
- Package: wireless tools and wpa_supplicant

#### Text Editors
- Package: nano (simple text editor)

#### Web Browser (Chase Edition)
- Package: links or netsurf (ultra-lightweight browsers)
- Note: Brave too large for minimal build

#### System Tools
- Package: htop (process monitoring)
- Package: util-linux extras (mount, umount, etc.)

#### Filesystem Images
- ext4 root filesystem
- tar the root filesystem (for easy modification)
- Create ext2/3/4 filesystem image
- Size: 50MB (adjustable)

## Step 4: Create Custom Overlay

Create custom files to be added to the root filesystem:

```bash
# Create overlay directory structure
mkdir -p ~/mythOS-workspace/buildroot-overlay/etc
mkdir -p ~/mythOS-workspace/buildroot-overlay/usr/local/bin
mkdir -p ~/mythOS-workspace/buildroot-overlay/home/chase

# Point Buildroot to the overlay
# In menuconfig: System configuration -> Root filesystem overlay directories
# Set to: ~/mythOS-workspace/buildroot-overlay
```

### Create Chase Welcome Script

Create `~/mythOS-workspace/buildroot-overlay/usr/local/bin/chase-welcome`:

```bash
#!/bin/sh
# Chase Welcome Script

clear
cat << "EOF"
    __  ___     __  __    ____  _____
   /  |/  /_  _/ /_/ /_  / __ \/ ___/
  / /|_/ / / / / __/ __ \/ / / /\__ \ 
 / /  / / /_/ / /_/ / / / /_/ /___/ / 
/_/  /_/\__, /\__/_/ /_/\____//____/  
       /____/                         
    Chase Edition - Base Kernel
EOF

echo ""
echo "Hey there! I'm Chase, and welcome to mythOS!"
echo ""
echo "This is the base system - perfect for basic tasks."
echo "You can browse the web, manage files, and edit text."
echo ""
echo "Want something more powerful? You can install a themed edition:"
echo "  - Hydra (Education & Multi-disciplinary)"
echo "  - Dragon (Gaming)"  
echo "  - Pegasus (Simplified for elderly/beginners)"
echo "  - Nekomata (Professional productivity)"
echo ""
echo "Check your available storage and choose wisely!"
echo ""
echo "Type 'theme-selector' to browse available themes."
echo "Type 'help' for a list of available commands."
echo ""
```

Make it executable:
```bash
chmod +x ~/mythOS-workspace/buildroot-overlay/usr/local/bin/chase-welcome
```

### Auto-run Chase Welcome on Login

Create `~/mythOS-workspace/buildroot-overlay/etc/profile.d/chase.sh`:

```bash
#!/bin/sh
# Auto-run Chase welcome on first login
if [ -f /home/chase/.first_run ]; then
    chase-welcome
    rm /home/chase/.first_run
fi
```

## Step 5: Build the System

```bash
cd ~/mythOS-workspace/buildroot
make
```

This will take 30 minutes to several hours depending on your system.

## Step 6: Test in QEMU

```bash
# Test x86 build in QEMU
qemu-system-x86_64 \
    -m 256M \
    -kernel output/images/bzImage \
    -drive file=output/images/rootfs.ext4,format=raw \
    -append "root=/dev/sda console=ttyS0" \
    -nographic \
    -net nic,model=e1000 \
    -net user
```

## Step 7: Create Bootable ISO

```bash
cd ~/mythOS-workspace

# Install required tools
sudo apt-get install -y genisoimage syslinux isolinux

# Create ISO structure
mkdir -p mythOS-iso/{boot,isolinux}

# Copy kernel and rootfs
cp buildroot/output/images/bzImage mythOS-iso/boot/
cp buildroot/output/images/rootfs.ext4 mythOS-iso/boot/

# Copy isolinux files
cp /usr/lib/ISOLINUX/isolinux.bin mythOS-iso/isolinux/
cp /usr/lib/syslinux/modules/bios/ldlinux.c32 mythOS-iso/isolinux/
cp /usr/lib/syslinux/modules/bios/libcom32.c32 mythOS-iso/isolinux/
cp /usr/lib/syslinux/modules/bios/libutil.c32 mythOS-iso/isolinux/

# Create isolinux.cfg
cat > mythOS-iso/isolinux/isolinux.cfg << 'EOF'
DEFAULT mythOS
LABEL mythOS
    LINUX /boot/bzImage
    APPEND initrd=/boot/rootfs.ext4 root=/dev/ram0 rw
PROMPT 0
TIMEOUT 50
EOF

# Create ISO
genisoimage -o mythOS-chase-v1.0.iso \
    -b isolinux/isolinux.bin \
    -c isolinux/boot.cat \
    -no-emul-boot \
    -boot-load-size 4 \
    -boot-info-table \
    -J -R -v \
    mythOS-iso/

# Make ISO bootable
isohybrid mythOS-chase-v1.0.iso

echo "ISO created: mythOS-chase-v1.0.iso"
echo "You can now write this to a USB drive or boot in a VM"
```

## Step 8: Write ISO to USB Drive

```bash
# CAREFUL: Replace /dev/sdX with your actual USB drive
# Use 'lsblk' to identify your USB drive
sudo dd if=mythOS-chase-v1.0.iso of=/dev/sdX bs=4M status=progress && sync
```

## Advanced: Buildroot Customization Scripts

Create `~/mythOS-workspace/scripts/customize-chase.sh`:

```bash
#!/bin/bash
# Chase Edition Customization Script

set -e

BUILDROOT_DIR="$HOME/mythOS-workspace/buildroot"
OVERLAY_DIR="$HOME/mythOS-workspace/buildroot-overlay"

echo "=== Customizing Chase Edition ==="

# Function to add package to config
add_package() {
    local package=$1
    echo "Adding package: $package"
    cd "$BUILDROOT_DIR"
    # Use buildroot's config system to add packages
    ./scripts/config --enable BR2_PACKAGE_${package^^}
}

# Enable key packages
add_package "nano"
add_package "htop"
add_package "dropbear"

# Update configuration
cd "$BUILDROOT_DIR"
make olddefconfig

echo "Chase Edition customization complete!"
echo "Run 'make' to rebuild with new settings."
```

## Storage Requirements

### Build Environment
- Buildroot source: ~500MB
- Build output: ~2-5GB
- Downloaded packages: ~500MB-1GB
- **Total: ~5-7GB**

### Final Chase Edition ISO
- Compressed: ~50-75MB
- Expanded on disk: ~100-150MB

## Troubleshooting

### Build Fails
```bash
# Clean and rebuild
cd ~/mythOS-workspace/buildroot
make clean
make
```

### Missing Dependencies
```bash
# Rebuild dependency check
sudo apt-get install --reinstall build-essential
```

### Kernel Configuration Issues
```bash
# Reconfigure kernel
cd ~/mythOS-workspace/buildroot
make linux-menuconfig
make linux-rebuild
make
```

## Next Steps

1. **Test on Target Hardware**: Boot on WebDT 366 or similar device
2. **Optimize Size**: Remove unnecessary kernel modules and packages
3. **Add Theme Selector**: Implement storage detection and GitHub download
4. **Create Partition Layout**: Set up /boot, /system, /home partitions
5. **Build Themed Editions**: Use same process for Hydra, Dragon, Pegasus, Nekomata

## Resources

- Buildroot Manual: https://buildroot.org/downloads/manual/manual.html
- Linux From Scratch: https://www.linuxfromscratch.org/
- BusyBox Documentation: https://busybox.net/
- mythOS Repository: https://github.com/Nightmare17726/mythOS

## Build Script Summary

A complete automated build script is available at:
`~/mythOS-workspace/scripts/build-chase-edition.sh`

Run with: `bash ~/mythOS-workspace/scripts/build-chase-edition.sh`
