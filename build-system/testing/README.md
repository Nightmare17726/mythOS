# mythOS Testing Guide

This directory contains testing scripts and configurations for mythOS.

## Quick Start

### Test Chase Edition (minimal)
```bash
./test-chase.sh
```

### Test Any Edition
```bash
./test-all-editions.sh
```

### Test with WebDT 366 Hardware Simulation
```bash
./test-webdt366.sh chase
./test-webdt366.sh dragon
```

## Test Scenarios

### 1. Basic Boot Test
Verify the system boots and shows the welcome screen:
- Run QEMU test script
- Check boot screen appears
- Verify edition name is correct
- Check ASCII logo displays

### 2. Network Test
Test network connectivity:
- Boot in QEMU
- Log in (default: root, no password)
- Run: `ping 8.8.8.8`
- Run: `wget https://www.google.com`

### 3. GUI Test (for GUI editions)
Test graphical interface:
- Boot Pegasus/Nekomata/Hydra/Dragon edition
- Wait for X11 to start
- Verify Openbox loads
- Test right-click menu
- Launch applications from menu

### 4. Theme Switcher Test
Test edition switching:
- Boot any edition
- Run: `theme-selector-terminal` or `theme-selector-gui`
- Verify storage detection works
- Check incompatible editions are grayed out

### 5. Installer Test
Test disk installation:
- Boot from ISO in QEMU
- Create virtual disk: `qemu-img create -f qcow2 test-disk.qcow2 2G`
- Add to QEMU: `-hda test-disk.qcow2`
- Run: `sudo mythos-installer`
- Follow installation steps
- Reboot and verify boots from disk

## Test Cases by Edition

### Chase Edition (50MB, Terminal only)
- [ ] Boots to terminal
- [ ] ASCII welcome appears
- [ ] Terminal menu works
- [ ] Links browser launches
- [ ] System info displays correctly
- [ ] Network tools work (ping, wget, ssh)
- [ ] Theme selector shows other editions
- [ ] Runs in 64MB RAM

### Pegasus Edition (85MB, Simple GUI)
- [ ] Boots to GUI automatically
- [ ] Welcome window appears
- [ ] Large fonts render correctly
- [ ] File manager opens
- [ ] Firefox launches
- [ ] Accessibility features work
- [ ] Runs in 128MB RAM

### Nekomata Edition (120MB, Productivity)
- [ ] GUI loads with all applications
- [ ] Office suite (AbiWord) works
- [ ] Image tools launch
- [ ] VPN configuration available
- [ ] File manager shows network shares
- [ ] Runs smoothly in 256MB RAM

### Hydra Edition (150MB, Education)
- [ ] All educational tools available
- [ ] Python interpreter works
- [ ] Git installed and functional
- [ ] Network tools (nmap, wireshark) present
- [ ] AI Hub launcher works
- [ ] Development tools compile simple programs
- [ ] Runs in 384MB RAM

### Dragon Edition (250MB, Gaming)
- [ ] GUI loads with gaming optimizations
- [ ] Audio works (test with speaker-test)
- [ ] Emulators launch
- [ ] SDL games run
- [ ] Video playback works
- [ ] OpenGL support available
- [ ] Runs in 512MB+ RAM

## Hardware Tests (Real Hardware)

### WebDT 366 Specific Tests
1. **Boot from USB:**
   - Write ISO to USB stick
   - Boot on WebDT 366
   - Verify touchscreen works
   - Test WiFi connectivity
   - Check battery monitoring

2. **Performance Tests:**
   - Measure boot time (target: <30 seconds)
   - Check memory usage after boot
   - Test application launch times
   - Verify smooth UI interaction

3. **Power Management:**
   - Test suspend/resume
   - Battery life measurement
   - CPU frequency scaling
   - Screen brightness control

## Automated Test Suite (TODO)

Future automated tests:
```bash
./run-automated-tests.sh
```

This will test:
- Boot success rate
- Application launches
- Network connectivity
- Storage operations
- Edition switching
- Installer functionality

## Continuous Integration (TODO)

GitHub Actions workflow to:
- Build all editions
- Run QEMU tests
- Check ISO sizes
- Verify package installations
- Test installer
- Generate release artifacts

## Reporting Issues

When reporting test failures, include:
1. Edition name and version
2. Test scenario
3. Expected behavior
4. Actual behavior
5. QEMU command or hardware specs
6. Screenshots/logs if applicable

Submit issues at: https://github.com/Nightmare17726/mythOS/issues
