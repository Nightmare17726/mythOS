#!/bin/bash
################################################################################
# mythOS Chase Edition - Complete Build Script
# Automates the entire build process from scratch
################################################################################

set -e
set -u

WORKSPACE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="${WORKSPACE_DIR}/buildroot"
OVERLAY_DIR="${WORKSPACE_DIR}/buildroot-overlay"
ISO_DIR="${WORKSPACE_DIR}/mythOS-iso"
OUTPUT_DIR="${WORKSPACE_DIR}/output"

BUILDROOT_VERSION="2024.02"
BUILDROOT_URL="https://buildroot.org/downloads/buildroot-${BUILDROOT_VERSION}.tar.gz"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_banner() {
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║              mythOS Build System                             ║
║         Chase Edition - Complete ISO Build                   ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝

EOF
}

check_dependencies() {
    log_info "Checking build dependencies..."

    local missing=()
    local required="gcc g++ make patch perl python3 wget rsync cpio unzip bc"

    for cmd in $required; do
        if ! command -v $cmd &> /dev/null; then
            missing+=("$cmd")
        fi
    done

    if [ ${#missing[@]} -gt 0 ]; then
        log_error "Missing dependencies: ${missing[*]}"
        echo ""
        echo "Install with:"
        echo "  sudo apt-get install build-essential wget rsync cpio unzip bc"
        echo "  sudo apt-get install libncurses5-dev libssl-dev python3"
        return 1
    fi

    log_success "All dependencies satisfied"
    return 0
}

download_buildroot() {
    log_info "Downloading Buildroot ${BUILDROOT_VERSION}..."

    if [ -d "$BUILD_DIR" ]; then
        log_info "Buildroot directory exists. Skipping download."
        return 0
    fi

    cd "$WORKSPACE_DIR"

    if [ ! -f "buildroot-${BUILDROOT_VERSION}.tar.gz" ]; then
        wget "$BUILDROOT_URL" || {
            log_error "Failed to download Buildroot"
            return 1
        }
    fi

    log_info "Extracting Buildroot..."
    tar -xzf "buildroot-${BUILDROOT_VERSION}.tar.gz"
    mv "buildroot-${BUILDROOT_VERSION}" buildroot

    log_success "Buildroot ready"
    return 0
}

configure_buildroot() {
    log_info "Configuring Buildroot for mythOS Chase Edition..."

    cd "$BUILD_DIR"

    # Start with PC x86_64 default config
    make pc_x86_64_bios_defconfig

    # Apply mythOS-specific configuration
    ./scripts/config --set-str BR2_TARGET_GENERIC_HOSTNAME "mythos-chase"
    ./scripts/config --set-str BR2_TARGET_GENERIC_ISSUE "Welcome to mythOS Chase Edition"
    ./scripts/config --set-str BR2_ROOTFS_OVERLAY "$OVERLAY_DIR"

    # Toolchain
    ./scripts/config --enable BR2_TOOLCHAIN_BUILDROOT_MUSL
    ./scripts/config --enable BR2_OPTIMIZE_S

    # Core packages
    ./scripts/config --enable BR2_PACKAGE_BUSYBOX
    ./scripts/config --enable BR2_PACKAGE_NANO
    ./scripts/config --enable BR2_PACKAGE_HTOP
    ./scripts/config --enable BR2_PACKAGE_DIALOG

    # Network
    ./scripts/config --enable BR2_PACKAGE_DROPBEAR
    ./scripts/config --enable BR2_PACKAGE_WPA_SUPPLICANT
    ./scripts/config --enable BR2_PACKAGE_WIRELESS_TOOLS
    ./scripts/config --enable BR2_PACKAGE_DHCPCD

    # Web browser (Links for Chase)
    ./scripts/config --enable BR2_PACKAGE_LINKS

    # Python for GUI editions (minimal footprint)
    ./scripts/config --enable BR2_PACKAGE_PYTHON3
    ./scripts/config --enable BR2_PACKAGE_PYTHON3_PYEXPAT
    ./scripts/config --enable BR2_PACKAGE_PYTHON_PYGOBJECT

    # X11 and GTK (for themed editions)
    ./scripts/config --enable BR2_PACKAGE_XORG7
    ./scripts/config --enable BR2_PACKAGE_XSERVER_XORG_SERVER
    ./scripts/config --enable BR2_PACKAGE_OPENBOX
    ./scripts/config --enable BR2_PACKAGE_GTK3

    # Filesystem
    ./scripts/config --enable BR2_TARGET_ROOTFS_EXT2
    ./scripts/config --set-str BR2_TARGET_ROOTFS_EXT2_SIZE "75M"

    # Apply configuration
    make olddefconfig

    log_success "Buildroot configured"
    return 0
}

build_system() {
    log_info "Building mythOS Chase Edition..."
    log_info "This will take 30-120 minutes depending on your system."
    log_info "Build log: ${BUILD_DIR}/build.log"

    cd "$BUILD_DIR"

    local num_jobs=$(($(nproc) + 1))
    log_info "Using ${num_jobs} parallel jobs"

    make -j${num_jobs} 2>&1 | tee build.log

    if [ $? -eq 0 ]; then
        log_success "Build completed successfully"
        return 0
    else
        log_error "Build failed. Check ${BUILD_DIR}/build.log"
        return 1
    fi
}

create_iso() {
    log_info "Creating bootable ISO..."

    mkdir -p "$ISO_DIR"/{boot,isolinux}

    # Copy kernel and rootfs
    cp "$BUILD_DIR/output/images/bzImage" "$ISO_DIR/boot/"
    cp "$BUILD_DIR/output/images/rootfs.ext2" "$ISO_DIR/boot/"

    # Copy isolinux files
    if [ -d /usr/lib/ISOLINUX ]; then
        cp /usr/lib/ISOLINUX/isolinux.bin "$ISO_DIR/isolinux/"
    elif [ -d /usr/lib/syslinux ]; then
        cp /usr/lib/syslinux/isolinux.bin "$ISO_DIR/isolinux/"
    fi

    # Copy syslinux modules
    for module in ldlinux.c32 libcom32.c32 libutil.c32 menu.c32; do
        if [ -f "/usr/lib/syslinux/modules/bios/$module" ]; then
            cp "/usr/lib/syslinux/modules/bios/$module" "$ISO_DIR/isolinux/"
        fi
    done

    # Create isolinux.cfg
    cat > "$ISO_DIR/isolinux/isolinux.cfg" << 'EOF'
DEFAULT menu.c32
PROMPT 0
TIMEOUT 50

MENU TITLE mythOS Chase Edition v1.0.0

LABEL mythos
    MENU LABEL mythOS Chase Edition
    KERNEL /boot/bzImage
    APPEND initrd=/boot/rootfs.ext2 root=/dev/ram0 rw

LABEL local
    MENU LABEL Boot from local disk
    LOCALBOOT 0
EOF

    # Generate ISO
    log_info "Generating ISO image..."

    mkdir -p "$OUTPUT_DIR"

    genisoimage \
        -o "$OUTPUT_DIR/mythOS-chase-v1.0.0.iso" \
        -b isolinux/isolinux.bin \
        -c isolinux/boot.cat \
        -no-emul-boot \
        -boot-load-size 4 \
        -boot-info-table \
        -J -R -v \
        -V "mythOS_Chase_1.0" \
        "$ISO_DIR/"

    if [ $? -eq 0 ]; then
        # Make it hybrid (bootable from USB too)
        if command -v isohybrid &> /dev/null; then
            isohybrid "$OUTPUT_DIR/mythOS-chase-v1.0.0.iso"
        fi

        # Create checksums
        cd "$OUTPUT_DIR"
        sha256sum mythOS-chase-v1.0.0.iso > mythOS-chase-v1.0.0.iso.sha256
        md5sum mythOS-chase-v1.0.0.iso > mythOS-chase-v1.0.0.iso.md5

        log_success "ISO created: $OUTPUT_DIR/mythOS-chase-v1.0.0.iso"
        local size=$(du -h "$OUTPUT_DIR/mythOS-chase-v1.0.0.iso" | cut -f1)
        log_info "ISO size: $size"

        return 0
    else
        log_error "ISO creation failed"
        return 1
    fi
}

main() {
    print_banner

    log_info "Workspace: $WORKSPACE_DIR"
    log_info "Build dir: $BUILD_DIR"
    log_info "Overlay:   $OVERLAY_DIR"
    echo ""

    check_dependencies || exit 1
    download_buildroot || exit 1
    configure_buildroot || exit 1

    echo ""
    log_info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    log_info "  Ready to build!"
    log_info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    read -p "Start build now? This will take 30-120 minutes. (y/N): " confirm
    if [[ ! $confirm =~ ^[Yy]$ ]]; then
        log_info "Build cancelled. Run this script again to continue."
        exit 0
    fi

    build_system || exit 1
    create_iso || exit 1

    echo ""
    log_success "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    log_success "  mythOS Chase Edition built successfully!"
    log_success "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    log_info "ISO location: $OUTPUT_DIR/mythOS-chase-v1.0.0.iso"
    log_info "Test with: qemu-system-x86_64 -m 512M -cdrom $OUTPUT_DIR/mythOS-chase-v1.0.0.iso"
    echo ""
}

main "$@"
