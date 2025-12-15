# mythOS Chase Edition - Complete Program List

**Target Size**: 100-120MB
**Focus**: Minimal GUI - fits on anything, web-enabled

## Overview

Chase is the most minimal GUI mythOS edition, designed for:
- Old hardware with severe memory constraints (64-128MB RAM)
- Devices where every MB counts
- Web browsing and Office365/Google Docs access
- Basic file management and connectivity
- Minimal but functional desktop experience

**Minimal GUI** - Openbox window manager with essential applications only

## Window Manager & Desktop

### X11 Display Server
- **Xorg** - Minimal X11 server
- **VESA/FBDEV drivers** - Universal graphics support

### Window Manager
- **Openbox** - Ultra-lightweight window manager (no desktop environment)
  - Right-click menu for launching apps
  - Keyboard shortcuts
  - Minimal RAM usage (~20MB)

### System Tray
- **stalonetray** - Lightweight system tray
  - Shows network status
  - Volume control
  - Battery indicator

## Office & Cloud Access

### Web Browser
- **Firefox** - Full modern browser
  - Access Office 365 (Word, Excel, PowerPoint online)
  - Access Google Docs/Sheets/Slides
  - OnlyOffice cloud
  - Full JavaScript support
  - HTML5 compatibility

### PDF Viewing
- **MuPDF** - Minimal PDF viewer
  - Keyboard-driven
  - Very fast rendering
  - Small footprint

### Text Editing
- **Geany** - Lightweight GUI text editor
  - Syntax highlighting
  - Simple UI
  - Code editing support
- **Nano** - Terminal text editor backup

## File Management

### GUI File Manager
- **PCManFM** - Lightweight file manager
  - Browse files and folders
  - Thumbnail previews
  - Archive support
  - Removable media mounting
  - Right-click context menus

### Archive Manager
- **File Roller** (or xarchiver) - GUI for archives
  - ZIP, TAR, GZIP support
  - Extract and create archives
  - Drag-and-drop

### Image Viewing
- **feh** - Minimal image viewer
  - Fast loading
  - Slideshow mode
  - Keyboard navigation

## Connectivity

### WiFi Management
- **NetworkManager** - Network connection manager
  - **nm-applet** - System tray applet for WiFi
  - GUI for selecting networks
  - WPA/WPA2 support
  - Save network profiles

### Bluetooth Management
- **BlueZ** - Bluetooth stack
- **Blueman** - GUI Bluetooth manager
  - Pair devices
  - Connect keyboards/mice
  - File transfer
  - System tray integration

### VPN
- **WireGuard** - Modern VPN protocol
- **OpenVPN** - Traditional VPN
  - NetworkManager plugins for GUI config

## Terminal

### Terminal Emulator
- **LXTerminal** - Lightweight terminal
  - Tabbed interface
  - Configurable fonts
  - Copy/paste support
- **xterm** - Backup minimal terminal

### Shell
- **Bash** - Default shell
- **Tmux** - Terminal multiplexer (optional)

## System Utilities

### System Monitor
- **htop** - Process viewer (terminal)
  - CPU and memory usage
  - Kill processes
  - Sort by resource usage

### Audio
- **ALSA** - Audio drivers
- **PulseAudio** - Sound server
- **pavucontrol** - Volume control GUI

### Power Management
- **Battery Monitor** (custom mythOS tool)
  - Shows battery status
  - Power-saving modes

## Network Tools

### File Transfer
- **rsync** - Efficient file sync
- **wget** - Download files
- **curl** - Transfer data
- **SSH** - Secure remote access

### Network Utilities
- **ping/traceroute** - Network diagnostics
- **Network Manager** - Connection manager

## Fonts

- **DejaVu** - Clean sans-serif fonts
- **Liberation** - Metrics-compatible with Arial/Times

## Typical Use Cases

### Cloud Office Work
1. Open Firefox
2. Navigate to office.com or docs.google.com
3. Edit documents in browser
4. Auto-saved to cloud

### File Management
1. Launch PCManFM from Openbox menu
2. Browse folders graphically
3. Preview images with thumbnails
4. Extract archives with File Roller

### WiFi Connection
1. Click nm-applet in system tray
2. Select WiFi network
3. Enter password
4. Auto-connect on next boot

### Bluetooth Device
1. Open Blueman from menu
2. Search for devices
3. Pair keyboard/mouse
4. Device remembered for next boot

## Desktop Shortcuts

Chase includes these pre-configured Openbox menu entries:
- Web Browser (Firefox)
- File Manager (PCManFM)
- Terminal (LXTerminal)
- Text Editor (Geany)
- PDF Viewer (MuPDF)
- Network Settings (nm-connection-editor)
- Bluetooth Manager (Blueman)
- System Monitor (htop)
- mythOS Settings

## Keyboard Shortcuts

Default Openbox shortcuts:
- **Alt+F2** - Run command dialog
- **Alt+F4** - Close window
- **Alt+Tab** - Switch windows
- **Ctrl+Alt+Left/Right** - Switch desktops
- **Right-click desktop** - Application menu

## Resource Usage

Typical RAM usage (at idle):
- Xorg: ~15MB
- Openbox: ~5MB
- System services: ~20MB
- **Total idle: ~40MB**
- With Firefox: ~40MB additional (~80MB total)

This leaves room even on 128MB systems!

## Total Packages: 20-25 core packages
## Estimated Size: 100-120MB
## RAM Required: 64-128MB minimum

---

*Chase Edition: Minimal, functional, fits on anything.*
