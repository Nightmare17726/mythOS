#!/bin/bash
################################################################################
# mythOS - Chase Edition Build Script
# Automated ISO builder for the Chase (Base) Edition
#
# Target: WebDT 366 (64-128MB RAM, 128-256MB storage)
# Build System: Buildroot
# Edition Size: ~50MB
# Features: Minimal system, basic web browsing, file management
################################################################################

set -e  # Exit on error
set -u  # Exit on undefined variable

################################################################################
# Configuration
################################################################################

MYTHOS_VERSION="1.0.0"
EDITION="Chase"
EDITION_SIZE="50MB"
BUILD_DIR="${BUILD_DIR:-$(pwd)/buildroot}"
OUTPUT_DIR="${OUTPUT_DIR:-$(pwd)/output/chase}"
CONFIG_DIR="${CONFIG_DIR:-$(pwd)/configs}"
ISO_NAME="mythOS-Chase-${MYTHOS_VERSION}.iso"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Build configuration
BUILDROOT_VERSION="2024.02"
BUILDROOT_URL="https://buildroot.org/downloads/buildroot-${BUILDROOT_VERSION}.tar.gz"
KERNEL_VERSION="5.15"  # LTS kernel for hardware compatibility

################################################################################
# Functions
################################################################################

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_banner() {
    echo "════════════════════════════════════════════════════════════════"
    echo "  mythOS Build System - Chase Edition"
    echo "  Version: ${MYTHOS_VERSION}"
    echo "  Target Size: ${EDITION_SIZE}"
    echo "  Build Date: $(date +%Y-%m-%d)"
    echo "════════════════════════════════════════════════════════════════"
    echo ""
}

check_dependencies() {
    log_info "Checking build dependencies..."

    local missing_deps=()

    # Required packages for Buildroot
    local required_tools=(
        "gcc"
        "g++"
        "make"
        "patch"
        "perl"
        "python3"
        "rsync"
        "wget"
        "cpio"
        "unzip"
        "bc"
    )

    for tool in "${required_tools[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            missing_deps+=("$tool")
        fi
    done

    if [ ${#missing_deps[@]} -ne 0 ]; then
        log_error "Missing required dependencies: ${missing_deps[*]}"
        log_info "Install them with: sudo apt-get install ${missing_deps[*]}"
        return 1
    fi

    log_success "All dependencies satisfied"
    return 0
}

check_disk_space() {
    log_info "Checking available disk space..."

    local available_mb=$(df -BM . | awk 'NR==2 {print $4}' | sed 's/M//')
    local required_mb=5000  # 5GB recommended for build

    if [ "$available_mb" -lt "$required_mb" ]; then
        log_error "Insufficient disk space. Available: ${available_mb}MB, Required: ${required_mb}MB"
        return 1
    fi

    log_success "Disk space check passed (${available_mb}MB available)"
    return 0
}

download_buildroot() {
    log_info "Setting up Buildroot ${BUILDROOT_VERSION}..."

    if [ -d "$BUILD_DIR" ]; then
        log_warning "Build directory already exists at $BUILD_DIR"
        read -p "Remove and re-download? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm -rf "$BUILD_DIR"
        else
            log_info "Using existing Buildroot installation"
            return 0
        fi
    fi

    local buildroot_tar="buildroot-${BUILDROOT_VERSION}.tar.gz"

    if [ ! -f "$buildroot_tar" ]; then
        log_info "Downloading Buildroot ${BUILDROOT_VERSION}..."
        wget -q --show-progress "$BUILDROOT_URL" || {
            log_error "Failed to download Buildroot"
            return 1
        }
    fi

    log_info "Extracting Buildroot..."
    tar -xzf "$buildroot_tar"
    mv "buildroot-${BUILDROOT_VERSION}" "$BUILD_DIR"

    log_success "Buildroot setup complete"
    return 0
}

generate_chase_config() {
    log_info "Generating Chase Edition configuration..."

    local config_file="${BUILD_DIR}/.config"

    cat > "$config_file" << 'EOF'
#
# mythOS Chase Edition - Buildroot Configuration
# Minimal system for WebDT 366 hardware
#

# Target Architecture
BR2_i386=y
BR2_x86_i586=y

# Toolchain
BR2_TOOLCHAIN_BUILDROOT_GLIBC=y
BR2_KERNEL_HEADERS_5_15=y
BR2_TOOLCHAIN_BUILDROOT_CXX=y

# Kernel
BR2_LINUX_KERNEL=y
BR2_LINUX_KERNEL_CUSTOM_VERSION=y
BR2_LINUX_KERNEL_CUSTOM_VERSION_VALUE="5.15.150"
BR2_LINUX_KERNEL_USE_CUSTOM_CONFIG=y
BR2_LINUX_KERNEL_CUSTOM_CONFIG_FILE="$(TOPDIR)/../configs/chase_kernel.config"

# Filesystem
BR2_TARGET_ROOTFS_EXT2=y
BR2_TARGET_ROOTFS_EXT2_4=y
BR2_TARGET_ROOTFS_EXT2_SIZE="45M"

# Init system
BR2_INIT_BUSYBOX=y

# BusyBox configuration
BR2_PACKAGE_BUSYBOX_CONFIG="$(TOPDIR)/../configs/chase_busybox.config"

# Core packages
BR2_PACKAGE_BUSYBOX=y
BR2_PACKAGE_DROPBEAR=y

# X.org
BR2_PACKAGE_XORG7=y
BR2_PACKAGE_XSERVER_XORG_SERVER=y
BR2_PACKAGE_XDRIVER_XF86_VIDEO_VESA=y
BR2_PACKAGE_XDRIVER_XF86_INPUT_KEYBOARD=y
BR2_PACKAGE_XDRIVER_XF86_INPUT_MOUSE=y

# Window manager - lightweight
BR2_PACKAGE_JWMCONF=y

# Web browser - lightweight
BR2_PACKAGE_DILLO=y
BR2_PACKAGE_LINKS=y

# File manager
BR2_PACKAGE_PCM ANFM=y

# Compression tools
BR2_PACKAGE_BZIP2=y
BR2_PACKAGE_GZIP=y
BR2_PACKAGE_XZ=y

# Networking
BR2_PACKAGE_DHCPCD=y
BR2_PACKAGE_WIRELESS_TOOLS=y
BR2_PACKAGE_WPA_SUPPLICANT=y

# Chase mascot and theme
BR2_ROOTFS_OVERLAY="$(TOPDIR)/../overlay/chase"

# ISO generation
BR2_TARGET_ROOTFS_ISO9660=y
BR2_TARGET_ROOTFS_ISO9660_BOOT_MENU="$(TOPDIR)/../configs/isolinux.cfg"

# Bootloader
BR2_TARGET_SYSLINUX=y
BR2_TARGET_SYSLINUX_ISOLINUX=y

EOF

    log_success "Configuration generated"
    return 0
}

create_overlay() {
    log_info "Creating Chase Edition overlay filesystem..."

    local overlay_dir="${CONFIG_DIR}/../overlay/chase"
    mkdir -p "$overlay_dir"

    # Create directory structure
    mkdir -p "$overlay_dir"/{etc,home,usr/share,boot}
    mkdir -p "$overlay_dir/usr/share/"{pixmaps,applications,mythos}
    mkdir -p "$overlay_dir/home/mythos"

    # Create Chase welcome message
    cat > "$overlay_dir/etc/motd" << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║   Welcome to mythOS - Chase Edition                         ║
║   "Breathing New Life Into Old Hardware"                    ║
║                                                              ║
║   Chase says: "Let's see how fast we can make this run!"    ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝

Quick Start:
  • startx          - Launch graphical environment
  • dillo           - Open web browser
  • links <url>     - Text-based web browser
  • pcmanfm         - File manager

For help, visit: https://github.com/Nightmare17726/mythOS

EOF

    # Create minimal .xinitrc
    cat > "$overlay_dir/home/mythos/.xinitrc" << 'EOF'
#!/bin/sh
# Chase Edition - Minimal X startup

# Set background color (light blue for Chase theme)
xsetroot -solid "#87CEEB"

# Start window manager
jwm &

# Launch file manager
pcmanfm &

# Start terminal
xterm -geometry 80x24+50+50 &

EOF

    chmod +x "$overlay_dir/home/mythos/.xinitrc"

    # Create mythOS version info
    cat > "$overlay_dir/etc/mythos-release" << EOF
MYTHOS_VERSION="${MYTHOS_VERSION}"
MYTHOS_EDITION="${EDITION}"
MYTHOS_BUILD_DATE="$(date +%Y-%m-%d)"
MYTHOS_MASCOT="Chase"
MYTHOS_SIZE="${EDITION_SIZE}"
EOF

    log_success "Overlay filesystem created"
    return 0
}

build_system() {
    log_info "Starting Buildroot compilation..."
    log_warning "This may take 30-60 minutes depending on your system"

    cd "$BUILD_DIR"

    # Set number of parallel jobs (CPU cores + 1)
    local num_jobs=$(($(nproc) + 1))

    log_info "Building with ${num_jobs} parallel jobs..."

    if make -j"$num_jobs" 2>&1 | tee build.log; then
        log_success "Build completed successfully"
        return 0
    else
        log_error "Build failed - check ${BUILD_DIR}/build.log for details"
        return 1
    fi
}

create_iso() {
    log_info "Creating bootable ISO image..."

    local iso_source="${BUILD_DIR}/output/images/rootfs.iso9660"

    if [ ! -f "$iso_source" ]; then
        log_error "ISO file not found at $iso_source"
        return 1
    fi

    mkdir -p "$OUTPUT_DIR"
    cp "$iso_source" "${OUTPUT_DIR}/${ISO_NAME}"

    local iso_size=$(du -h "${OUTPUT_DIR}/${ISO_NAME}" | cut -f1)

    log_success "ISO created: ${OUTPUT_DIR}/${ISO_NAME} (${iso_size})"

    # Create checksums
    log_info "Generating checksums..."
    cd "$OUTPUT_DIR"
    sha256sum "$ISO_NAME" > "${ISO_NAME}.sha256"
    md5sum "$ISO_NAME" > "${ISO_NAME}.md5"

    log_success "Checksums generated"
    return 0
}

create_release_notes() {
    log_info "Generating release notes..."

    cat > "${OUTPUT_DIR}/RELEASE_NOTES.txt" << EOF
mythOS ${MYTHOS_VERSION} - Chase Edition
Build Date: $(date +"%Y-%m-%d %H:%M:%S")

═══════════════════════════════════════════════════════════════

EDITION: Chase (Base)
SIZE: ${EDITION_SIZE}
TARGET HARDWARE: WebDT 366 (64-128MB RAM, 128-256MB storage)
KERNEL: Linux ${KERNEL_VERSION} LTS

FEATURES:
• Minimal system footprint (~50MB)
• Lightweight X Window System
• JWM window manager
• Dillo web browser
• PCManFM file manager
• BusyBox utilities
• Network connectivity (WiFi + Ethernet)
• Chase mascot theme

INSTALLATION:
1. Burn ISO to CD/DVD or create bootable USB
2. Boot from media
3. Follow on-screen installation prompts
4. Default credentials:
   Username: mythos
   Password: (none - set during install)

SYSTEM REQUIREMENTS:
• Minimum: 64MB RAM, 128MB storage
• Recommended: 128MB RAM, 256MB storage
• CPU: i586 or better
• Display: 800x600 or higher

INCLUDED SOFTWARE:
• BusyBox (core utilities)
• Dillo (web browser)
• Links (text browser)
• PCManFM (file manager)
• JWM (window manager)
• Dropbear (SSH server)
• Basic network tools

DOCUMENTATION:
• Full documentation: https://github.com/Nightmare17726/mythOS
• Build guide: Documentation/BUILD_ENVIRONMENT_SETUP.md
• Project proposal: Documentation/mythOS_Project_Proposal.docx

SUPPORT:
• Issues: https://github.com/Nightmare17726/mythOS/issues
• Discussions: https://github.com/Nightmare17726/mythOS/discussions

═══════════════════════════════════════════════════════════════

Chase says: "Let's see how fast we can make your system run!"

Happy computing!
- The mythOS Team

EOF

    log_success "Release notes created"
    return 0
}

print_summary() {
    echo ""
    echo "════════════════════════════════════════════════════════════════"
    echo -e "  ${GREEN}Build Complete!${NC}"
    echo "════════════════════════════════════════════════════════════════"
    echo ""
    echo "  ISO Location: ${OUTPUT_DIR}/${ISO_NAME}"
    echo "  ISO Size: $(du -h "${OUTPUT_DIR}/${ISO_NAME}" | cut -f1)"
    echo ""
    echo "  Checksums:"
    echo "    SHA256: ${OUTPUT_DIR}/${ISO_NAME}.sha256"
    echo "    MD5:    ${OUTPUT_DIR}/${ISO_NAME}.md5"
    echo ""
    echo "  Release Notes: ${OUTPUT_DIR}/RELEASE_NOTES.txt"
    echo ""
    echo "════════════════════════════════════════════════════════════════"
    echo ""
    echo "Next steps:"
    echo "  1. Test the ISO in a VM or on target hardware"
    echo "  2. Review release notes"
    echo "  3. Create GitHub release"
    echo ""
    echo "Chase says: \"Who needs bloat when you've got speed?\""
    echo ""
}

################################################################################
# Main Execution
################################################################################

main() {
    print_banner

    # Pre-flight checks
    check_dependencies || exit 1
    check_disk_space || exit 1

    # Build process
    download_buildroot || exit 1
    generate_chase_config || exit 1
    create_overlay || exit 1
    build_system || exit 1
    create_iso || exit 1
    create_release_notes || exit 1

    # Summary
    print_summary

    log_success "mythOS Chase Edition build complete!"
    exit 0
}

# Handle Ctrl+C gracefully
trap 'log_error "Build interrupted by user"; exit 130' INT

# Run main function
main "$@"
