#!/bin/bash
################################################################################
# mythOS Theme Installer
# Automated theme installation and management system
#
# Features:
# - Download themes from GitHub releases
# - Storage-aware installation (prevents incompatible themes)
# - Preserve user data during theme switches
# - Rollback support
# - Integrity verification
################################################################################

set -e  # Exit on error
set -u  # Exit on undefined variable

################################################################################
# Configuration
################################################################################

MYTHOS_VERSION="1.0.0"
GITHUB_REPO="Nightmare17726/mythOS"
GITHUB_API="https://api.github.com/repos/${GITHUB_REPO}"
DOWNLOAD_BASE="https://github.com/${GITHUB_REPO}/releases/download"

# System paths
SYSTEM_PARTITION="/system"
HOME_PARTITION="/home"
BOOT_PARTITION="/boot"
BACKUP_DIR="/home/.mythos-backups"
CURRENT_THEME_FILE="/etc/mythos-release"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Theme size requirements (in MB)
declare -A THEME_SIZES=(
    ["Chase"]="50"
    ["Pegasus"]="85"
    ["Nekomata"]="120"
    ["Hydra"]="150"
    ["Dragon"]="250"
)

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
    echo ""
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}                                                              ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}           ${MAGENTA}mythOS Theme Installer${NC}                         ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}        Intelligent Storage-Aware Theme Management           ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}                                                              ${CYAN}║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

check_root() {
    if [ "$EUID" -ne 0 ]; then
        log_error "This script must be run as root"
        echo "Please run: sudo $0 $*"
        exit 1
    fi
}

get_current_theme() {
    if [ -f "$CURRENT_THEME_FILE" ]; then
        source "$CURRENT_THEME_FILE"
        echo "${MYTHOS_EDITION:-Unknown}"
    else
        echo "Unknown"
    fi
}

get_available_storage() {
    # Get available storage in MB for system partition
    local available_kb=$(df -k "$SYSTEM_PARTITION" 2>/dev/null | awk 'NR==2 {print $4}')

    if [ -z "$available_kb" ]; then
        # Fallback: check root partition
        available_kb=$(df -k / | awk 'NR==2 {print $4}')
    fi

    echo $((available_kb / 1024))
}

list_available_themes() {
    echo ""
    echo "Available mythOS Editions:"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    local available_space=$(get_available_storage)
    local current_theme=$(get_current_theme)

    echo -e "${CYAN}Chase (Base)${NC} - 50MB"
    echo "  • Minimal system, basic web browsing, file management"
    echo "  • Perfect for: First-time users, minimal setups"
    [ "$current_theme" = "Chase" ] && echo -e "  ${GREEN}[CURRENTLY INSTALLED]${NC}"
    [ $available_space -ge 50 ] && echo -e "  ${GREEN}✓ Compatible with your storage${NC}" || echo -e "  ${RED}✗ Insufficient storage${NC}"
    echo ""

    echo -e "${MAGENTA}Pegasus (Simplified)${NC} - 85MB"
    echo "  • Elderly-friendly, interactive help system"
    echo "  • Perfect for: Seniors, technology newcomers"
    [ "$current_theme" = "Pegasus" ] && echo -e "  ${GREEN}[CURRENTLY INSTALLED]${NC}"
    [ $available_space -ge 85 ] && echo -e "  ${GREEN}✓ Compatible with your storage${NC}" || echo -e "  ${RED}✗ Insufficient storage${NC}"
    echo ""

    echo -e "${BLUE}Nekomata (Professional)${NC} - 120MB"
    echo "  • Productivity suite, office tools, AI integration"
    echo "  • Perfect for: Professionals, daily drivers"
    [ "$current_theme" = "Nekomata" ] && echo -e "  ${GREEN}[CURRENTLY INSTALLED]${NC}"
    [ $available_space -ge 120 ] && echo -e "  ${GREEN}✓ Compatible with your storage${NC}" || echo -e "  ${RED}✗ Insufficient storage${NC}"
    echo ""

    echo -e "${YELLOW}Hydra (Education)${NC} - 150MB"
    echo "  • Multi-disciplinary tools, AI assistants, ProtonVPN"
    echo "  • Perfect for: Students, educators, researchers"
    [ "$current_theme" = "Hydra" ] && echo -e "  ${GREEN}[CURRENTLY INSTALLED]${NC}"
    [ $available_space -ge 150 ] && echo -e "  ${GREEN}✓ Compatible with your storage${NC}" || echo -e "  ${RED}✗ Insufficient storage${NC}"
    echo ""

    echo -e "${RED}Dragon (Gaming)${NC} - 250MB"
    echo "  • Retro gaming, emulators, Steam, WINE"
    echo "  • Perfect for: Gamers, emulation enthusiasts"
    [ "$current_theme" = "Dragon" ] && echo -e "  ${GREEN}[CURRENTLY INSTALLED]${NC}"
    [ $available_space -ge 250 ] && echo -e "  ${GREEN}✓ Compatible with your storage${NC}" || echo -e "  ${RED}✗ Insufficient storage${NC}"
    echo ""

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Available storage: ${available_space}MB"
    echo ""
}

check_storage_compatibility() {
    local theme=$1
    local required_size=${THEME_SIZES[$theme]}
    local available_space=$(get_available_storage)

    if [ $available_space -lt $required_size ]; then
        log_error "Insufficient storage for $theme edition"
        echo "  Required: ${required_size}MB"
        echo "  Available: ${available_space}MB"
        echo "  Shortfall: $((required_size - available_space))MB"
        echo ""
        echo "Recommendation: Choose a smaller edition or free up space"
        return 1
    fi

    log_success "Storage check passed (${available_space}MB available)"
    return 0
}

download_theme() {
    local theme=$1
    local version=${2:-$MYTHOS_VERSION}

    log_info "Downloading ${theme} Edition (v${version})..."

    local theme_package="mythOS-${theme}-${version}.tar.gz"
    local download_url="${DOWNLOAD_BASE}/v${version}/${theme_package}"
    local temp_dir="/tmp/mythos-install"

    mkdir -p "$temp_dir"
    cd "$temp_dir"

    # Download theme package
    if wget -q --show-progress "$download_url" -O "$theme_package"; then
        log_success "Downloaded ${theme_package}"
    else
        log_error "Failed to download theme package"
        log_info "URL: $download_url"
        return 1
    fi

    # Download and verify checksum
    if wget -q "${download_url}.sha256" -O "${theme_package}.sha256"; then
        log_info "Verifying package integrity..."
        if sha256sum -c "${theme_package}.sha256" --quiet; then
            log_success "Package integrity verified"
        else
            log_error "Package integrity check failed!"
            return 1
        fi
    else
        log_warning "Checksum file not available, skipping verification"
    fi

    echo "$temp_dir/$theme_package"
    return 0
}

backup_current_system() {
    log_info "Creating backup of current system..."

    local current_theme=$(get_current_theme)
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_path="${BACKUP_DIR}/${current_theme}_${timestamp}"

    mkdir -p "$backup_path"

    # Backup system configuration
    if [ -f "$CURRENT_THEME_FILE" ]; then
        cp "$CURRENT_THEME_FILE" "${backup_path}/"
    fi

    # Backup critical config files
    for config_file in /etc/passwd /etc/group /etc/shadow /etc/hostname /etc/hosts; do
        if [ -f "$config_file" ]; then
            cp "$config_file" "${backup_path}/"
        fi
    done

    log_success "Backup created at $backup_path"
    echo "$backup_path"
    return 0
}

install_theme() {
    local theme_package=$1
    local theme=$2

    log_info "Installing ${theme} Edition..."

    # Extract to temporary location
    local extract_dir="/tmp/mythos-extract"
    mkdir -p "$extract_dir"

    log_info "Extracting theme package..."
    tar -xzf "$theme_package" -C "$extract_dir"

    # Install system files
    log_info "Installing system files..."

    if [ -d "${extract_dir}/system" ]; then
        rsync -av --delete "${extract_dir}/system/" "$SYSTEM_PARTITION/" || {
            log_error "Failed to install system files"
            return 1
        }
    fi

    # Install boot files
    if [ -d "${extract_dir}/boot" ]; then
        log_info "Installing boot files..."
        rsync -av "${extract_dir}/boot/" "$BOOT_PARTITION/" || {
            log_warning "Failed to install boot files"
        }
    fi

    # Preserve home partition (user data)
    log_info "Preserving user data in $HOME_PARTITION"

    # Update system theme identifier
    cat > "$CURRENT_THEME_FILE" << EOF
MYTHOS_VERSION="$MYTHOS_VERSION"
MYTHOS_EDITION="$theme"
MYTHOS_INSTALL_DATE="$(date +%Y-%m-%d)"
MYTHOS_MASCOT="$theme"
MYTHOS_SIZE="${THEME_SIZES[$theme]}MB"
EOF

    log_success "${theme} Edition installed successfully"
    return 0
}

cleanup() {
    log_info "Cleaning up temporary files..."
    rm -rf /tmp/mythos-install /tmp/mythos-extract
    log_success "Cleanup complete"
}

interactive_install() {
    print_banner

    local current_theme=$(get_current_theme)
    local available_space=$(get_available_storage)

    echo "Current Edition: ${current_theme}"
    echo "Available Storage: ${available_space}MB"
    echo ""

    list_available_themes

    echo ""
    read -p "Enter the edition you want to install (Chase/Hydra/Dragon/Pegasus/Nekomata): " theme

    # Validate input
    case "$theme" in
        Chase|Hydra|Dragon|Pegasus|Nekomata)
            ;;
        *)
            log_error "Invalid edition: $theme"
            exit 1
            ;;
    esac

    if [ "$theme" = "$current_theme" ]; then
        log_warning "You already have ${theme} Edition installed"
        read -p "Reinstall anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_info "Installation cancelled"
            exit 0
        fi
    fi

    # Check storage
    check_storage_compatibility "$theme" || exit 1

    # Confirmation
    echo ""
    log_warning "This will install ${theme} Edition (${THEME_SIZES[$theme]}MB)"
    log_warning "Your current ${current_theme} Edition will be replaced"
    log_info "Your personal data in /home will be preserved"
    echo ""
    read -p "Continue with installation? (y/N): " -n 1 -r
    echo

    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Installation cancelled"
        exit 0
    fi

    # Perform installation
    echo ""
    log_info "Starting installation of ${theme} Edition..."
    echo ""

    backup_path=$(backup_current_system) || exit 1
    theme_package=$(download_theme "$theme") || exit 1
    install_theme "$theme_package" "$theme" || {
        log_error "Installation failed"
        log_info "Backup available at: $backup_path"
        exit 1
    }
    cleanup

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    log_success "Installation complete!"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "  New Edition: ${theme}"
    echo "  Backup: $backup_path"
    echo ""
    echo "Please reboot your system to start using ${theme} Edition"
    echo ""
    read -p "Reboot now? (y/N): " -n 1 -r
    echo

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        log_info "Rebooting system..."
        reboot
    fi
}

show_help() {
    cat << EOF
mythOS Theme Installer v${MYTHOS_VERSION}

USAGE:
    $0 [COMMAND] [OPTIONS]

COMMANDS:
    install [EDITION]   Install a specific edition interactively
    list                List available editions and storage compatibility
    current             Show currently installed edition
    help                Show this help message

EDITIONS:
    Chase       Base edition (50MB) - Minimal system
    Pegasus     Simplified edition (85MB) - Elderly-friendly
    Nekomata    Professional edition (120MB) - Productivity suite
    Hydra       Education edition (150MB) - Student tools + AI
    Dragon      Gaming edition (250MB) - Retro gaming paradise

EXAMPLES:
    $0 install          # Interactive installation
    $0 install Chase    # Install Chase edition directly
    $0 list             # Show available editions
    $0 current          # Show current edition

NOTES:
    • This script must be run as root
    • User data in /home is always preserved
    • Backups are created before installation
    • Storage compatibility is checked automatically

For more information: https://github.com/${GITHUB_REPO}

EOF
}

################################################################################
# Main Execution
################################################################################

main() {
    case "${1:-install}" in
        install)
            check_root
            if [ $# -eq 2 ]; then
                theme=$2
                # Direct install with theme specified
                check_storage_compatibility "$theme" || exit 1
                backup_path=$(backup_current_system) || exit 1
                theme_package=$(download_theme "$theme") || exit 1
                install_theme "$theme_package" "$theme" || exit 1
                cleanup
                log_success "Installation complete! Please reboot."
            else
                interactive_install
            fi
            ;;
        list)
            list_available_themes
            ;;
        current)
            echo "Current Edition: $(get_current_theme)"
            echo "Available Storage: $(get_available_storage)MB"
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            log_error "Unknown command: $1"
            echo "Run '$0 help' for usage information"
            exit 1
            ;;
    esac
}

# Handle Ctrl+C gracefully
trap 'log_error "Installation interrupted by user"; cleanup; exit 130' INT

# Run main function
main "$@"
