# Getting Started with mythOS

**Super Simple Guide for macOS and Windows Users**

This guide will help you test mythOS on your computer using either:
- **Virtual Machine (VM)** - Test mythOS safely in a virtual computer
- **Bootable USB** - Run mythOS on real hardware from a USB drive

---

## 📥 Step 1: Download mythOS

### Option A: Download Pre-Built ISO (Recommended)

> **Note:** Pre-built ISOs will be available once the first release is published!

1. Go to the mythOS Releases page:
   ```
   https://github.com/Nightmare17726/mythOS/releases
   ```

2. Download the edition you want:
   - `mythOS-Chase-1.0.0.iso` (50MB) - Smallest, fastest
   - `mythOS-Pegasus-1.0.0.iso` (85MB) - Simplified interface
   - `mythOS-Nekomata-1.0.0.iso` (120MB) - Professional tools
   - `mythOS-Hydra-1.0.0.iso` (150MB) - Student edition
   - `mythOS-Dragon-1.0.0.iso` (250MB) - Gaming edition

3. Save the `.iso` file to your Downloads folder

### Option B: Build Your Own ISO (Advanced)

See the [BUILD_ENVIRONMENT_SETUP.md](Documentation/BUILD_ENVIRONMENT_SETUP.md) guide.

---

## 🖥️ Step 2A: Test in a Virtual Machine (EASIEST)

Virtual machines let you test mythOS safely without affecting your computer.

### For macOS Users:

#### Option 1: UTM (Recommended for Apple Silicon Macs)

1. **Download UTM** (free):
   - Visit: https://mac.getutm.app
   - Click "Download" and install UTM.app

2. **Create a New Virtual Machine:**
   - Open UTM
   - Click the **"+"** button
   - Select **"Virtualize"**
   - Choose **"Linux"**

3. **Configure the VM:**
   - **Name:** mythOS Chase (or whatever edition you downloaded)
   - **RAM:** 256 MB (minimum) or 512 MB (recommended)
   - **CPU Cores:** 1
   - **Storage:** 512 MB (for Chase) to 1 GB (for Dragon)

4. **Attach the ISO:**
   - Click **"Browse"** next to "Boot ISO Image"
   - Select your downloaded mythOS ISO file
   - Click **"Continue"**

5. **Save and Start:**
   - Click **"Save"**
   - Select your mythOS VM
   - Click the **▶ Play** button

6. **Boot mythOS:**
   - You should see the mythOS boot screen
   - Follow the on-screen prompts!

#### Option 2: VirtualBox (Works on Intel and Apple Silicon)

1. **Download VirtualBox:**
   - Visit: https://www.virtualbox.org/wiki/Downloads
   - Download "OS X hosts" version
   - Install VirtualBox.app

2. **Create a New VM:**
   - Open VirtualBox
   - Click **"New"**
   - **Name:** mythOS Chase
   - **Type:** Linux
   - **Version:** Other Linux (32-bit)
   - Click **"Continue"**

3. **Set Memory:**
   - **RAM:** 256 MB minimum, 512 MB recommended
   - Click **"Continue"**

4. **Create Virtual Hard Disk:**
   - Select **"Create a virtual hard disk now"**
   - Click **"Create"**
   - **Size:** 512 MB (Chase) to 1 GB (Dragon)
   - Click **"Create"**

5. **Attach ISO:**
   - Select your mythOS VM
   - Click **"Settings"** (gear icon)
   - Go to **"Storage"**
   - Click the empty CD icon under "Controller: IDE"
   - Click the CD icon on the right → **"Choose a disk file"**
   - Select your mythOS ISO
   - Click **"OK"**

6. **Start the VM:**
   - Click **"Start"** (green arrow)
   - mythOS should boot!

---

### For Windows Users:

#### Option 1: VirtualBox (Recommended)

1. **Download VirtualBox:**
   - Visit: https://www.virtualbox.org/wiki/Downloads
   - Download "Windows hosts" version
   - Run the installer and install VirtualBox

2. **Create a New VM:**
   - Open VirtualBox
   - Click **"New"**
   - **Name:** mythOS Chase
   - **Type:** Linux
   - **Version:** Other Linux (32-bit)
   - Click **"Next"**

3. **Set Memory:**
   - **RAM:** 256 MB minimum, 512 MB recommended
   - Click **"Next"**

4. **Create Virtual Hard Disk:**
   - Select **"Create a virtual hard disk now"**
   - Click **"Create"**
   - Select **"VDI (VirtualBox Disk Image)"**
   - Click **"Next"**
   - Select **"Dynamically allocated"**
   - Click **"Next"**
   - **Size:** 512 MB to 1 GB
   - Click **"Create"**

5. **Attach ISO:**
   - Right-click your mythOS VM
   - Click **"Settings"**
   - Go to **"Storage"**
   - Click the empty CD icon under "Controller: IDE"
   - Click the CD icon on the right
   - Click **"Choose a disk file"**
   - Select your mythOS ISO
   - Click **"OK"**

6. **Start the VM:**
   - Click **"Start"**
   - mythOS should boot!

#### Option 2: VMware Workstation Player (Free for Personal Use)

1. **Download VMware Player:**
   - Visit: https://www.vmware.com/products/workstation-player.html
   - Download and install

2. **Create a New VM:**
   - Open VMware Player
   - Click **"Create a New Virtual Machine"**
   - Select **"Installer disc image file (iso)"**
   - Click **"Browse"** and select your mythOS ISO
   - Click **"Next"**

3. **Configure VM:**
   - **Guest OS:** Linux
   - **Version:** Other Linux 3.x or later kernel (32-bit)
   - Click **"Next"**
   - **VM Name:** mythOS Chase
   - Click **"Next"**

4. **Set Disk Size:**
   - **Size:** 0.5 GB (Chase) to 1 GB (Dragon)
   - Select **"Store virtual disk as a single file"**
   - Click **"Next"**

5. **Customize Hardware:**
   - Click **"Customize Hardware"**
   - **Memory:** 256 MB minimum, 512 MB recommended
   - Click **"Close"**
   - Click **"Finish"**

6. **Start the VM:**
   - Click **"Play virtual machine"**
   - mythOS should boot!

---

## 💾 Step 2B: Create a Bootable USB Drive

Use this method to run mythOS on real hardware (like the WebDT 366).

### For macOS Users:

#### Method 1: Using balenaEtcher (EASIEST)

1. **Download balenaEtcher:**
   - Visit: https://etcher.balena.io
   - Download for macOS
   - Install balenaEtcher.app

2. **Insert USB Drive:**
   - Plug in a USB drive (256 MB to 1 GB is plenty)
   - ⚠️ **WARNING:** All data on the USB will be erased!

3. **Flash the ISO:**
   - Open balenaEtcher
   - Click **"Flash from file"**
   - Select your mythOS ISO
   - Click **"Select target"**
   - Choose your USB drive
   - Click **"Flash!"**
   - Enter your password when prompted
   - Wait for it to finish

4. **Eject USB:**
   - Click **"Eject"** or drag the USB to Trash
   - Remove the USB drive

5. **Boot from USB:**
   - Plug USB into target computer
   - Turn on computer
   - Press boot menu key (usually F12, F2, or Del)
   - Select the USB drive
   - mythOS should boot!

#### Method 2: Using Terminal (dd command)

1. **Insert USB Drive:**
   - Plug in your USB drive

2. **Open Terminal:**
   - Press `Cmd + Space`
   - Type "Terminal"
   - Press Enter

3. **Find USB Drive:**
   ```bash
   diskutil list
   ```
   - Look for your USB drive (usually `/dev/disk2` or `/dev/disk3`)
   - Note the disk number (e.g., `disk2`)

4. **Unmount the USB:**
   ```bash
   diskutil unmountDisk /dev/diskN
   ```
   - Replace `N` with your disk number

5. **Flash the ISO:**
   ```bash
   sudo dd if=~/Downloads/mythOS-Chase-1.0.0.iso of=/dev/rdiskN bs=1m
   ```
   - Replace `N` with your disk number
   - Replace the ISO path if different
   - Enter your password
   - ⚠️ This will take several minutes with NO progress shown
   - Wait patiently!

6. **Eject:**
   ```bash
   diskutil eject /dev/diskN
   ```

---

### For Windows Users:

#### Method 1: Using Rufus (EASIEST)

1. **Download Rufus:**
   - Visit: https://rufus.ie
   - Download the latest version
   - No installation needed - just run `rufus.exe`

2. **Insert USB Drive:**
   - Plug in a USB drive (256 MB to 1 GB)
   - ⚠️ **WARNING:** All data on the USB will be erased!

3. **Flash the ISO:**
   - Open Rufus
   - **Device:** Select your USB drive
   - **Boot selection:** Click "SELECT" and choose your mythOS ISO
   - **Partition scheme:** MBR
   - **Target system:** BIOS or UEFI
   - **File system:** FAT32
   - Click **"START"**
   - Click **"OK"** on any warnings
   - Wait for it to finish

4. **Eject USB:**
   - Click the eject icon in system tray
   - Remove the USB drive

5. **Boot from USB:**
   - Plug USB into target computer
   - Turn on computer
   - Press boot menu key (usually F12, F2, Del, or Esc)
   - Select the USB drive
   - mythOS should boot!

#### Method 2: Using balenaEtcher

1. **Download balenaEtcher:**
   - Visit: https://etcher.balena.io
   - Download for Windows
   - Install balenaEtcher

2. **Follow the same steps** as the macOS balenaEtcher method above

---

## 🖱️ Step 3: Using mythOS

Once mythOS boots (in VM or from USB):

### First Boot:

1. **Boot Screen:**
   - You'll see the mythOS splash screen with your chosen mascot
   - Wait a few seconds for it to load

2. **Welcome Screen:**
   - Your mascot will greet you!
   - Chase: "Let's see how fast we can make this run!"
   - Pegasus: "Take all the time you need - we'll go at your pace."
   - Nekomata: "Efficiency is elegance. Let's optimize your workflow!"
   - Hydra: "Every head is better than one! What shall we learn today?"
   - Dragon: "Time to raid the retro gaming vault!"

3. **Login (if prompted):**
   - **Username:** `mythos`
   - **Password:** (none, just press Enter)

4. **Start Graphical Environment:**
   ```bash
   startx
   ```
   - This launches the graphical desktop

### Basic Commands:

Once you're in the graphical environment:

- **File Manager:** Click the folder icon or type `pcmanfm`
- **Web Browser:** Click the browser icon or type `dillo`
- **Terminal:** Right-click desktop → Terminal

### Testing Features:

#### Chase Edition:
- Browse the web with Dillo
- Manage files with PCManFM
- Test minimal resource usage

#### Hydra Edition:
- Launch AI Hub: `/Programs/ai-hub-launcher.py`
- Access study tools
- Try ProtonVPN

#### Dragon Edition:
- Check out retro games
- Test emulators
- Explore the gaming library

---

## 🎯 Quick Reference

### Minimum System Requirements (for VMs):

| Edition   | RAM   | Storage | Best For                |
|-----------|-------|---------|-------------------------|
| Chase     | 256MB | 512MB   | Testing basics          |
| Pegasus   | 256MB | 512MB   | Accessibility testing   |
| Nekomata  | 256MB | 512MB   | Productivity testing    |
| Hydra     | 512MB | 1GB     | AI tools testing        |
| Dragon    | 512MB | 1GB     | Gaming testing          |

### Boot Menu Keys by Manufacturer:

| Manufacturer | Boot Menu Key | BIOS Key |
|--------------|---------------|----------|
| Dell         | F12           | F2       |
| HP           | F9 or Esc     | F10      |
| Lenovo       | F12           | F1       |
| Acer         | F12           | F2       |
| ASUS         | F8 or Esc     | F2       |
| Samsung      | F12 or Esc    | F2       |
| Toshiba      | F12           | F2       |
| WebDT 366    | F12           | Del      |

---

## ❓ Troubleshooting

### Problem: VM Won't Boot

**Solution:**
- Make sure the ISO is attached to the CD/DVD drive
- Check that VM is set to boot from CD first
- Increase RAM to 256MB or higher
- Make sure you selected "Other Linux (32-bit)" as OS type

### Problem: USB Won't Boot

**Solution:**
- Try a different USB port
- Make sure USB is set as first boot device in BIOS
- Some computers need "Legacy Boot" or "CSM" enabled
- Try a different USB drive (some older computers are picky)

### Problem: Screen Resolution is Wrong

**Solution:**
- mythOS defaults to 800x600 for maximum compatibility
- For VMs, install VirtualBox Guest Additions (advanced)
- For real hardware, this is expected on old hardware

### Problem: No Network Connection

**Solution:**
- For VMs: Check VM network settings (NAT or Bridged)
- For USB boots: Driver may need time to load
- Some WiFi cards may need additional drivers

### Problem: ISO Download Failed

**Solution:**
- Check the Releases page for the correct URL
- Verify file size matches what's listed
- Download may not be available yet (project in development)

### Problem: "No Space Left" Error

**Solution:**
- Increase VM hard disk size
- Choose a smaller edition (Chase instead of Dragon)
- For USB, use a larger USB drive

---

## 🚀 Next Steps

### After Testing in VM:

1. **Try different editions** - Each has unique features!
2. **Test on real hardware** - Create a bootable USB
3. **Report bugs** - Open an issue on GitHub
4. **Contribute** - See [CONTRIBUTING.md](CONTRIBUTING.md)

### For Real Hardware Deployment:

1. **Target WebDT 366 or similar** low-spec hardware
2. **Backup any existing data** first!
3. **Boot from USB** and test
4. **Install to hard drive** (follow on-screen prompts)

---

## 📚 Additional Resources

- **Full Documentation:** [README.md](README.md)
- **Build Guide:** [Documentation/BUILD_ENVIRONMENT_SETUP.md](Documentation/BUILD_ENVIRONMENT_SETUP.md)
- **Contributing:** [CONTRIBUTING.md](CONTRIBUTING.md)
- **Programs Guide:** [Programs/README.md](Programs/README.md)

---

## 💡 Tips

### For macOS Users:
- Apple Silicon Macs: Use UTM (it's faster)
- Intel Macs: VirtualBox works great
- Don't use the built-in "dd" unless you're comfortable with Terminal

### For Windows Users:
- Rufus is the easiest tool for USB creation
- VirtualBox is free and works well
- Windows 11 users: May need to disable Secure Boot for USB boot

### For Everyone:
- **Start with Chase Edition** - It's the smallest and fastest to test
- **VMs are safer** - Test in VM before trying on real hardware
- **Backup everything** - Before installing on real hardware
- **Ask for help** - Open a GitHub Discussion if you're stuck!

---

## 🎉 You're Ready!

Pick your method:
- **🖥️ VM Testing** (easiest, safest)
- **💾 USB Boot** (for real hardware)

Then download your favorite edition and start testing mythOS!

**Questions?** Open an issue: https://github.com/Nightmare17726/mythOS/issues

**Happy Testing!** 🚀

---

*Breathing new life into old hardware - one USB drive at a time.*
