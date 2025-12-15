# mythOS Desktop Launchers

This directory contains .desktop files for launching applications in mythOS.

## Custom mythOS Applications

- **mythos-battery-monitor.desktop** - Battery status monitor (all GUI editions)
- **mythos-first-run-wizard.desktop** - First-time setup wizard (all GUI editions)
- **mythos-performance-monitor.desktop** - Performance dashboard (Dragon edition)
- **mythos-parental-controls.desktop** - Safety controls (Pegasus edition)
- **mythos-theme-selector.desktop** - Edition switcher (all editions)
- **mythos-network-config.desktop** - Network configuration (all GUI editions)
- **mythos-installer.desktop** - System installer (all editions)

## Edition-Specific Launchers

### Chase Edition (Terminal Only)
Chase edition does not use .desktop files as it's terminal-only. Users launch applications from the terminal or via cloud office scripts.

### Pegasus Edition (Accessibility)
Giant UI optimized launchers with accessibility features:
- LibreOffice (Writer, Calc, Impress)
- Thunderbird (Email)
- Firefox (Web Browser)
- VLC (Media Player)
- Shotwell (Photos)
- GIMP (Image Editor)
- Webcam (Cheese)
- Scanner (Simple Scan)
- Games (Solitaire, Mahjongg, Sudoku, Chess)
- Calculator
- Weather
- Clocks
- Emergency Contacts
- Remote Assistance

### Nekomata Edition (Professional)
Professional productivity launchers:
- LibreOffice Suite (Writer, Calc, Impress, Draw, Math, Base)
- Thunderbird (Email & Calendar)
- Communication (Telegram, Signal)
- Development (Atom, Geany, Vim)
- Git GUI (Meld)
- Database Tools (DBeaver)
- Graphics (Inkscape, GIMP, Krita, Darktable)
- Note-Taking (Joplin, Obsidian)
- VPN Clients
- Remote Desktop (VNC, RustDesk)
- File Transfer (FileZilla)
- Cloud Sync (Nextcloud, Syncthing)
- Utilities (Flameshot, Peek, CopyQ)

### Hydra Edition (Educational)
Educational and development launchers:
- Code Editors (Atom, VS Code, Geany, Vim, Emacs)
- IDEs (for Java, Python)
- Jupyter Notebook
- Mathematical Software (Octave, SageMath, GeoGebra, R, RStudio)
- Science (Stellarium, Step)
- Electronics (Arduino IDE, Fritzing, KiCad)
- 3D Modeling (Blender, Wings 3D)
- Multimedia (Audacity, Ardour, LMMS, OBS Studio, Kdenlive)
- Office Suite (LibreOffice)
- LaTeX Editors (Texmaker)
- Database Tools (DBeaver, pgAdmin)
- Virtualization (QEMU, VirtualBox)
- Educational Platforms (Scratch, BlueJ, GCompris)
- Network Tools (Wireshark, GNS3)

### Dragon Edition (Gaming)
Gaming and entertainment launchers:
- Game Launchers (Lutris, PlayOnLinux)
- Emulators (RetroArch, DOSBox, ScummVM, MAME, PPSSPP)
- Native Games (SuperTuxKart, 0 A.D., Xonotic, Minetest, etc.)
- Game Development (Godot, Blender, Tiled)
- Media Players (VLC, Kodi)
- Music Players (Rhythmbox, Clementine)
- Streaming (OBS Studio, SimpleScreenRecorder)
- Video Editing (Kdenlive, Shotcut, OpenShot)
- Audio Production (Audacity, Ardour, LMMS, Mixxx)
- Graphics (GIMP, Krita, Inkscape, Blender)
- Communication (Discord, Telegram, Signal)
- Browsers (Firefox, Chromium, Brave)
- Performance Monitor
- Controller Configuration

## Launcher Icon Themes

mythOS uses multiple icon sizes for different editions:
- **Pegasus**: 192px icons for giant UI mode
- **Standard**: 48px icons for other GUI editions
- **Chase**: No GUI, terminal-only

## Customization

Edition-specific launchers use the `OnlyShowIn` field to display only in appropriate editions:
```
OnlyShowIn=Pegasus;
OnlyShowIn=Dragon;
```

All launchers follow the freedesktop.org Desktop Entry Specification.

## Location

Desktop files are installed to:
- System: `/usr/share/applications/`
- User: `~/.local/share/applications/`

## Automatic Generation

Many application packages (Firefox, LibreOffice, etc.) come with their own .desktop files.
This directory contains:
1. Custom mythOS application launchers
2. Modified launchers for mythOS-specific configurations
3. Missing launchers for applications that don't provide them

Most standard applications will have their launchers installed automatically by their respective packages.
