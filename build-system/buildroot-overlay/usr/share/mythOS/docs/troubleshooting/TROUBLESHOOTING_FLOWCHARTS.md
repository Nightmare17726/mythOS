# mythOS Troubleshooting Flowcharts

Visual guides for common problems and their solutions.

---

## 🚫 System Won't Boot

```
START: mythOS won't boot
    |
    ↓
Does BIOS show mythOS device? ─── NO ──→ Check boot order in BIOS
    │                                      Set USB/HDD as first boot device
    │ YES                                  ↓
    ↓                                     RETRY
mythOS logo appears? ─── NO ──→ Boot media corrupted
    │                            Re-write ISO to USB
    │ YES                        Verify checksum (SHA256)
    ↓                           ↓
Kernel panic shown? ─── YES ──→ Hardware incompatibility
    │                            - Check RAM (min 64MB for Chase)
    │ NO                         - Try different boot parameters
    ↓                            - Check kernel logs
Boot stops at login? ─── YES ──→ Normal! Login as root (no password for Live)
    │                            Run: mythos-installer
    │ NO
    ↓
System freezes during boot? ─── YES ──→ Disable problematic services
    │                                    Boot with: init=/bin/bash
    │ NO
    ↓
SOLVED ✅
```

---

## 📡 No Network Connection

```
START: Network not working
    |
    ↓
Is this WiFi or Ethernet? ─── ETHERNET ──→ Cable connected?
    │                                        ↓ YES
    │ WIFI                                  Run: dhcpcd eth0
    ↓                                        Check lights on port
WiFi LED on? ─── NO ──→ WiFi hardware issue
    │                    Try USB WiFi adapter
    │ YES                Check lsusb / lspci
    ↓                   ↓
Run: iw dev            RETRY
    |
    ↓
Interface shown? ─── NO ──→ Driver not loaded
    │                        Run: lsmod | grep -i wifi
    │ YES                    Load driver with modprobe
    ↓
Run: sudo network-config-ui
    |
    ↓
Can scan networks? ─── NO ──→ Permission issue
    │                          Run with sudo
    │ YES
    ↓
Select network & enter password
    |
    ↓
Connected but no internet? ─── YES ──→ DNS issue
    │                                   Add to /etc/resolv.conf:
    │ NO                                nameserver 8.8.8.8
    ↓
Test: ping 8.8.8.8
    |
    ↓
SOLVED ✅
```

---

## 🔇 No Audio

```
START: No sound
    |
    ↓
Run: audio-setup --quick
    |
    ↓
Hardware detected? ─── NO ──→ No audio hardware
    │                          OR drivers not loaded
    │ YES                      Check: cat /proc/asound/cards
    ↓                          Load: modprobe snd-hda-intel
Unmute channels
Run: amixer sset Master unmute
    amixer sset Master 80%
    |
    ↓
Run: speaker-test -c 2
    |
    ↓
Hear sound? ─── NO ──→ Check physical connections
    │                   - Headphones plugged in?
    │ YES                - Speakers on?
    ↓                    - Volume knob turned up?
Check app-specific volume          ↓
    |                          RETRY
    ↓
SOLVED ✅
```

---

## 🖥️ GUI Won't Start

```
START: GUI doesn't start
    |
    ↓
Is this a GUI edition? ─── NO ──→ Chase is terminal-only
    │                              Use: theme-selector to switch
    │ YES                         ↓
    ↓                            DONE
Run: startx
    |
    ↓
X server starts? ─── NO ──→ Check X logs
    │                        cat /var/log/Xorg.0.log
    │ YES                    Look for (EE) errors
    ↓                       ↓
Black screen?            Graphics driver issue
    │ NO                 Try: vesa or fbdev
    │                   ↓
Desktop appears?      RETRY
    │ NO
    │
Window manager issue
Run: openbox &
    |
    ↓
SOLVED ✅
```

---

## 💾 Installer Fails

```
START: Installation fails
    |
    ↓
Which step fails? ─── PARTITIONING ──→ Disk not recognized
    │                                    Try: fdisk -l
    │                                    Check disk health
    │ FORMATTING                        ↓
    │                                  RETRY
    ↓
Check disk space
    |
    ↓
Enough space? ─── NO ──→ Need minimum:
    │                     - Chase: 200MB
    │ YES                - Pegasus: 350MB
    ↓                    - Nekomata: 500MB
Permission denied?      - Hydra: 600MB
Run as root            - Dragon: 800MB
sudo mythos-installer
    |
    ↓
SOLVED ✅
```

---

## 🔄 Theme Switching Fails

```
START: Can't switch editions
    |
    ↓
Run: theme-selector-terminal
    |
    ↓
Shows available editions? ─── NO ──→ Database issue
    │                                 Run: myth-pkg update
    │ YES
    ↓
Select desired edition
    |
    ↓
"Incompatible" warning? ─── YES ──→ Not enough storage
    │                                 Need larger disk
    │ NO                             Check requirements
    ↓
Download starts? ─── NO ──→ Network issue
    │                        Check internet connection
    │ YES
    ↓
Installation successful? ─── NO ──→ Check logs
    │                                 Verify checksums
    │ YES
    ↓
Reboot required
Remove USB if Live boot
    |
    ↓
SOLVED ✅
```

---

## 🔋 Battery Issues

```
START: Battery problems
    |
    ↓
Run: battery-monitor-gui
    |
    ↓
Battery detected? ─── NO ──→ Running on AC power
    │                         OR battery hardware issue
    │ YES                     Check BIOS battery status
    ↓
Percentage accurate? ─── NO ──→ Calibrate battery
    │                            Full charge → full discharge
    │ YES
    ↓
Draining too fast? ─── YES ──→ Enable power save
    │                            Run: parental-controls
    │ NO                         Reduce screen brightness
    ↓                            Close unused apps
Not charging? ─── YES ──→ Check AC adapter
    │                      Check charging port
    │ NO                  Battery may be dead
    ↓
SOLVED ✅
```

---

## 🐛 General Debugging

```
START: Something's broken
    |
    ↓
Check system logs
    |
    ↓
Run: dmesg | tail -50
     journalctl -xe (if systemd)
    |
    ↓
Note error messages
    |
    ↓
Search error online:
"mythOS [error message]"
    |
    ↓
Try suggested solutions
    |
    ↓
Still broken? ─── YES ──→ File GitHub issue
    │                      github.com/Nightmare17726/mythOS/issues
    │ NO                  Include:
    ↓                     - Edition & version
SOLVED ✅              - Error messages
                       - Steps to reproduce
                       - System info
```

---

## 📊 Quick Diagnostic Commands

```bash
# System information
uname -a
cat /etc/mythos-release
myth-settings list

# Hardware info
lspci
lsusb
cat /proc/cpuinfo
free -h
df -h

# Network diagnostic
ip addr
iw dev
ping -c 4 8.8.8.8

# Audio diagnostic
cat /proc/asound/cards
amixer
aplay -l

# Process/Performance
top
ps aux
systemctl status  # if systemd

# Logs
dmesg
tail -f /var/log/messages
cat /var/log/Xorg.0.log
```

---

## 🆘 Emergency Recovery

If system is completely broken:

1. **Boot to rescue mode**: Add `single` to kernel parameters
2. **Reset settings**: `myth-settings reset system`
3. **Reinstall**: Boot from USB and run installer again
4. **Backup data first**: Mount `/home` and copy important files

---

## 📞 Getting Help

1. **Documentation**: `/usr/share/mythOS/docs/`
2. **GitHub Issues**: https://github.com/Nightmare17726/mythOS/issues
3. **Community**: GitHub Discussions
4. **Logs to share**:
   - `dmesg > dmesg.log`
   - `lspci > hardware.txt`
   - Include `/var/log/Xorg.0.log` for GUI issues

---

*These flowcharts cover 90% of common issues. For rare problems, consult the community.*
