# mythOS Theme Package Structure
# ================================

## Overview

This document describes the structure of mythOS theme packages that are
distributed via GitHub Releases. Each theme is packaged as a compressed
tarball (.tar.gz) with a specific directory structure and installation script.

## Package Naming Convention

```
mythOS-{theme}-v{version}.tar.gz
```

Examples:
- mythOS-hydra-v1.0.tar.gz
- mythOS-dragon-v1.1.tar.gz
- mythOS-pegasus-v2.0.tar.gz

## Directory Structure

```
mythOS-{theme}-v{version}/
├── manifest.json           # Package metadata and requirements
├── install.sh             # Installation script
├── uninstall.sh           # Uninstallation script (optional)
├── README.md              # Theme-specific documentation
├── CHANGELOG.md           # Version history
├── kernel/                # Kernel and modules
│   ├── bzImage           # Linux kernel image
│   └── modules/          # Kernel modules
├── rootfs/               # Root filesystem
│   ├── bin/              # Essential binaries
│   ├── sbin/             # System binaries
│   ├── lib/              # Libraries
│   ├── usr/              # User programs
│   │   ├── bin/
│   │   ├── lib/
│   │   └── share/
│   └── etc/              # Configuration files
├── themes/               # UI themes and assets
│   ├── icons/
│   ├── wallpapers/
│   └── gtk/              # GTK themes if applicable
├── mascot/               # Mascot assets
│   ├── avatar.svg
│   ├── logo.svg
│   └── icon.png
└── apps/                 # Theme-specific applications
    └── [theme-specific apps]
```

## manifest.json Structure

```json
{
  "name": "Hydra",
  "version": "1.0.0",
  "edition": "hydra",
  "description": "Education Edition with multi-disciplinary tools",
  "mythOS_version": "1.0",
  "size_mb": 150,
  "min_storage_mb": 180,
  "recommended_storage_mb": 256,
  "release_date": "2025-01-15",
  "checksums": {
    "sha256": "abc123...",
    "md5": "def456..."
  },
  "requirements": {
    "architecture": ["x86_64", "i686"],
    "ram_mb": 128,
    "storage_mb": 180
  },
  "features": [
    "AI Tools Integration",
    "ProtonVPN",
    "Brave Browser",
    "Education Tools"
  ],
  "included_apps": [
    "brave-browser",
    "vscode",
    "gimp",
    "audacity",
    "libreoffice"
  ],
  "maintainer": {
    "name": "mythOS Team",
    "email": "maintainers@mythos.org",
    "github": "Nightmare17726"
  }
}
```

## install.sh Requirements

The installation script must:

1. Check system compatibility
2. Verify available storage
3. Install kernel to /boot
4. Deploy rootfs to /system
5. Install theme assets
6. Configure bootloader
7. Set up mascot welcome
8. Preserve /home partition
9. Create restore point
10. Return 0 on success, non-zero on failure

### Example install.sh Template

```bash
#!/bin/bash
# Theme Installation Script
# This script is executed by theme-installer.sh

set -e

THEME_NAME="Hydra"
THEME_VERSION="1.0"

# Source common functions if available
if [ -f "/opt/mythOS/lib/install-functions.sh" ]; then
    source /opt/mythOS/lib/install-functions.sh
fi

echo "Installing $THEME_NAME Edition v$THEME_VERSION..."

# 1. Verify manifest
if [ ! -f "manifest.json" ]; then
    echo "Error: manifest.json not found"
    exit 1
fi

# 2. Check architecture compatibility
ARCH=$(uname -m)
echo "Detected architecture: $ARCH"

# 3. Install kernel
echo "Installing kernel..."
cp -f kernel/bzImage /boot/vmlinuz-mythOS-hydra
cp -rf kernel/modules/* /lib/modules/

# 4. Deploy root filesystem
echo "Deploying root filesystem..."
rsync -av --delete rootfs/ /system/

# 5. Install theme assets
echo "Installing theme assets..."
cp -r themes/* /usr/share/themes/
cp -r mascot/* /usr/share/mythOS/mascot/

# 6. Install applications
echo "Installing applications..."
if [ -d "apps" ]; then
    cp -r apps/* /opt/mythOS/apps/
fi

# 7. Configure system
echo "Configuring system..."
echo "MYTHOS_THEME=hydra" > /etc/mythOS/theme.conf
echo "MYTHOS_VERSION=$THEME_VERSION" >> /etc/mythOS/theme.conf

# 8. Update bootloader
echo "Updating bootloader..."
if command -v grub-mkconfig &> /dev/null; then
    grub-mkconfig -o /boot/grub/grub.cfg
elif command -v update-grub &> /dev/null; then
    update-grub
fi

# 9. Set up welcome screen
echo "Setting up welcome screen..."
cp mascot/hydra-welcome.sh /usr/local/bin/theme-welcome
chmod +x /usr/local/bin/theme-welcome

echo "Installation complete!"
exit 0
```

## Packaging Instructions

### 1. Build the Theme

```bash
# Use Buildroot or custom build system
cd ~/mythOS-workspace/buildroot
make mythOS-hydra-config
make
```

### 2. Organize Files

```bash
# Create package directory
mkdir -p mythOS-hydra-v1.0/{kernel,rootfs,themes,mascot,apps}

# Copy built files
cp output/images/bzImage mythOS-hydra-v1.0/kernel/
cp -r output/images/rootfs/* mythOS-hydra-v1.0/rootfs/
cp -r /path/to/themes/* mythOS-hydra-v1.0/themes/
cp -r /path/to/mascot/* mythOS-hydra-v1.0/mascot/
```

### 3. Create manifest.json

```bash
# Generate manifest
cat > mythOS-hydra-v1.0/manifest.json << EOF
{
  "name": "Hydra",
  "version": "1.0.0",
  ...
}
EOF
```

### 4. Add Installation Scripts

```bash
# Copy install script
cp install.sh mythOS-hydra-v1.0/
chmod +x mythOS-hydra-v1.0/install.sh

# Add documentation
cp README.md mythOS-hydra-v1.0/
cp CHANGELOG.md mythOS-hydra-v1.0/
```

### 5. Create Package

```bash
# Create tarball
tar czf mythOS-hydra-v1.0.tar.gz mythOS-hydra-v1.0/

# Generate checksums
sha256sum mythOS-hydra-v1.0.tar.gz > mythOS-hydra-v1.0.tar.gz.sha256
md5sum mythOS-hydra-v1.0.tar.gz > mythOS-hydra-v1.0.tar.gz.md5
```

### 6. Upload to GitHub

```bash
# Create release via GitHub CLI
gh release create v1.0 \
    mythOS-hydra-v1.0.tar.gz \
    mythOS-hydra-v1.0.tar.gz.sha256 \
    mythOS-hydra-v1.0.tar.gz.md5 \
    --title "Hydra Edition v1.0" \
    --notes "Initial release of Hydra Education Edition"

# Or upload manually via GitHub web interface
```

## Testing the Package

```bash
# Extract and test installation
tar xzf mythOS-hydra-v1.0.tar.gz
cd mythOS-hydra-v1.0

# Verify manifest
python3 -m json.tool manifest.json

# Test installation script (dry run if possible)
sudo ./install.sh --dry-run

# Test in VM
qemu-system-x86_64 -m 512M -cdrom mythOS-hydra-test.iso
```

## Package Size Optimization

### Kernel Optimization
- Remove unused drivers
- Compile with -Os flag
- Strip debug symbols
- Use compressed kernel modules

### Application Optimization
- Use stripped binaries
- Remove documentation files
- Compress resources
- Link against musl instead of glibc

### General Tips
- Use UPX for binary compression (carefully)
- Remove locale files except English
- Remove man pages and info files
- Compress with xz instead of gz for better ratio

## Version Control

### Semantic Versioning

```
MAJOR.MINOR.PATCH

MAJOR: Breaking changes, incompatible with previous mythOS base
MINOR: New features, backward compatible
PATCH: Bug fixes, backward compatible
```

Examples:
- 1.0.0 - Initial release
- 1.1.0 - Added new applications
- 1.1.1 - Fixed boot issue
- 2.0.0 - Requires mythOS base v2.0+

## Quality Checklist

Before releasing a theme package:

- [ ] Manifest.json is valid JSON
- [ ] All checksums are correct
- [ ] Install.sh is executable and works
- [ ] Package size matches manifest
- [ ] Tested on target hardware (WebDT 366 or similar)
- [ ] Tested in VM
- [ ] User data preservation works
- [ ] Mascot welcome screen displays correctly
- [ ] All applications launch successfully
- [ ] Network connectivity works
- [ ] Storage detection is accurate
- [ ] Documentation is complete
- [ ] CHANGELOG is updated
- [ ] GitHub release notes are written

## Troubleshooting

### Package Won't Extract
- Check file corruption: `sha256sum -c mythOS-{theme}-v{version}.tar.gz.sha256`
- Verify download completed fully
- Check available disk space

### Installation Fails
- Check installation logs: `/var/log/mythOS-install.log`
- Verify system compatibility in manifest
- Check available storage space
- Review install.sh for errors

### Theme Doesn't Boot
- Check bootloader configuration
- Verify kernel is in /boot
- Check kernel command line parameters
- Review /boot/grub/grub.cfg

## Additional Resources

- mythOS GitHub: https://github.com/Nightmare17726/mythOS
- Build Environment Setup: BUILD_ENVIRONMENT_SETUP.md
- Theme Development Guide: THEME_DEVELOPMENT.md
- Issue Tracker: https://github.com/Nightmare17726/mythOS/issues
