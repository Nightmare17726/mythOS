# Contributing to mythOS

**Thank you for your interest in contributing to mythOS!**

We're excited to have you join us in our mission to breathe new life into old hardware. This guide will help you get started with contributing to the project.

---

## 🌟 Ways to Contribute

There are many ways to contribute to mythOS:

- **Code Contributions:** Build scripts, utilities, system configurations
- **Documentation:** Improve guides, write tutorials, create how-tos
- **Mascot Design:** Create artwork for our mythology-themed mascots
- **Testing:** Test builds on hardware, report bugs, verify fixes
- **Community Support:** Help others in discussions and issues
- **Ideas & Feedback:** Suggest features, improvements, and enhancements

---

## 🚀 Getting Started

### 1. Fork the Repository

1. Visit [https://github.com/Nightmare17726/mythOS](https://github.com/Nightmare17726/mythOS)
2. Click the "Fork" button in the upper right
3. Clone your fork locally:
   ```bash
   git clone https://github.com/YOUR-USERNAME/mythOS.git
   cd mythOS
   ```

### 2. Set Up Development Environment

For building mythOS:
```bash
# Install build dependencies (Debian/Ubuntu)
sudo apt-get update
sudo apt-get install build-essential gcc g++ make patch perl \
                     python3 rsync wget cpio unzip bc

# Install optional tools
sudo apt-get install shellcheck python3-tk git
```

For testing scripts:
```bash
# Test build scripts (won't actually build)
./Programs/build-chase-edition.sh --help

# Test theme installer
./Programs/theme-installer.sh list

# Test AI hub
./Programs/ai-hub-launcher.py list
```

### 3. Create a Branch

Always create a new branch for your contributions:
```bash
git checkout -b feature/your-feature-name
# or
git checkout -b fix/bug-description
# or
git checkout -b docs/documentation-update
```

Branch naming conventions:
- `feature/` - New features
- `fix/` - Bug fixes
- `docs/` - Documentation changes
- `mascot/` - Mascot artwork
- `refactor/` - Code refactoring
- `test/` - Testing improvements

---

## 📝 Development Workflow

### Code Standards

#### Shell Scripts (.sh)
- Use bash shebang: `#!/bin/bash`
- Enable strict mode: `set -e` and `set -u`
- Use descriptive variable names in UPPER_CASE for constants
- Include comprehensive error handling
- Add progress indicators for long-running operations
- Comment complex logic
- Use shellcheck for linting

Example:
```bash
#!/bin/bash
set -e  # Exit on error
set -u  # Exit on undefined variable

MYTHOS_VERSION="1.0.0"

log_info() {
    echo "[INFO] $1"
}

main() {
    log_info "Starting process..."
    # Your code here
}

main "$@"
```

#### Python Scripts (.py)
- Use PEP 8 style guide
- Include docstrings for functions and classes
- Type hints where appropriate
- Error handling with try/except
- Use `if __name__ == "__main__":` pattern

Example:
```python
#!/usr/bin/env python3
"""
Module description here
"""

def main():
    """Main entry point"""
    # Your code here

if __name__ == "__main__":
    main()
```

#### Documentation (.md)
- Use GitHub-flavored Markdown
- Include code examples in fenced code blocks
- Add language hints for syntax highlighting
- Keep lines under 100 characters when possible
- Use headers hierarchically (don't skip levels)
- Include links to related documentation

### Commit Messages

Write clear, descriptive commit messages:

**Good:**
```
Add storage-aware theme selection to installer

- Implement storage checking before theme install
- Add compatibility warnings for insufficient space
- Update theme-installer.sh with storage validation
```

**Bad:**
```
fixed stuff
update file
changes
```

Format:
```
<type>: <short summary (50 chars or less)>

<detailed description of what changed and why>

<footer with issue references if applicable>
```

Types:
- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `style:` - Code style changes (formatting, etc.)
- `refactor:` - Code refactoring
- `test:` - Adding or updating tests
- `chore:` - Maintenance tasks

---

## 🧪 Testing Requirements

### Before Submitting a Pull Request

1. **Test your changes:**
   ```bash
   # For shell scripts
   shellcheck Programs/your-script.sh

   # For Python scripts
   python3 -m py_compile Programs/your-script.py
   python3 -m pylint Programs/your-script.py  # optional

   # Run the script manually to verify
   ./Programs/your-script.sh --help
   ```

2. **Verify documentation:**
   - Check for typos and grammar
   - Ensure code examples work
   - Update README.md if adding new features
   - Add inline comments for complex code

3. **Test on target hardware (if possible):**
   - WebDT 366 or similar low-spec hardware
   - Virtual machine with limited resources
   - Document hardware tested in PR description

---

## 📤 Submitting a Pull Request

### 1. Prepare Your Changes

```bash
# Stage your changes
git add .

# Commit with descriptive message
git commit -m "feat: Add XYZ feature

Detailed description of changes..."

# Push to your fork
git push origin feature/your-feature-name
```

### 2. Create Pull Request

1. Go to your fork on GitHub
2. Click "Pull Request" button
3. Select base repository: `Nightmare17726/mythOS`
4. Select base branch: usually `main`
5. Select your branch with changes
6. Fill out the PR template:

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Mascot artwork
- [ ] Other (please describe)

## Testing
- [ ] Tested on target hardware
- [ ] Tested in VM
- [ ] Scripts pass shellcheck/pylint
- [ ] Documentation updated

## Screenshots (if applicable)
Add screenshots for UI changes or mascot artwork

## Checklist
- [ ] Code follows project style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex code
- [ ] Documentation updated
- [ ] No new warnings generated
```

### 3. Code Review Process

- A maintainer will review your PR
- They may request changes or ask questions
- Address feedback by pushing new commits
- Once approved, your PR will be merged!

---

## 🎨 Contributing Mascot Artwork

### Design Guidelines

1. **Review the Design Brief:**
   - Read [`Documentation/mythOS_Mascot_Design_Brief.docx`](Documentation/mythOS_Mascot_Design_Brief.docx)
   - Follow technical specifications exactly

2. **File Requirements:**
   - Format: PNG with alpha transparency
   - Color depth: 16-bit compatible
   - Sizes: As specified in design brief
   - Total size: <500KB per mascot

3. **Cultural Sensitivity:**
   - Research mythology authentically
   - Respect source cultures
   - Avoid stereotypes
   - Cite mythology sources in PR

4. **Submit Artwork:**
   ```
   Mascots/
   ├── [EditionName]/
   │   ├── [edition]_primary_256.png
   │   ├── [edition]_boot_400x300.png
   │   ├── [edition]_icon_64.png
   │   ├── [edition]_icon_32.png
   │   ├── [edition]_icon_16.png
   │   └── source/
   │       └── [edition]_source.psd (or .ai, .svg)
   ```

5. **Include in PR:**
   - All required sizes
   - Source files (PSD/AI/SVG)
   - Attribution information
   - Mythology research notes

---

## 🐛 Reporting Issues

### Bug Reports

Use the GitHub issue tracker to report bugs:

**Good bug report includes:**
1. **Clear title:** "Theme installer fails on systems with <100MB storage"
2. **Environment:**
   - mythOS edition
   - Hardware specs
   - OS version (if building)
3. **Steps to reproduce:**
   ```
   1. Run ./theme-installer.sh
   2. Select Dragon edition
   3. System has only 80MB available
   4. Error occurs...
   ```
4. **Expected behavior:** What should happen
5. **Actual behavior:** What actually happens
6. **Error messages:** Copy/paste exact errors
7. **Screenshots:** If applicable

### Feature Requests

**Good feature request includes:**
1. **Clear title:** "Add Vulcan edition for developers"
2. **Use case:** Why this feature is needed
3. **Proposed solution:** How it could work
4. **Alternatives considered:** Other options you thought about
5. **Additional context:** Any relevant information

---

## 💬 Community Guidelines

### Code of Conduct

- **Be respectful:** Treat everyone with respect
- **Be collaborative:** Work together constructively
- **Be patient:** Help newcomers learn
- **Be inclusive:** Welcome diverse perspectives
- **Be professional:** Keep discussions on-topic

### Communication Channels

- **GitHub Issues:** Bug reports and feature requests
- **GitHub Discussions:** General questions and conversations
- **Pull Requests:** Code review and collaboration

---

## 📋 Specific Contribution Areas

### Building New Editions

To create a new edition (e.g., Centaur, Phoenix):

1. **Copy build script:**
   ```bash
   cp Programs/build-chase-edition.sh Programs/build-yourEdition-edition.sh
   ```

2. **Update configuration:**
   - Edition name and size
   - Package selections
   - Overlay files
   - Mascot references

3. **Create documentation:**
   - Edition README in `Versions/YourEdition/`
   - Update main README.md
   - Add to theme installer

4. **Test thoroughly:**
   - Build on clean system
   - Test on target hardware
   - Verify ISO boots
   - Check storage footprint

### Improving Build Scripts

Areas for improvement:
- Additional error checking
- Progress indicators
- Support for more architectures
- Differential updates
- Build caching
- CI/CD integration

### Expanding AI Hub

Enhancements welcome:
- Additional AI services
- Offline mode improvements
- Custom service definitions
- Usage statistics
- Service health checking
- API key management (for paid services)

### Documentation Improvements

Always welcome:
- Tutorial videos/articles
- Hardware compatibility lists
- Troubleshooting guides
- Translation to other languages
- FAQ additions
- Code comments

---

## 🏆 Recognition

Contributors will be recognized in:
- Repository README.md contributors section
- Release notes for each version
- Mascot artwork attribution (in Mascots/README.md)
- Documentation credits

---

## 📜 Licensing

By contributing to mythOS, you agree that your contributions will be licensed under the same license as the project (MIT License).

For mascot artwork, you retain copyright but grant mythOS permission to use, modify, and distribute the artwork as part of the project.

---

## 🤝 Getting Help

Need help contributing?

- **New to Git/GitHub?** Check out [GitHub's documentation](https://docs.github.com/en/get-started)
- **Questions about mythOS?** Open a GitHub Discussion
- **Stuck on something?** Comment on your PR or issue
- **Want to chat?** Use GitHub Discussions

---

## 🎯 Current Priorities

Areas where we especially need help:

1. **Mascot Artwork** - All five mascots need professional designs
2. **Hardware Testing** - Test on WebDT 366 and similar devices
3. **Edition Build Scripts** - Scripts for Pegasus, Nekomata, Hydra, Dragon
4. **Documentation** - Tutorials, guides, how-tos
5. **Package Optimization** - Reducing edition sizes further
6. **Accessibility** - Improving Pegasus edition for elderly users

---

## 📚 Additional Resources

- **Project Overview:** [README.md](README.md)
- **Build Guide:** [Documentation/BUILD_ENVIRONMENT_SETUP.md](Documentation/BUILD_ENVIRONMENT_SETUP.md)
- **Theme Structure:** [Documentation/THEME_PACKAGE_STRUCTURE.md](Documentation/THEME_PACKAGE_STRUCTURE.md)
- **Mascot Design:** [Documentation/mythOS_Mascot_Design_Brief.docx](Documentation/mythOS_Mascot_Design_Brief.docx)

---

**Thank you for contributing to mythOS!**

*Together, we're giving old hardware a new purpose.*

---

**Questions?** Open an issue or discussion - we're here to help!
