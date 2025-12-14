# mythOS Programs

**Scripts, Utilities, and Tools for Building and Managing mythOS**

---

## Overview

This directory contains the core scripts and utilities for building, installing, and managing mythOS editions. All scripts are production-ready, include error handling, and feature progress indicators for a smooth user experience.

---

## 📜 Programs in This Directory

### 1. build-chase-edition.sh
**Purpose:** Automated ISO builder for the Chase (Base) Edition

**Description:**
Complete automated build script that handles the entire process of creating a bootable mythOS Chase Edition ISO image using Buildroot. Includes dependency checking, disk space verification, configuration generation, and ISO creation with checksums.

**Usage:**
```bash
./build-chase-edition.sh
```

**Features:**
- ✓ Automatic dependency checking
- ✓ Disk space verification (requires 5GB free)
- ✓ Downloads Buildroot 2024.02 automatically
- ✓ Generates optimized configuration for 50MB system
- ✓ Creates filesystem overlays
- ✓ Parallel compilation (uses all CPU cores)
- ✓ Generates bootable ISO
- ✓ Creates SHA256 and MD5 checksums
- ✓ Generates comprehensive release notes
- ✓ Error handling and progress indicators

**Output:**
- ISO file: `output/chase/mythOS-Chase-1.0.0.iso`
- Checksums: `.sha256` and `.md5` files
- Release notes: `RELEASE_NOTES.txt`
- Build log: `buildroot/build.log`

**Requirements:**
- Debian/Ubuntu-based system
- 5GB free disk space
- gcc, g++, make, patch, perl, python3, rsync, wget, cpio, unzip, bc
- Internet connection (for Buildroot download)

**Build Time:**
- First build: 30-60 minutes (depending on hardware)
- Subsequent builds: 5-15 minutes (cached dependencies)

**Configuration:**
```bash
# Environment variables (optional)
export BUILD_DIR="./buildroot"          # Buildroot directory
export OUTPUT_DIR="./output/chase"      # Output directory
export CONFIG_DIR="./configs"           # Configuration directory
```

**Target Hardware:**
- WebDT 366 (64-128MB RAM, 128-256MB storage)
- i586 or better CPU
- VGA-compatible display

---

### 2. theme-installer.sh
**Purpose:** Automated theme installation and management system

**Description:**
Intelligent theme installer that downloads mythOS editions from GitHub releases, checks storage compatibility, preserves user data, creates backups, and handles theme switching with rollback support.

**Usage:**
```bash
# Interactive mode
sudo ./theme-installer.sh

# Install specific edition
sudo ./theme-installer.sh install Chase
sudo ./theme-installer.sh install Hydra

# List available editions
./theme-installer.sh list

# Show current edition
./theme-installer.sh current

# Show help
./theme-installer.sh help
```

**Features:**
- ✓ Storage-aware installation (prevents incompatible themes)
- ✓ Downloads from GitHub releases automatically
- ✓ SHA256 integrity verification
- ✓ Automatic backup before installation
- ✓ Preserves user data in `/home` partition
- ✓ Interactive theme selection with compatibility checking
- ✓ Beautiful colored CLI output
- ✓ Rollback support via backups
- ✓ Progress indicators for downloads

**Storage Requirements:**
| Edition   | Size  | Description                    |
|-----------|-------|--------------------------------|
| Chase     | 50MB  | Base system                    |
| Pegasus   | 85MB  | Simplified for elderly         |
| Nekomata  | 120MB | Professional productivity      |
| Hydra     | 150MB | Education with AI tools        |
| Dragon    | 250MB | Gaming with emulators          |

**Safety Features:**
- Checks available storage before installation
- Creates timestamped backups in `/home/.mythos-backups/`
- Preserves critical config files (passwd, group, etc.)
- Preserves entire `/home` partition
- Confirmation prompts for destructive operations
- Graceful error handling

**System Paths:**
- System partition: `/system`
- Home partition: `/home` (always preserved)
- Boot partition: `/boot`
- Backups: `/home/.mythos-backups/`
- Current theme info: `/etc/mythos-release`

**Requirements:**
- Must run as root (uses `sudo`)
- Internet connection for downloads
- Sufficient storage for target edition
- wget for downloading packages

---

### 3. ai-hub-launcher.py
**Purpose:** Unified launcher for AI assistants and tools

**Description:**
Python application providing easy access to AI assistants through a graphical or command-line interface. Supports multiple AI services including Claude, ChatGPT, Gemini, Perplexity, NotebookLM, and local LLMs.

**Usage:**
```bash
# Launch GUI (default if tkinter available)
./ai-hub-launcher.py

# Launch GUI explicitly
./ai-hub-launcher.py gui

# Launch interactive CLI
./ai-hub-launcher.py cli

# Launch specific AI service
./ai-hub-launcher.py launch Claude
./ai-hub-launcher.py launch ChatGPT
./ai-hub-launcher.py launch Gemini

# List available services
./ai-hub-launcher.py list

# Show help
./ai-hub-launcher.py help
```

**Supported AI Services:**

| Service       | URL                          | Category     | Shortcut |
|---------------|------------------------------|--------------|----------|
| Claude        | https://claude.ai            | Chat         | Ctrl+1   |
| ChatGPT       | https://chat.openai.com      | Chat         | Ctrl+2   |
| Gemini        | https://gemini.google.com    | Chat         | Ctrl+3   |
| Perplexity    | https://www.perplexity.ai    | Search       | Ctrl+4   |
| NotebookLM    | https://notebooklm.google.com| Productivity | Ctrl+5   |
| HuggingChat   | https://huggingface.co/chat  | Chat         | Ctrl+6   |
| Ollama (Local)| http://localhost:11434       | Local        | Ctrl+7   |

**Features:**
- ✓ GUI mode with tabbed interface (Favorites, Recent, All Services)
- ✓ CLI mode for systems without GUI
- ✓ Keyboard shortcuts (Ctrl+1 through Ctrl+7)
- ✓ Recent services tracking
- ✓ Customizable favorites
- ✓ Browser detection (prefers Brave, falls back to others)
- ✓ Configuration persistence
- ✓ Service descriptions and icons
- ✓ Lightweight and fast

**Browser Preferences:**
The launcher tries browsers in this order:
1. brave-browser
2. firefox
3. chromium
4. google-chrome
5. dillo (mythOS lightweight fallback)
6. links (text-based ultimate fallback)

**Configuration:**
Config files stored in `~/.config/mythos/`:
- `ai-hub-config.json` - User preferences and favorites
- `ai-hub-history.json` - Recent services

**GUI Features:**
- Tabbed interface (All Services, Favorites, Recent)
- Service cards with icons and descriptions
- Status bar showing launch status
- Keyboard shortcuts
- Responsive design

**CLI Features:**
- Interactive menu
- Service selection by number or name
- Recent services list
- Color-coded output

**Requirements:**
- Python 3.x
- tkinter (for GUI mode, optional)
- Web browser (any of the preferred browsers)
- Internet connection (except for Ollama)

**Dependencies:**
```bash
# For GUI mode (optional)
sudo apt-get install python3-tk

# For local LLM (optional)
# Install Ollama from https://ollama.ai
```

---

## 🚀 Quick Start Guide

### Building mythOS from Scratch

1. **Prepare your build environment:**
   ```bash
   sudo apt-get update
   sudo apt-get install build-essential gcc g++ make patch perl \
                        python3 rsync wget cpio unzip bc
   ```

2. **Build Chase Edition:**
   ```bash
   cd Programs
   ./build-chase-edition.sh
   ```

3. **Wait for build to complete** (30-60 minutes)

4. **Find your ISO:**
   ```bash
   ls -lh output/chase/mythOS-Chase-*.iso
   ```

### Switching Between Editions

1. **Check available storage:**
   ```bash
   df -h /system
   ```

2. **Run theme installer:**
   ```bash
   sudo ./theme-installer.sh
   ```

3. **Select your edition** from the interactive menu

4. **Reboot** when installation completes

### Using AI Hub

1. **Launch AI Hub:**
   ```bash
   ./ai-hub-launcher.py
   ```

2. **Select an AI service** from the GUI or CLI

3. **Browser opens** to the selected AI service

---

## 🛠️ Development & Customization

### Modifying Build Scripts

All build scripts follow these conventions:
- Bash with `set -e` (exit on error)
- Comprehensive error handling
- Progress indicators and colored output
- Configuration via environment variables
- Detailed logging

### Creating New Edition Build Scripts

To create a build script for another edition (e.g., Hydra, Dragon):

1. Copy `build-chase-edition.sh` to `build-<edition>-edition.sh`
2. Update these variables:
   - `EDITION="<Edition Name>"`
   - `EDITION_SIZE="<Size>MB"`
   - Edition-specific package selections
3. Modify `generate_chase_config()` for edition requirements
4. Update overlay files for edition theme
5. Test thoroughly

### Extending Theme Installer

The theme installer can be extended to:
- Support custom theme repositories
- Add edition-specific post-install scripts
- Implement differential updates
- Add theme preview before install

### Adding AI Services

To add new AI services to the launcher:

1. Open `ai-hub-launcher.py`
2. Add entry to `AI_SERVICES` dictionary:
   ```python
   "ServiceName": {
       "name": "Service Display Name",
       "url": "https://service.url",
       "description": "Service description",
       "shortcut": "Ctrl+N",
       "icon": "🤖",
       "category": "Chat"
   }
   ```
3. Test GUI and CLI modes

---

## 📋 Technical Details

### Build System Architecture

```
build-chase-edition.sh
├── Dependency Checking
├── Buildroot Download & Setup
├── Configuration Generation
│   ├── Kernel config (Linux 5.15 LTS)
│   ├── BusyBox config
│   ├── Package selection
│   └── ISO generation config
├── Overlay Creation
│   ├── /etc (system config)
│   ├── /home (user defaults)
│   └── /usr/share (themes, assets)
├── Compilation (parallel make)
└── ISO Creation & Verification
    ├── Bootable ISO
    ├── SHA256 checksum
    ├── MD5 checksum
    └── Release notes
```

### Theme Installer Architecture

```
theme-installer.sh
├── Storage Compatibility Check
├── GitHub Release Download
├── Package Integrity Verification
├── Backup Creation
│   ├── Current theme info
│   ├── User configs
│   └── Critical system files
├── Installation
│   ├── Extract package
│   ├── Install to /system
│   ├── Update /boot
│   └── Preserve /home
└── Cleanup & Verification
```

### AI Hub Architecture

```
ai-hub-launcher.py
├── Configuration Management
│   ├── Load config/history
│   ├── Browser detection
│   └── Service definitions
├── GUI Mode (tkinter)
│   ├── Service tabs
│   ├── Keyboard shortcuts
│   └── Status tracking
├── CLI Mode (fallback)
│   ├── Interactive menu
│   ├── Service selection
│   └── History display
└── Browser Integration
    ├── URL launching
    └── Browser preference
```

---

## 🧪 Testing

### Testing Build Scripts

```bash
# Dry-run (check dependencies only)
BUILD_DIR=/tmp/test-build ./build-chase-edition.sh

# Full test build
./build-chase-edition.sh

# Verify output
ls -lh output/chase/
sha256sum -c output/chase/*.sha256
```

### Testing Theme Installer

```bash
# List without installing
./theme-installer.sh list

# Check current theme
./theme-installer.sh current

# Dry-run (requires modification for test mode)
# Add to script: DRY_RUN=true for testing
```

### Testing AI Hub

```bash
# Test CLI mode
./ai-hub-launcher.py cli

# Test GUI mode
./ai-hub-launcher.py gui

# Test specific service launch
./ai-hub-launcher.py launch Claude
```

---

## 🐛 Troubleshooting

### Build Script Issues

**Problem:** Missing dependencies
```bash
# Solution: Install all build dependencies
sudo apt-get install build-essential gcc g++ make patch perl \
                     python3 rsync wget cpio unzip bc
```

**Problem:** Insufficient disk space
```bash
# Solution: Free up space or change OUTPUT_DIR
export BUILD_DIR=/path/to/larger/disk
./build-chase-edition.sh
```

**Problem:** Build fails during compilation
```bash
# Check build log
tail -n 50 buildroot/build.log

# Clean and retry
rm -rf buildroot output
./build-chase-edition.sh
```

### Theme Installer Issues

**Problem:** Download fails
```bash
# Check internet connection
ping github.com

# Verify release exists
# Visit: https://github.com/Nightmare17726/mythOS/releases
```

**Problem:** Insufficient storage
```bash
# Check available space
df -h /system

# Free up space or choose smaller edition
sudo ./theme-installer.sh list
```

**Problem:** Permission denied
```bash
# Must run as root
sudo ./theme-installer.sh
```

### AI Hub Issues

**Problem:** No GUI available
```bash
# Install tkinter
sudo apt-get install python3-tk

# Or use CLI mode
./ai-hub-launcher.py cli
```

**Problem:** Browser doesn't open
```bash
# Check available browsers
which brave-browser firefox chromium

# Install a browser
sudo apt-get install firefox
```

**Problem:** Ollama not accessible
```bash
# Install Ollama first
curl https://ollama.ai/install.sh | sh

# Start Ollama service
ollama serve

# Then use AI Hub
./ai-hub-launcher.py launch Ollama
```

---

## 📚 Additional Resources

- **Build Documentation:** [`../Documentation/BUILD_ENVIRONMENT_SETUP.md`](../Documentation/BUILD_ENVIRONMENT_SETUP.md)
- **Theme Documentation:** [`../Documentation/THEME_PACKAGE_STRUCTURE.md`](../Documentation/THEME_PACKAGE_STRUCTURE.md)
- **Project Overview:** [`../README.md`](../README.md)
- **Contributing:** [`../CONTRIBUTING.md`](../CONTRIBUTING.md)

---

## 🤝 Contributing

We welcome contributions to mythOS programs! See [`../CONTRIBUTING.md`](../CONTRIBUTING.md) for:
- Code style guidelines
- Testing requirements
- Pull request process
- Bug reporting

---

## 📜 License

All programs in this directory are part of the mythOS project and are released under the MIT License. See the main repository LICENSE file for details.

---

**Happy building, installing, and AI-ing!**

*Scripts that actually work, documentation that actually helps.*
