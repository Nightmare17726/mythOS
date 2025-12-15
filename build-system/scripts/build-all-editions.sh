#!/bin/bash
################################################################################
# mythOS - Build All Editions Script
# Builds all 5 editions: Chase, Pegasus, Nekomata, Hydra, Dragon
################################################################################

set -e
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

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
║            Build All Editions                                ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝

EOF
}

build_edition() {
    local edition=$1
    local script="build-mythos-${edition}.sh"

    log_info "Building mythOS ${edition^} Edition..."

    if [ ! -f "$SCRIPT_DIR/$script" ]; then
        log_error "Build script not found: $script"
        return 1
    fi

    "$SCRIPT_DIR/$script" --non-interactive || {
        log_error "Failed to build ${edition^} Edition"
        return 1
    }

    log_success "${edition^} Edition built successfully"
    return 0
}

main() {
    print_banner

    local editions=("chase" "pegasus" "nekomata" "hydra" "dragon")
    local built=()
    local failed=()

    log_info "This will build all 5 mythOS editions:"
    for edition in "${editions[@]}"; do
        echo "  - ${edition^} Edition"
    done
    echo ""

    read -p "Continue? This will take several hours. (y/N): " confirm
    if [[ ! $confirm =~ ^[Yy]$ ]]; then
        log_info "Build cancelled."
        exit 0
    fi

    for edition in "${editions[@]}"; do
        echo ""
        log_info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        log_info "  Building ${edition^} Edition"
        log_info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""

        if build_edition "$edition"; then
            built+=("$edition")
        else
            failed+=("$edition")
        fi
    done

    echo ""
    log_info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    log_info "  Build Summary"
    log_info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    if [ ${#built[@]} -gt 0 ]; then
        log_success "Successfully built:"
        for edition in "${built[@]}"; do
            echo "  ✓ ${edition^} Edition"
        done
        echo ""
    fi

    if [ ${#failed[@]} -gt 0 ]; then
        log_error "Failed to build:"
        for edition in "${failed[@]}"; do
            echo "  ✗ ${edition^} Edition"
        done
        echo ""
        exit 1
    fi

    log_success "All editions built successfully!"
    log_info "ISOs available in: $WORKSPACE_DIR/output/"
}

main "$@"
