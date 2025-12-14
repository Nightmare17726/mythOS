# mythOS Build Workspace

This directory contains the complete build system for mythOS Chase Edition.

## 📁 Directory Structure

```
mythOS-workspace/
├── assets/
│   └── mascots/              # Mascot artwork (generate with AI tools)
│       ├── MASCOT_GENERATION_GUIDE.md
│       ├── chase/
│       ├── hydra/
│       ├── dragon/
│       ├── pegasus/
│       └── nekomata/
├── buildroot-overlay/        # Custom system files
│   ├── etc/
│   │   ├── mythos-release
│   │   ├── issue
│   │   └── profile.d/
│   │       └── mythos-welcome.sh
│   └── usr/
│       ├── local/bin/        # System scripts
│       │   ├── chase-welcome
│       │   ├── theme-selector-terminal
│       │   ├── theme-selector-gui
│       │   ├── hydra-welcome
│       │   ├── dragon-welcome
│       │   ├── pegasus-welcome
│       │   ├── nekomata-welcome
│       │   ├── system-info
│       │   └── show-help
│       └── share/mythOS/
│           ├── mascots/      # Mascot files (copied from assets/)
│           └── gui-apps/     # GUI Python applications
│               ├── theme-welcome.py
│               └── theme-selector-gui.py
├── scripts/
│   └── build-mythos-chase.sh # Automated build script
├── buildroot/                # (Created during build)
├── mythOS-iso/               # (Created during ISO generation)
├── output/                   # (Created - final ISO here)
├── BUILD_GUIDE.md            # Complete build documentation
└── README.md                 # This file
```

## 🚀 Quick Start

### 1. Generate Mascots

Before building, generate mascot artwork using AI tools:

```bash
# See detailed prompts in:
cat assets/mascots/MASCOT_GENERATION_GUIDE.md

# Use ChatGPT Plus (DALL-E 3), Midjourney, or Stable Diffusion
# Save generated images in assets/mascots/{mascot}/
```

### 2. Run Automated Build

```bash
./scripts/build-mythos-chase.sh
```

This will:
- Check dependencies
- Download Buildroot 2024.02
- Configure for mythOS
- Build the system (30-120 min)
- Create bootable ISO

### 3. Test in QEMU

```bash
qemu-system-x86_64 -m 512M -cdrom output/mythOS-chase-v1.0.0.iso -boot d
```

## 📖 Documentation

- **[BUILD_GUIDE.md](BUILD_GUIDE.md)** - Complete build instructions
- **[assets/mascots/MASCOT_GENERATION_GUIDE.md](assets/mascots/MASCOT_GENERATION_GUIDE.md)** - Mascot generation prompts

## ✨ Features

### Chase Edition (Terminal Interface)
- Terminal-based welcome with ASCII art
- Storage-aware theme selector
- System info and help
- Links web browser

### Themed Editions (GUI Interface)
- GUI welcome windows with mascot images
- Visual theme selector with mascot cards
- Storage compatibility checking
- Edition-specific features

## 🎯 What's Included

All scripts are complete and functional:
- ✅ 9 system scripts (terminal + GUI)
- ✅ 2 GUI Python applications (GTK3)
- ✅ Complete Buildroot overlay
- ✅ Automated build system
- ✅ ISO generation scripts
- ✅ Comprehensive documentation

## 📋 Next Steps

1. Generate mascot artwork (see MASCOT_GENERATION_GUIDE.md)
2. Run ./scripts/build-mythos-chase.sh
3. Test in QEMU
4. Test on real hardware
5. Create GitHub release

## 🐛 Troubleshooting

See [BUILD_GUIDE.md](BUILD_GUIDE.md) for detailed troubleshooting.

Quick fixes:
- Missing deps: `sudo apt-get install build-essential wget rsync cpio`
- Out of space: Need 15GB free
- Build fails: Check build.log in buildroot/

## 📚 Resources

- Buildroot: https://buildroot.org
- mythOS Repo: https://github.com/Nightmare17726/mythOS
- Issues: https://github.com/Nightmare17726/mythOS/issues

---

**Ready to build mythOS!** 🚀

Generated: $(date)
