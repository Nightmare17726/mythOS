# mythOS Video Tutorial Scripts & Storyboards

Complete scripts for creating video tutorials for mythOS.

---

## Tutorial 1: "Installing mythOS on Old Hardware" (5 minutes)

### Script

**[00:00-00:15] INTRO**
- **Visual**: mythOS logo animation
- **Narration**: "Welcome! Today I'll show you how to breathe new life into old hardware with mythOS, a lightweight Linux distribution designed for devices as old as the WebDT 366 tablet from the early 2000s."

**[00:15-00:45] WHAT YOU'LL NEED**
- **Visual**: Show required items
  - Old computer/tablet (WebDT 366 or similar)
  - USB drive (2GB minimum)
  - Another computer to download ISO
- **Narration**: "Here's what you need: your old device, a USB drive, and another computer to download the mythOS ISO file."

**[00:45-01:30] DOWNLOAD & VERIFY**
- **Visual**: Screen recording of website
  - Navigate to mythOS website
  - Download Chase edition
  - Show checksum verification
- **Narration**: "Visit the mythOS website and choose your edition. I'm using Chase, the lightest at just 50MB. After downloading, verify the checksum to ensure file integrity."
- **Commands shown**:
  ```
  sha256sum -c mythOS-chase-v1.0.0.iso.sha256
  ```

**[01:30-02:15] CREATE BOOTABLE USB**
- **Visual**: Terminal commands
  - Insert USB drive
  - Check device name
  - Write ISO
- **Narration**: "Insert your USB drive. In Linux, use the dd command. On Windows, use Rufus or balenaEtcher. On Mac, use dd in Terminal."
- **Commands**:
  ```
  sudo dd if=mythOS-chase-v1.0.0.iso of=/dev/sdX bs=4M status=progress
  sync
  ```
- **Warning overlay**: "⚠️ Double-check device name - this erases the USB!"

**[02:15-03:00] BOOT FROM USB**
- **Visual**: Physical device footage
  - Insert USB
  - Enter BIOS (show keys: F2, F12, Del)
  - Set boot order
  - Save and exit
- **Narration**: "Insert the USB into your old device. Restart and enter the BIOS - usually F2, F12, or Delete. Set USB as first boot device, save and restart."

**[03:00-04:00] RUN INSTALLER**
- **Visual**: Screen recording
  - mythOS boots to terminal
  - Login as root
  - Run mythos-installer
  - Show disk selection
  - Automatic partitioning
  - Progress bar
- **Narration**: "mythOS boots to a terminal. Login as root with no password. Type 'sudo mythos-installer' and follow the prompts. The installer automatically partitions your disk with boot, system, and home partitions."
- **Commands**:
  ```
  sudo mythos-installer
  ```

**[04:00-04:45] FIRST BOOT**
- **Visual**: Reboot sequence
  - Remove USB
  - mythOS boots from disk
  - Welcome screen
  - System info display
- **Narration**: "After installation completes, remove the USB and reboot. mythOS boots from your disk and shows the welcome screen. You now have a fully functional system on your old hardware!"

**[04:45-05:00] OUTRO**
- **Visual**: Show all editions as cards
- **Narration**: "mythOS has 5 editions from terminal-only to full gaming. Check the description for links. Subscribe for more tutorials!"
- **Text overlay**: "👍 Like | 💬 Comment | 📢 Subscribe"

### Storyboard Sketch

```
Frame 1: mythOS logo + title
Frame 2: Split-screen showing old device + USB
Frame 3: Website download page
Frame 4: Terminal showing dd command
Frame 5: BIOS screen with arrows
Frame 6: Installer partitioning screen
Frame 7: Progress bar filling
Frame 8: mythOS welcome screen
Frame 9: Edition showcase
```

---

## Tutorial 2: "Switching Between mythOS Editions" (3 minutes)

### Script

**[00:00-00:20] INTRO**
- **Visual**: Show all 5 mascots
- **Narration**: "mythOS lets you switch between 5 different editions without reinstalling. Let's see how!"

**[00:20-01:00] THEME SELECTOR**
- **Visual**: Terminal or GUI
- **Narration**: "Open the theme selector - either terminal or GUI version. It shows all available editions with storage requirements."
- **Commands**:
  ```
  theme-selector-terminal
  # or
  theme-selector-gui
  ```

**[01:00-02:00] SWITCHING PROCESS**
- **Visual**: Step-by-step
  - Select Hydra edition
  - Storage check (green = compatible)
  - Confirm download
  - Progress bar
  - Installation
- **Narration**: "Select your desired edition. The system checks if you have enough storage - green means compatible. Confirm to download and install. Your /home partition is preserved!"

**[02:00-02:45] REBOOT & ENJOY**
- **Visual**: Reboot sequence
  - New edition boots
  - Different interface
  - New applications
- **Narration**: "After installation, reboot. You're now running the new edition with all its features, but your personal files are intact."

**[02:45-03:00] OUTRO**
- **Text overlay**: Edition comparison chart
- **Narration**: "That's it! Try different editions to find what works best. Links in description!"

---

## Tutorial 3: "Network Setup on mythOS" (4 minutes)

### Script

**[00:00-00:15] INTRO**
- **Narration**: "Connecting to WiFi on mythOS is easy with the built-in network configuration tool."

**[00:15-01:00] LAUNCH TOOL**
- **Visual**: Launch network-config-ui
- **Narration**: "Run 'network-config-ui' - it works in both GUI and terminal modes."
- **Show**: Automatic mode detection

**[01:00-02:30] WIFI SETUP**
- **Visual**: Step-by-step
  - Select WiFi option
  - Scan networks
  - Choose network
  - Enter password
  - Connection established
- **Narration**: "Select 'Configure WiFi', scan for networks, choose yours, enter the password. The tool uses WPA supplicant and DHCP automatically."

**[02:30-03:30] TROUBLESHOOTING**
- **Visual**: Common issues
  - No networks found → check hardware
  - Wrong password → try again
  - Connected but no internet → check DNS
- **Narration**: "If you don't see networks, check if WiFi is enabled in BIOS. Wrong password? Just try again. Connected but no internet? The tool can fix DNS settings."

**[03:30-04:00] OUTRO**
- **Narration**: "That's network setup! Check the troubleshooting flowcharts for more help."

---

## Tutorial 4: "First-Run Setup Wizard" (3 minutes)

### Script

**[00:00-00:30] INTRO & LANGUAGE**
- **Visual**: Wizard welcome screen
- **Narration**: "On first boot, mythOS guides you through setup. Start by selecting your language."

**[00:30-01:30] USER ACCOUNT**
- **Visual**: User creation page
- **Narration**: "Create your user account. Enter username and password. This is more secure than using root."

**[01:30-02:30] CUSTOMIZATION**
- **Visual**: Settings toggles
  - Touch mode
  - Large fonts
  - Parental controls (if Pegasus)
- **Narration**: "Customize your experience. Enable touch mode for tablets, large fonts for accessibility, and parental controls on Pegasus edition."

**[02:30-03:00] COMPLETE**
- **Visual**: Summary and desktop
- **Narration**: "Review and apply. mythOS is now configured! Your preferences are saved and persist across reboots."

---

## Tutorial 5: "Advanced: Building mythOS from Source" (8 minutes)

### Script

**[00:00-01:00] PREREQUISITES**
- **Visual**: Terminal with package installation
- **Narration**: "Building mythOS from source gives you full control. You'll need Linux with at least 4GB RAM and 20GB disk space."
- **Commands**:
  ```
  sudo apt-get install build-essential wget rsync
  ```

**[01:00-02:00] CLONE REPO**
- **Visual**: Git clone
- **Narration**: "Clone the mythOS repository from GitHub. Navigate to the build-system directory."
- **Commands**:
  ```
  git clone https://github.com/Nightmare17726/mythOS.git
  cd mythOS/build-system/scripts
  ```

**[02:00-04:00] BUILD PROCESS**
- **Visual**: Build script running with progress
- **Narration**: "Run the build script for your chosen edition. This downloads Buildroot, compiles everything, and creates the ISO. Expect 1-2 hours depending on your system."
- **Commands**:
  ```
  ./build-mythos-chase.sh
  ```
- **Show**: Real-time build progress (sped up)

**[04:00-06:00] TESTING IN QEMU**
- **Visual**: QEMU test
- **Narration**: "Test your ISO in QEMU before deploying. Use the test scripts included."
- **Commands**:
  ```
  cd ../testing
  ./test-chase.sh
  ```

**[06:00-07:00] CUSTOMIZATION**
- **Visual**: Edit overlay files
- **Narration**: "Customize by editing buildroot-overlay files. Add your own scripts, themes, or applications."
- **Show**: File structure

**[07:00-08:00] OUTRO**
- **Narration**: "Building from source lets you create custom mythOS editions. See the Build Guide for details. Happy building!"

---

## B-Roll Footage Checklist

### Hardware Shots
- [ ] WebDT 366 tablet (multiple angles)
- [ ] USB drive insertion
- [ ] Boot screen on old laptop
- [ ] Touchscreen interaction
- [ ] Battery indicator
- [ ] WiFi antenna (if visible)

### Screen Recordings
- [ ] Clean desktop for each edition
- [ ] Terminal commands (large font)
- [ ] Installer progress
- [ ] Theme switching
- [ ] Network configuration
- [ ] First-run wizard

### Graphics/Animations
- [ ] mythOS logo reveal
- [ ] Edition mascots
- [ ] Loading/progress bars
- [ ] Success checkmarks
- [ ] Warning/error overlays

---

## Production Notes

### Equipment
- **Screen recorder**: SimpleScreenRecorder (Linux), OBS Studio
- **Video editor**: Kdenlive, DaVinci Resolve
- **Audio**: Clear microphone, quiet environment
- **Lighting**: Well-lit workspace for hardware shots

### Style Guide
- **Pacing**: Slow enough for beginners, skip-able for experts
- **Font**: Large, readable (minimum 24pt for terminal)
- **Colors**: mythOS blue (#00BFFF) for highlights
- **Music**: Upbeat but not distracting (royalty-free)
- **Length**: Keep under 10 minutes, aim for 3-5

### Publishing
- **Platforms**: YouTube, PeerTube
- **Title format**: "mythOS Tutorial: [Topic] - [Edition]"
- **Tags**: Linux, lightweight, old hardware, WebDT 366, mythOS
- **Description template**:
  ```
  Learn [topic] on mythOS!

  mythOS is a lightweight Linux distribution for old hardware.

  🔗 Links:
  Website: https://nightmare17726.github.io/mythOS
  GitHub: https://github.com/Nightmare17726/mythOS
  Download: [Release link]

  ⏱️ Chapters:
  00:00 Intro
  00:30 [Chapter 1]
  ...

  💬 Questions? Comment below!

  #mythOS #Linux #OldHardware
  ```

---

## Call to Action Templates

### End screen text:
```
✅ mythOS installed successfully!

👍 Found this helpful? Like!
💬 Questions? Comment!
📢 More tutorials? Subscribe!

🔗 Links in description
```

### Verbal CTAs:
- "If this helped, give it a thumbs up!"
- "Subscribe for more mythOS tutorials"
- "Check the description for download links"
- "Join our community on GitHub Discussions"
- "Share this with someone reviving old hardware!"

---

*These scripts are ready for recording. Adjust pacing and technical depth based on your target audience.*
