# mythOS Release Checklist

Complete checklist for creating a mythOS release from start to finish.

---

## Pre-Release Phase

### Code Preparation

- [ ] **Update version numbers**
  - [ ] Update VERSION in all build scripts
  - [ ] Update version in website/index.html
  - [ ] Update version in README.md
  - [ ] Update CHANGELOG.md with new version

- [ ] **Code quality checks**
  - [ ] All scripts have executable permissions (`chmod +x`)
  - [ ] No hardcoded paths that should be variables
  - [ ] All scripts handle errors properly (`set -e`)
  - [ ] Code comments are clear and helpful

- [ ] **Documentation updates**
  - [ ] README.md is up to date
  - [ ] COMPLETE_BUILD_GUIDE.md reflects current process
  - [ ] GETTING_STARTED.md has correct download links
  - [ ] All screenshots are current (if any)
  - [ ] Video tutorial scripts are accurate

### Testing Phase

- [ ] **Build all editions**
  - [ ] Chase edition builds successfully
  - [ ] Pegasus edition builds successfully
  - [ ] Nekomata edition builds successfully
  - [ ] Hydra edition builds successfully
  - [ ] Dragon edition builds successfully

- [ ] **QEMU testing**
  - [ ] Chase boots in QEMU
  - [ ] Pegasus boots and shows GUI
  - [ ] Nekomata boots and shows GUI
  - [ ] Hydra boots and shows GUI
  - [ ] Dragon boots and shows GUI

- [ ] **Feature testing (per edition)**
  - [ ] Welcome screen appears correctly
  - [ ] Theme selector works
  - [ ] Network configuration tool works
  - [ ] Audio works (GUI editions)
  - [ ] Installer works (test install to virtual disk)
  - [ ] System admin tool works
  - [ ] All documented features work

- [ ] **Real hardware testing** (if possible)
  - [ ] Boots on WebDT 366 or similar i586 device
  - [ ] Touchscreen works
  - [ ] WiFi connects
  - [ ] Battery monitoring works
  - [ ] All hardware features work

### Quality Assurance

- [ ] **ISO verification**
  - [ ] All ISOs are under target size (see edition specs)
  - [ ] All ISOs boot correctly
  - [ ] All ISOs have correct checksums
  - [ ] ISOs are hybrid (boot from USB and CD)

- [ ] **Security checks**
  - [ ] No default passwords (except documented root/no-password for Live)
  - [ ] Firewall rules are sane
  - [ ] No unnecessary open ports
  - [ ] SSH is configured securely

- [ ] **Mascot artwork**
  - [ ] All 5 mascots have images (or placeholders)
  - [ ] Images are optimized for size
  - [ ] Images display correctly in GUI
  - [ ] ASCII art displays in terminal

---

## Release Build Phase

### Build ISOs

- [ ] **Clean build environment**
  ```bash
  cd build-system
  rm -rf buildroot-*/ output/
  ```

- [ ] **Generate mascots**
  ```bash
  cd scripts
  ./generate-placeholder-mascots.sh
  # Or use real mascot artwork if available
  ```

- [ ] **Build all editions**
  ```bash
  ./build-all-editions.sh
  ```
  - Expected time: 6-12 hours

- [ ] **Verify all builds completed**
  ```bash
  ls -lh ../output/
  # Should see 5 ISOs with checksums
  ```

- [ ] **Test built ISOs**
  ```bash
  cd ../testing
  ./test-all-editions.sh
  ```

### Create Release Assets

- [ ] **Generate checksums** (if not auto-generated)
  ```bash
  cd build-system/output
  for iso in *.iso; do
      sha256sum "$iso" > "${iso}.sha256"
      md5sum "$iso" > "${iso}.md5"
  done
  ```

- [ ] **Create release notes for each edition**
  - [ ] Chase release notes
  - [ ] Pegasus release notes
  - [ ] Nekomata release notes
  - [ ] Hydra release notes
  - [ ] Dragon release notes

- [ ] **Prepare release README**
  - [ ] Installation instructions
  - [ ] Known issues
  - [ ] System requirements
  - [ ] Support links

---

## Release Publication Phase

### Git Operations

- [ ] **Commit all changes**
  ```bash
  git status
  git add .
  git commit -m "Prepare for release v1.0.0"
  ```

- [ ] **Create and push tag**
  ```bash
  git tag -a v1.0.0 -m "mythOS v1.0.0"
  git push origin v1.0.0
  ```

### GitHub Release

- [ ] **Wait for CI/CD to build** (if using GitHub Actions)
  - [ ] Check Actions tab for build status
  - [ ] All jobs completed successfully
  - [ ] Artifacts are available

- [ ] **Create GitHub Release**
  - [ ] Go to Releases → New Release
  - [ ] Select tag: v1.0.0
  - [ ] Release title: "mythOS v1.0.0 - [Codename]"
  - [ ] Write release description (use template below)

- [ ] **Upload ISOs** (if not auto-uploaded by CI/CD)
  - [ ] mythOS-chase-v1.0.0.iso + checksums
  - [ ] mythOS-pegasus-v1.0.0.iso + checksums
  - [ ] mythOS-nekomata-v1.0.0.iso + checksums
  - [ ] mythOS-hydra-v1.0.0.iso + checksums
  - [ ] mythOS-dragon-v1.0.0.iso + checksums

- [ ] **Attach release notes**
  - [ ] RELEASE_NOTES.md
  - [ ] CHANGELOG.md
  - [ ] KNOWN_ISSUES.md

- [ ] **Publish release**
  - [ ] Mark as "Latest release"
  - [ ] Uncheck "Pre-release" (unless this is a beta)
  - [ ] Click "Publish release"

### Website Updates

- [ ] **Update website download links**
  - [ ] Edit website/index.html
  - [ ] Update version numbers
  - [ ] Update download URLs to point to new release

- [ ] **Deploy website**
  - [ ] Push changes to trigger GitHub Pages deployment
  - [ ] Verify website updates live

- [ ] **Test download links**
  - [ ] All edition downloads work
  - [ ] Checksums are accessible
  - [ ] Release notes are linked correctly

---

## Post-Release Phase

### Communication

- [ ] **Announce release**
  - [ ] GitHub Discussions post
  - [ ] Update README.md with release notes link
  - [ ] Social media announcement (if applicable)
  - [ ] Email notifications (if mailing list exists)

- [ ] **Update documentation**
  - [ ] Mark this version in CHANGELOG.md
  - [ ] Update any version-specific docs
  - [ ] Update FAQ if needed

### Monitoring

- [ ] **Monitor for issues**
  - [ ] Watch GitHub Issues for bug reports
  - [ ] Check Discussions for questions
  - [ ] Monitor download stats

- [ ] **Prepare hotfix branch** (if needed)
  - [ ] Create v1.0.1 branch for critical fixes
  - [ ] Document hotfix process

### Archive

- [ ] **Archive build artifacts**
  - [ ] Save build logs
  - [ ] Archive build environment config
  - [ ] Document build system version used

- [ ] **Tag point of no return**
  - [ ] Create "release-v1.0.0-final" tag
  - [ ] This marks the exact code that produced the release

---

## Release Description Template

Use this template for GitHub Releases:

```markdown
# mythOS v1.0.0 - [Codename]

**Release Date:** [Date]
**Target Hardware:** WebDT 366, i586/i686 devices
**Minimum RAM:** 64MB (Chase) to 512MB (Dragon)

## 🎉 What's New

[List major features and changes]

- New feature X
- Improved feature Y
- Fixed bug Z

## 📥 Download

Choose your edition:

| Edition | Size | Description | Download |
|---------|------|-------------|----------|
| **Chase** | 50MB | Minimal terminal | [ISO](link) \| [SHA256](link) |
| **Pegasus** | 85MB | Simple GUI | [ISO](link) \| [SHA256](link) |
| **Nekomata** | 120MB | Productivity | [ISO](link) \| [SHA256](link) |
| **Hydra** | 150MB | Education | [ISO](link) \| [SHA256](link) |
| **Dragon** | 250MB | Gaming | [ISO](link) \| [SHA256](link) |

## ✅ Installation

1. Download ISO for your preferred edition
2. Verify checksum: `sha256sum -c *.sha256`
3. Write to USB: `sudo dd if=mythOS-*.iso of=/dev/sdX bs=4M status=progress`
4. Boot from USB
5. Run installer: `sudo mythos-installer`

See [Complete Build Guide](link) for detailed instructions.

## 🔧 What's Included

- Disk installer with automatic partitioning
- Touch-optimized UI for tablets
- WiFi & network configuration tools
- Battery monitoring (for portable devices)
- System administration tools
- Audio support (ALSA)
- First-run setup wizards
- [Edition-specific features]

## 🐛 Known Issues

- [List any known issues]
- See [Issue Tracker](link) for complete list

## 📚 Documentation

- [Complete Build Guide](link)
- [Getting Started](link)
- [Troubleshooting](link)
- [FAQ](link)

## 🙏 Credits

Thanks to all contributors and the open source community!

## 💬 Support

- **Issues:** [GitHub Issues](link)
- **Discussions:** [GitHub Discussions](link)
- **Documentation:** [Project Wiki](link)

---

**Full Changelog:** [v0.9.0...v1.0.0](link)
```

---

## Rollback Procedure

If critical issues are discovered after release:

### Immediate Actions

- [ ] Add warning to release notes
- [ ] Mark release as "pre-release" if possible
- [ ] Create GitHub issue documenting the problem
- [ ] Pin issue to repository

### Hotfix Process

1. [ ] Create hotfix branch from release tag
2. [ ] Fix the critical issue
3. [ ] Test thoroughly
4. [ ] Create v1.0.1 following this checklist
5. [ ] Deprecate v1.0.0 in release notes

### Full Rollback

Only if absolutely necessary:

1. [ ] Delete GitHub release
2. [ ] Revert website changes
3. [ ] Create announcement explaining situation
4. [ ] Work on fixes before next attempt

---

## Version Naming Convention

- **Major.Minor.Patch** (e.g., 1.0.0)
  - **Major:** Breaking changes, major features
  - **Minor:** New features, no breaking changes
  - **Patch:** Bug fixes, security updates

- **Codenames:** Optional fun names (e.g., "Phoenix Rising")

---

## Success Criteria

Release is considered successful when:

- [ ] All download links work
- [ ] No critical bugs reported within 48 hours
- [ ] At least 10 successful downloads
- [ ] Positive community feedback
- [ ] All automated tests pass

---

## Timeline

Recommended release schedule:

| Phase | Duration | Notes |
|-------|----------|-------|
| Pre-Release | 1-2 weeks | Testing and fixes |
| Build | 1 day | Full build cycle |
| QA | 2-3 days | Comprehensive testing |
| Release | 1 day | Publication |
| Post-Release | 1 week | Monitor and support |

**Total:** ~3-4 weeks from code freeze to stable release

---

## Notes for Future Releases

Document lessons learned:

- What went well:
  -
- What could improve:
  -
- Process changes for next time:
  -

---

**Release Master:** [Your Name]
**Date Started:** [Date]
**Date Completed:** [Date]

---

*This checklist should be copied for each release and tracked separately.*
