# mythOS Complete Build Guide

**Building a Bootable mythOS Chase Edition ISO from Scratch**

This guide covers the complete process of building a bootable mythOS ISO with:
- Terminal interface for Chase Edition
- GUI interfaces for themed editions (Hydra, Dragon, Pegasus, Nekomata)
- Visual theme selector with mascot images
- Storage-aware edition switching

---

## 📋 Prerequisites

### System Requirements (Build Machine)

- **OS:** Linux (Ubuntu 20.04+ recommended)
- **CPU:** Multi-core (4+ cores recommended for faster builds)
- **RAM:** 4GB minimum, 8GB recommended
- **Disk:** 15GB free space minimum
- **Time:** 30-120 minutes for initial build

### Required Packages

```bash
sudo apt-get update
sudo apt-get install -y \
    build-essential gcc g++ make patch perl python3 python3-pip \
    wget rsync cpio unzip bc flex bison \
    libncurses5-dev libssl-dev device-tree-compiler \
    qemu-system-x86 qemu-system-arm \
    genisoimage syslinux isolinux \
    parted dosfstools mtools \
    imagemagick optipng
```

---

## 🎨 Phase 1: Generate Mascot Artwork

**IMPORTANT:** You must generate mascot artwork before building!

### Using AI Image Generation Tools

See `assets/mascots/MASCOT_GENERATION_GUIDE.md` for detailed prompts.

**Recommended Tools:**
- DALL-E 3 (via ChatGPT Plus)
- Midjourney
- Stable Diffusion
- Leonardo.ai

### Generate Each Mascot

1. **Chase** (Male tech guide):
   - Use prompt from MASCOT_GENERATION_GUIDE.md
   - Generate 3 versions: avatar, logo, icon
   - Save as PNG with transparency

2. **Hydra** (Multi-headed scholar):
   - Ensure 4-5 heads are visible
   - Each head should suggest different disciplines
   - Deep blue/purple color scheme

3. **Dragon** (Gaming mascot):
   - Bold, friendly dragon
   - Red/orange/gold colors
   - Playful pose, NOT scary

4. **Pegasus** (Elderly-friendly):
   - HIGH CONTRAST for accessibility
   - Gentle, patient appearance
   - Soft blue/white colors

5. **Nekomata** (Professional cat):
   - TWO TAILS (critical!)
   - Sleek gray/black/teal
   - Professional appearance

### Process Generated Images

Once you have the mascot images:

```bash
cd /home/user/mythOS-workspace/assets/mascots

# For each mascot, save as:
# - chase/avatar.png, logo.png, icon.png
# - hydra/avatar.png, logo.png, icon.png
# - dragon/avatar.png, logo.png, icon.png
# - pegasus/avatar.png, logo.png, icon.png
# - nekomata/avatar.png, logo.png, icon.png

# Run the processing script
./process-mascots.sh  # Creates multiple sizes and optimizes
```

**Or use placeholders for testing:**
The build will work with placeholder mascots, but you won't see actual mascot images in the GUI.

---

## 🔧 Phase 2: Build mythOS Chase Edition

### Quick Build (Automated)

```bash
cd /home/user/mythOS-workspace
./scripts/build-mythos-chase.sh
```

This script will:
1. Check dependencies
2. Download Buildroot 2024.02
3. Configure for mythOS Chase Edition
4. Build the system (30-120 minutes)
5. Create bootable ISO
6. Generate checksums

### Manual Build Process

If you prefer manual control:

#### 1. Download Buildroot

```bash
cd /home/user/mythOS-workspace
wget https://buildroot.org/downloads/buildroot-2024.02.tar.gz
tar -xzf buildroot-2024.02.tar.gz
mv buildroot-2024.02 buildroot
```

#### 2. Configure Buildroot

```bash
cd buildroot
make pc_x86_64_bios_defconfig

# Apply mythOS configuration
./scripts/config --set-str BR2_TARGET_GENERIC_HOSTNAME "mythos-chase"
./scripts/config --set-str BR2_ROOTFS_OVERLAY "../buildroot-overlay"
./scripts/config --enable BR2_TOOLCHAIN_BUILDROOT_MUSL
./scripts/config --enable BR2_PACKAGE_BUSYBOX
./scripts/config --enable BR2_PACKAGE_LINKS
./scripts/config --enable BR2_PACKAGE_PYTHON3
./scripts/config --enable BR2_PACKAGE_XORG7
./scripts/config --enable BR2_PACKAGE_GTK3
./scripts/config --enable BR2_TARGET_ROOTFS_EXT2
./scripts/config --set-str BR2_TARGET_ROOTFS_EXT2_SIZE "75M"

make olddefconfig
```

#### 3. Build

```bash
make -j$(nproc)
```

**Build time:** 30-120 minutes
**Output:** `buildroot/output/images/`

#### 4. Create ISO

```bash
cd ..
mkdir -p mythOS-iso/{boot,isolinux}

# Copy files
cp buildroot/output/images/bzImage mythOS-iso/boot/
cp buildroot/output/images/rootfs.ext2 mythOS-iso/boot/

# Copy bootloader
cp /usr/lib/ISOLINUX/isolinux.bin mythOS-iso/isolinux/
cp /usr/lib/syslinux/modules/bios/*.c32 mythOS-iso/isolinux/

# Create boot config
cat > mythOS-iso/isolinux/isolinux.cfg << 'EOF'
DEFAULT menu.c32
MENU TITLE mythOS Chase Edition v1.0.0
LABEL mythos
    MENU LABEL mythOS Chase Edition
    KERNEL /boot/bzImage
    APPEND initrd=/boot/rootfs.ext2 root=/dev/ram0 rw
EOF

# Generate ISO
genisoimage -o output/mythOS-chase-v1.0.0.iso \
    -b isolinux/isolinux.bin -c isolinux/boot.cat \
    -no-emul-boot -boot-load-size 4 -boot-info-table \
    -J -R -v -V "mythOS_Chase_1.0" mythOS-iso/

# Make hybrid (USB bootable)
isohybrid output/mythOS-chase-v1.0.0.iso

# Checksums
cd output
sha256sum mythOS-chase-v1.0.0.iso > mythOS-chase-v1.0.0.iso.sha256
md5sum mythOS-chase-v1.0.0.iso > mythOS-chase-v1.0.0.iso.md5
```

---

## 🧪 Phase 3: Test in QEMU

### Basic Test

```bash
qemu-system-x86_64 \
    -m 512M \
    -cdrom output/mythOS-chase-v1.0.0.iso \
    -boot d \
    -vga std \
    -net nic,model=e1000 \
    -net user \
    -enable-kvm
```

### What to Verify

✅ **Boot Screen:**
- mythOS ASCII logo appears
- "Chase Edition" displayed

✅ **Chase Welcome (Terminal):**
- ASCII art Chase mascot appears
- Terminal menu works
- Options 1-7 all function

✅ **System Info:**
- Shows correct edition
- Displays hardware info
- Storage information accurate

✅ **Theme Selector (Terminal):**
- Lists all 5 editions
- Shows storage compatibility correctly
- Greys out incompatible editions

✅ **Network:**
- Ethernet works (in QEMU)
- Can ping external sites

### GUI Testing (For Themed Editions)

If you build themed editions (Hydra, Dragon, etc.):

```bash
# Same QEMU command, but:
# - GUI welcome window should appear
# - Mascot image should display
# - Theme selector shows visual cards
# - All buttons work
```

---

## 📦 Phase 4: Create Release

### Files to Include

```
mythOS-chase-v1.0.0/
├── mythOS-chase-v1.0.0.iso (bootable ISO)
├── mythOS-chase-v1.0.0.iso.sha256 (checksum)
├── mythOS-chase-v1.0.0.iso.md5 (checksum)
└── RELEASE_NOTES.md (what's included)
```

### Create GitHub Release

1. **Tag the version:**
   ```bash
   git tag -a v1.0.0 -m "mythOS v1.0.0 - Chase Edition"
   git push origin v1.0.0
   ```

2. **Create release on GitHub:**
   - Go to Releases → New Release
   - Select tag v1.0.0
   - Upload ISO and checksums
   - Add release notes

3. **Update GETTING_STARTED.md:**
   - The download links will now work!

---

## 🎯 What's Included

### Chase Edition (Terminal Interface)

- ✅ Terminal-based welcome with ASCII art
- ✅ Theme selector (storage-aware)
- ✅ System information display
- ✅ Help system
- ✅ Links web browser
- ✅ BusyBox utilities
- ✅ Network tools

### Themed Editions (GUI Interface)

When users switch to Hydra/Dragon/Pegasus/Nekomata:

- ✅ GUI welcome window with mascot image
- ✅ Visual theme selector with mascot cards
- ✅ Storage compatibility checking
- ✅ Graphical system info
- ✅ Edition-specific features

---

## 🐛 Troubleshooting

### Build Fails

**Error:** Missing dependencies
```bash
sudo apt-get install build-essential gcc g++ make wget rsync
```

**Error:** Out of disk space
```bash
# Need at least 15GB free
df -h
```

**Error:** Build hangs
```bash
# Reduce parallel jobs
make -j2  # Instead of make -j$(nproc)
```

### ISO Won't Boot

**Check:**
- ISO was created successfully
- Used correct qemu command
- BIOS boot is enabled (not UEFI)

**Fix:**
```bash
# Recreate ISO with isohybrid
isohybrid output/mythOS-chase-v1.0.0.iso
```

### Mascots Don't Show

**Reason:** Mascot images weren't generated
**Fix:** Generate mascots using AI tools (see Phase 1)

### GUI Doesn't Work

**Reason:** Missing GTK/X11 packages
**Fix:** Rebuild with GUI packages enabled:
```bash
./scripts/config --enable BR2_PACKAGE_XORG7
./scripts/config --enable BR2_PACKAGE_GTK3
make
```

---

## 📚 Additional Resources

- **Buildroot Manual:** https://buildroot.org/downloads/manual/manual.html
- **mythOS Repository:** https://github.com/Nightmare17726/mythOS
- **Issue Tracker:** https://github.com/Nightmare17726/mythOS/issues

---

## ✨ Next Steps

After building Chase Edition:

1. **Test thoroughly** in QEMU
2. **Test on real hardware** (WebDT 366 or similar)
3. **Generate actual mascots** (replace placeholders)
4. **Build other editions** (Hydra, Dragon, etc.)
5. **Create GitHub release**
6. **Share with community!**

---

**Happy Building!** 🚀

*Chase says: "Let's see how fast we can make this run!"*
