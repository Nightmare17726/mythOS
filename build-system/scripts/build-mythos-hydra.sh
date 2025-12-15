#!/bin/bash
################################################################################
# mythOS Hydra Edition - Complete Build Script
# Educational/Multi-disciplinary edition (150MB target)
################################################################################

set -e
set -u

EDITION="hydra"
EDITION_NAME="Hydra"
VERSION="1.0.0"
ISO_SIZE="150MB"

WORKSPACE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="${WORKSPACE_DIR}/buildroot-${EDITION}"
CONFIG_DIR="${WORKSPACE_DIR}/configs"
OVERLAY_DIR="${WORKSPACE_DIR}/buildroot-overlay"
ISO_DIR="${WORKSPACE_DIR}/mythOS-iso-${EDITION}"
OUTPUT_DIR="${WORKSPACE_DIR}/output"

BUILDROOT_VERSION="2024.02"
BUILDROOT_URL="https://buildroot.org/downloads/buildroot-${BUILDROOT_VERSION}.tar.gz"

source "$(dirname "${BASH_SOURCE[0]}")/build-common.sh"

configure_buildroot() {
    log_info "Configuring Buildroot for mythOS ${EDITION_NAME} Edition..."

    cd "$BUILD_DIR"

    make pc_x86_defconfig
    ./scripts/kconfig/merge_config.sh .config "${CONFIG_DIR}/mythos-base.config"
    ./scripts/kconfig/merge_config.sh .config "${CONFIG_DIR}/mythos-${EDITION}.config"

    ./scripts/config --set-str BR2_TARGET_GENERIC_HOSTNAME "mythos-${EDITION}"
    ./scripts/config --set-str BR2_ROOTFS_OVERLAY "$OVERLAY_DIR"

    make olddefconfig

    log_success "Buildroot configured for ${EDITION_NAME} Edition"
    return 0
}

main "$@"
