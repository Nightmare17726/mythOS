# mythOS

**Breathing New Life Into Old Hardware**

A lightweight Linux distribution designed to resurrect obsolete hardware, specifically WebDT 366 tablets (64-128MB RAM, 128-256MB storage), featuring mythology-themed operating system editions with mascot guides and intelligent storage-aware theme selection.

📖 **[→ Getting Started Guide](GETTING_STARTED.md)** - New users start here!

---

## 🌟 Project Overview

mythOS is more than just another Linux distribution - it's a commitment to sustainability, accessibility, and the belief that older hardware still has value. By creating specialized, ultra-lightweight editions, we enable computers that would otherwise be destined for landfills to serve meaningful purposes.

Each edition is guided by a unique mascot from world mythology, providing users with a friendly, themed experience tailored to their specific needs.

---

## 🎭 The Five Themed Editions

### 🐆 Chase (Base Edition) - 50MB
*"Let's see how fast we can make this run!"*

The minimal foundation of mythOS. Perfect for users who want a clean, fast system with essential tools.

**Features:**
- Lightweight X Window System
- JWM window manager
- Dillo web browser
- BusyBox utilities
- Basic networking

**Best for:** First-time Linux users, hardware recyclers, minimalists

---

### 🦄 Pegasus (Simplified Edition) - 85MB
*"Take all the time you need - we'll go at your pace."*

Designed specifically for elderly users and technology newcomers with patience and accessibility in mind.

**Features:**
- High contrast themes
- Large, readable fonts
- Interactive help system
- Simplified interface
- Patient guidance

**Best for:** Seniors, technology newcomers, accessibility-focused users

---

### 🐱 Nekomata (Professional Edition) - 120MB
*"Efficiency is elegance. Let's optimize your workflow!"*

Built for productivity with office tools, AI integration, and professional applications.

**Features:**
- Office suite (LibreOffice lightweight)
- AI assistants integration
- ProtonVPN
- Professional productivity tools
- Multitasking optimizations

**Best for:** Professionals, daily drivers, productivity enthusiasts

---

### 🐉 Hydra (Education Edition) - 150MB
*"Every head is better than one! What shall we learn today?"*

Multi-disciplinary toolkit for students across all fields of study.

**Features:**
- Computer Science tools
- Music creation software
- Study and organization aids
- AI assistants (Claude, ChatGPT, Gemini, Perplexity, NotebookLM)
- ProtonVPN
- Multi-disciplinary approach

**Best for:** Students, educators, researchers, lifelong learners

---

### 🐲 Dragon (Gaming Edition) - 250MB
*"Time to raid the retro gaming vault!"*

Retro gaming paradise with emulators, compatibility layers, and classic games.

**Features:**
- Multiple retro emulators
- Steam integration
- WINE support
- ProtonVPN
- Gaming-optimized settings

**Best for:** Retro gamers, emulation enthusiasts, classic game preservationists

---

## 🚀 Quick Start

> **⚡ New User? Start Here!**
> Check out **[GETTING_STARTED.md](GETTING_STARTED.md)** for super simple step-by-step instructions on how to:
> - Test mythOS in a Virtual Machine (VM) on macOS or Windows
> - Create a bootable USB drive
> - Boot mythOS on real hardware
>
> **No Linux experience required!** 🎉

### System Requirements

**Minimum:**
- CPU: i586 or better
- RAM: 64MB
- Storage: 128MB
- Display: 800x600

**Recommended:**
- RAM: 128MB
- Storage: 256MB
- Display: 1024x768

### Installation

1. Download your preferred edition from [Releases](https://github.com/Nightmare17726/mythOS/releases)
2. Verify the download using provided checksums
3. Create bootable media (USB/CD)
4. Boot from the media
5. Follow the on-screen installation prompts

Detailed installation instructions are available in [`Documentation/BUILD_ENVIRONMENT_SETUP.md`](Documentation/BUILD_ENVIRONMENT_SETUP.md)

---

## 🛠️ Building from Source

mythOS uses Buildroot as its build system. To build an edition from source:

```bash
# Install dependencies (Debian/Ubuntu)
sudo apt-get install build-essential gcc g++ make patch perl python3 rsync wget cpio unzip bc

# Clone the repository
git clone https://github.com/Nightmare17726/mythOS.git
cd mythOS

# Build Chase Edition (example)
cd Programs
./build-chase-edition.sh
```

For complete build instructions, see [`Documentation/BUILD_ENVIRONMENT_SETUP.md`](Documentation/BUILD_ENVIRONMENT_SETUP.md)

---

## 🎨 Switching Themes/Editions

mythOS features intelligent, storage-aware theme switching that preserves your personal data:

```bash
# Run the theme installer
sudo Programs/theme-installer.sh

# Or install a specific edition directly
sudo Programs/theme-installer.sh install Hydra
```

Your personal files in `/home` are always preserved during theme switches!

---

## 🤖 AI Integration

mythOS includes the AI Hub Launcher for easy access to AI assistants:

```bash
# Launch AI Hub (GUI)
Programs/ai-hub-launcher.py

# Launch specific AI assistant
Programs/ai-hub-launcher.py launch Claude

# List available AI services
Programs/ai-hub-launcher.py list
```

Supported AI tools:
- Claude (Anthropic)
- ChatGPT (OpenAI)
- Gemini (Google)
- Perplexity AI
- NotebookLM (Google)
- HuggingChat
- Ollama (local LLMs)

---

## 📚 Documentation

- **[Project Proposal](Documentation/mythOS_Project_Proposal.docx)** - Comprehensive project overview and goals
- **[Build Environment Setup](Documentation/BUILD_ENVIRONMENT_SETUP.md)** - Complete Buildroot setup guide
- **[Theme Package Structure](Documentation/THEME_PACKAGE_STRUCTURE.md)** - Theme packaging and distribution
- **[Mascot Design Brief](Documentation/mythOS_Mascot_Design_Brief.docx)** - Professional mascot specifications
- **[Contributing Guidelines](CONTRIBUTING.md)** - How to contribute to mythOS

---

## 🎭 Mascot System

Each mythOS edition is guided by a unique mascot from world mythology:

- **Chase** - Swift cheetah/fox, representing speed and efficiency
- **Pegasus** - Gentle winged horse, representing patience and accessibility
- **Nekomata** - Professional two-tailed cat, representing multitasking productivity
- **Hydra** - Multi-headed dragon, representing multi-disciplinary learning
- **Dragon** - Classic gaming dragon, representing treasure hunting and preservation

For detailed mascot specifications, see [`Documentation/mythOS_Mascot_Design_Brief.docx`](Documentation/mythOS_Mascot_Design_Brief.docx)

---

## 🤝 Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for:
- How to contribute
- Development workflow
- Code standards
- Issue reporting guidelines

---

## 🗂️ Repository Structure

```
mythOS/
├── Documentation/          # Project documentation and guides
│   ├── mythOS_Project_Proposal.docx
│   ├── mythOS_Mascot_Design_Brief.docx
│   ├── BUILD_ENVIRONMENT_SETUP.md
│   └── THEME_PACKAGE_STRUCTURE.md
├── Mascots/               # Mascot artwork and assets
│   ├── Chase/
│   ├── Pegasus/
│   ├── Nekomata/
│   ├── Hydra/
│   └── Dragon/
├── Programs/              # Scripts and utilities
│   ├── build-chase-edition.sh
│   ├── theme-installer.sh
│   └── ai-hub-launcher.py
├── Potential GUIs/        # UI mockups and prototypes
│   └── theme-selector-ui.html
└── Versions/              # Edition-specific configurations
    ├── Chase/
    ├── Pegasus/
    ├── Nekomata/
    ├── Hydra/
    └── Dragon/
```

---

## 📋 Technical Details

### Partition Strategy
- `/boot` - 10MB - Kernel and bootloader
- `/system` - Variable (50-250MB) - Operating system files
- `/home` - Remaining space - User data (preserved during updates)

### Build System
- **Base:** Buildroot 2024.02
- **Kernel:** Linux 5.15 LTS
- **Init:** BusyBox init
- **Display:** X.org with lightweight window managers

### Distribution
- **Format:** .tar.gz packages
- **Hosting:** GitHub Releases
- **Verification:** SHA256 and MD5 checksums
- **Updates:** Theme installer with GitHub integration

### Security
- ProtonVPN integration (Hydra, Dragon, Nekomata editions)
- Regular security updates via package manager
- Minimal attack surface (fewer packages = fewer vulnerabilities)

---

## 📜 License

This project is open source and available under the [MIT License](LICENSE).

---

## 🙏 Acknowledgments

- **Linux From Scratch** - Inspiration and guidance
- **Buildroot Project** - Build system foundation
- **WebDT 366 Community** - Hardware specifications and support
- **Mythology Enthusiasts** - Cultural guidance for mascot design

---

## 📬 Contact & Support

- **Issues:** [GitHub Issues](https://github.com/Nightmare17726/mythOS/issues)
- **Discussions:** [GitHub Discussions](https://github.com/Nightmare17726/mythOS/discussions)
- **Repository:** [https://github.com/Nightmare17726/mythOS](https://github.com/Nightmare17726/mythOS)

---

## 🌍 Project Philosophy

> *"The best time to plant a tree was 20 years ago. The second best time is now."*
>
> *"The best computer is the one you already have."*

mythOS believes that:
- Old hardware still has value and purpose
- Technology should be accessible to everyone
- Environmental responsibility includes hardware reuse
- Different users have different needs - one size doesn't fit all
- Learning should be fun, guided, and supported

---

**Built with ❤️ by the mythOS Team**

*Breathing new life into old hardware, one boot at a time.*
