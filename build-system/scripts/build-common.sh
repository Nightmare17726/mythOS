#!/bin/bash
################################################################################
# mythOS Build Common Functions
# Shared functions used by all edition build scripts
################################################################################

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
    cat << EOF
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║              mythOS Build System                             ║
║         ${EDITION_NAME} Edition - Complete ISO Build                   ║
║         Target Size: ${ISO_SIZE}                                    ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝

EOF
}

check_dependencies() {
    log_info "Checking build dependencies..."

    local missing=()
    local required="gcc g++ make patch perl python3 wget rsync cpio unzip bc genisoimage"

    for cmd in $required; do
        if ! command -v $cmd &> /dev/null; then
            missing+=("$cmd")
        fi
    done

    if [ ${#missing[@]} -gt 0 ]; then
        log_error "Missing dependencies: ${missing[*]}"
        echo ""
        echo "Install with:"
        echo "  sudo apt-get update"
        echo "  sudo apt-get install build-essential wget rsync cpio unzip bc"
        echo "  sudo apt-get install libncurses5-dev libssl-dev python3"
        echo "  sudo apt-get install genisoimage syslinux isolinux"
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
    mv "buildroot-${BUILDROOT_VERSION}" "buildroot-${EDITION}"

    log_success "Buildroot ready"
    return 0
}

build_system() {
    log_info "Building mythOS ${EDITION_NAME} Edition..."
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
    cp "$BUILD_DIR/output/images/bzImage" "$ISO_DIR/boot/" || {
        cp "$BUILD_DIR/output/images/zImage" "$ISO_DIR/boot/bzImage" 2>/dev/null || true
    }
    cp "$BUILD_DIR/output/images/rootfs.ext2" "$ISO_DIR/boot/"

    # Copy isolinux files
    if [ -d /usr/lib/ISOLINUX ]; then
        cp /usr/lib/ISOLINUX/isolinux.bin "$ISO_DIR/isolinux/"
    elif [ -d /usr/lib/syslinux ]; then
        cp /usr/lib/syslinux/isolinux.bin "$ISO_DIR/isolinux/" 2>/dev/null || \
        cp /usr/lib/syslinux/bios/isolinux.bin "$ISO_DIR/isolinux/"
    fi

    # Copy syslinux modules
    for module in ldlinux.c32 libcom32.c32 libutil.c32 menu.c32; do
        if [ -f "/usr/lib/syslinux/modules/bios/$module" ]; then
            cp "/usr/lib/syslinux/modules/bios/$module" "$ISO_DIR/isolinux/"
        elif [ -f "/usr/lib/syslinux/bios/$module" ]; then
            cp "/usr/lib/syslinux/bios/$module" "$ISO_DIR/isolinux/"
        fi
    done

    # Create isolinux.cfg
    cat > "$ISO_DIR/isolinux/isolinux.cfg" << EOF
DEFAULT menu.c32
PROMPT 0
TIMEOUT 50

MENU TITLE mythOS ${EDITION_NAME} Edition v${VERSION}

LABEL mythos
    MENU LABEL mythOS ${EDITION_NAME} Edition
    KERNEL /boot/bzImage
    APPEND initrd=/boot/rootfs.ext2 root=/dev/ram0 rw quiet splash

LABEL local
    MENU LABEL Boot from local disk
    LOCALBOOT 0
EOF

    # Generate ISO
    log_info "Generating ISO image..."

    mkdir -p "$OUTPUT_DIR"

    genisoimage \
        -o "$OUTPUT_DIR/mythOS-${EDITION}-v${VERSION}.iso" \
        -b isolinux/isolinux.bin \
        -c isolinux/boot.cat \
        -no-emul-boot \
        -boot-load-size 4 \
        -boot-info-table \
        -J -R -v \
        -V "mythOS_${EDITION_NAME}_${VERSION}" \
        "$ISO_DIR/"

    if [ $? -eq 0 ]; then
        # Make it hybrid (bootable from USB too)
        if command -v isohybrid &> /dev/null; then
            isohybrid "$OUTPUT_DIR/mythOS-${EDITION}-v${VERSION}.iso" 2>/dev/null || true
        fi

        # Create checksums
        cd "$OUTPUT_DIR"
        sha256sum "mythOS-${EDITION}-v${VERSION}.iso" > "mythOS-${EDITION}-v${VERSION}.iso.sha256"
        md5sum "mythOS-${EDITION}-v${VERSION}.iso" > "mythOS-${EDITION}-v${VERSION}.iso.md5"

        log_success "ISO created: $OUTPUT_DIR/mythOS-${EDITION}-v${VERSION}.iso"
        local size=$(du -h "$OUTPUT_DIR/mythOS-${EDITION}-v${VERSION}.iso" | cut -f1)
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

    # Support non-interactive mode for build-all-editions.sh
    local non_interactive=false
    if [ "${1:-}" = "--non-interactive" ]; then
        non_interactive=true
    fi

    check_dependencies || exit 1
    download_buildroot || exit 1
    configure_buildroot || exit 1

    if [ "$non_interactive" = false ]; then
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
    fi

    build_system || exit 1
    create_iso || exit 1

    echo ""
    log_success "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    log_success "  mythOS ${EDITION_NAME} Edition built successfully!"
    log_success "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    log_info "ISO location: $OUTPUT_DIR/mythOS-${EDITION}-v${VERSION}.iso"
    log_info "Test with: qemu-system-i386 -m 256M -cdrom $OUTPUT_DIR/mythOS-${EDITION}-v${VERSION}.iso"
    echo ""
}
