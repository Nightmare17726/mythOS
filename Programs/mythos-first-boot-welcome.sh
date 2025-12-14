#!/bin/bash
################################################################################
# mythOS First Boot Welcome - Chase Edition
# Interactive welcome dialog with edition switching capability
#
# Features:
# - Welcome message from Chase mascot
# - Option to stay with Chase or switch editions
# - Storage-aware edition selection (greys out incompatible editions)
# - Fetches edition sizes from GitHub
# - Integrates with theme-installer.sh for edition switching
################################################################################

set -e

################################################################################
# Configuration
################################################################################

MYTHOS_VERSION="1.0.0"
GITHUB_REPO="Nightmare17726/mythOS"
GITHUB_API="https://api.github.com/repos/${GITHUB_REPO}/releases/latest"
FIRST_BOOT_FLAG="/home/mythos/.mythos-first-boot-complete"
THEME_INSTALLER="/usr/local/bin/theme-installer.sh"

# Edition sizes (in MB) - fallback if GitHub API fails
declare -A EDITION_SIZES=(
    ["Chase"]="50"
    ["Pegasus"]="85"
    ["Nekomata"]="120"
    ["Hydra"]="150"
    ["Dragon"]="250"
)

# Edition descriptions
declare -A EDITION_DESC=(
    ["Chase"]="Minimal system - Fast & efficient"
    ["Pegasus"]="Simplified interface - Elderly-friendly"
    ["Nekomata"]="Professional tools - Productivity suite"
    ["Hydra"]="Education edition - AI & study tools"
    ["Dragon"]="Gaming edition - Retro gaming paradise"
)

# Mascot quotes
declare -A MASCOT_QUOTES=(
    ["Chase"]="Let's see how fast we can make this run!"
    ["Pegasus"]="Take all the time you need - we'll go at your pace."
    ["Nekomata"]="Efficiency is elegance. Let's optimize your workflow!"
    ["Hydra"]="Every head is better than one! What shall we learn today?"
    ["Dragon"]="Time to raid the retro gaming vault!"
)

################################################################################
# Helper Functions
################################################################################

get_available_storage() {
    # Get available storage in MB
    local available_kb=$(df -k /system 2>/dev/null | awk 'NR==2 {print $4}')
    if [ -z "$available_kb" ]; then
        # Fallback to root partition
        available_kb=$(df -k / | awk 'NR==2 {print $4}')
    fi
    echo $((available_kb / 1024))
}

check_dialog_available() {
    # Check if dialog or whiptail is available
    if command -v dialog &> /dev/null; then
        echo "dialog"
    elif command -v whiptail &> /dev/null; then
        echo "whiptail"
    else
        echo "none"
    fi
}

fetch_github_sizes() {
    # Try to fetch actual edition sizes from GitHub releases
    # If fails, use fallback sizes from EDITION_SIZES array
    if command -v curl &> /dev/null; then
        local release_info=$(curl -s "$GITHUB_API" 2>/dev/null || echo "")
        if [ -n "$release_info" ]; then
            # Parse JSON for asset sizes (would need jq for proper parsing)
            # For now, stick with hardcoded sizes
            :
        fi
    fi
}

show_welcome_text() {
    clear
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║                     Welcome to mythOS!                       ║
║                      Chase Edition                           ║
║                                                              ║
║              🐆  Breathing New Life Into Old Hardware        ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝

EOF

    echo "Chase says: \"${MASCOT_QUOTES[Chase]}\""
    echo ""
    echo "You're currently running the Chase (Base) Edition - our smallest"
    echo "and fastest mythOS variant, perfect for minimal systems."
    echo ""
}

show_text_menu() {
    local available_storage=$1

    show_welcome_text

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Available Storage: ${available_storage}MB"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "Would you like to:"
    echo ""
    echo "  1) Continue with Chase Edition (recommended)"
    echo "  2) Switch to a different edition"
    echo "  3) Exit and explore mythOS"
    echo ""
    read -p "Enter your choice [1-3]: " choice

    case $choice in
        1)
            return 0  # Continue with Chase
            ;;
        2)
            show_edition_selector_text "$available_storage"
            ;;
        3)
            return 0  # Exit
            ;;
        *)
            echo "Invalid choice. Continuing with Chase Edition."
            sleep 2
            return 0
            ;;
    esac
}

show_edition_selector_text() {
    local available_storage=$1

    clear
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║              mythOS Edition Selector                         ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo ""
    echo "Available Storage: ${available_storage}MB"
    echo ""
    echo "Select an edition to install:"
    echo ""

    local edition_number=1
    declare -A number_to_edition

    # Display editions with compatibility status
    for edition in Chase Pegasus Nekomata Hydra Dragon; do
        local size=${EDITION_SIZES[$edition]}
        local desc="${EDITION_DESC[$edition]}"
        local quote="${MASCOT_QUOTES[$edition]}"

        # Check compatibility
        if [ $available_storage -ge $size ]; then
            # Compatible
            echo "  $edition_number) 🟢 $edition Edition - ${size}MB"
            echo "       $desc"
            echo "       \"$quote\""
            number_to_edition[$edition_number]=$edition
        else
            # Incompatible
            echo "  ⚫ $edition Edition - ${size}MB [INSUFFICIENT STORAGE]"
            echo "       $desc"
            echo "       Need $((size - available_storage))MB more"
        fi
        echo ""

        ((edition_number++))
    done

    echo "  0) Cancel and stay with Chase Edition"
    echo ""
    read -p "Enter your choice: " edition_choice

    if [ "$edition_choice" = "0" ]; then
        return 0
    fi

    if [ -n "${number_to_edition[$edition_choice]}" ]; then
        local selected_edition="${number_to_edition[$edition_choice]}"
        confirm_edition_switch "$selected_edition"
    else
        echo "Invalid choice. Staying with Chase Edition."
        sleep 2
        return 0
    fi
}

confirm_edition_switch() {
    local edition=$1
    local size=${EDITION_SIZES[$edition]}

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "You selected: $edition Edition (${size}MB)"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "This will:"
    echo "  • Download $edition Edition from GitHub"
    echo "  • Replace Chase Edition system files"
    echo "  • Preserve your personal files in /home"
    echo "  • Create a backup of current system"
    echo "  • Require a reboot when complete"
    echo ""
    read -p "Continue with installation? (y/N): " confirm

    if [[ $confirm =~ ^[Yy]$ ]]; then
        install_edition "$edition"
    else
        echo "Installation cancelled. Staying with Chase Edition."
        sleep 2
        return 0
    fi
}

install_edition() {
    local edition=$1

    echo ""
    echo "Starting installation of $edition Edition..."
    echo ""

    # Check if theme installer exists
    if [ ! -f "$THEME_INSTALLER" ]; then
        echo "ERROR: Theme installer not found at $THEME_INSTALLER"
        echo "You can manually install editions later using the theme installer."
        sleep 3
        return 1
    fi

    # Run theme installer with selected edition
    sudo "$THEME_INSTALLER" install "$edition"

    # If installation successful, set first boot complete
    if [ $? -eq 0 ]; then
        touch "$FIRST_BOOT_FLAG"
        echo ""
        echo "Installation complete! Your system will reboot shortly."
        sleep 3
        sudo reboot
    else
        echo ""
        echo "Installation failed. Staying with Chase Edition."
        sleep 3
        return 1
    fi
}

show_dialog_menu() {
    local available_storage=$1
    local dialog_cmd=$2

    # Build menu items with compatibility checking
    local menu_items=()

    # Add welcome message
    $dialog_cmd --title "Welcome to mythOS - Chase Edition" \
                --msgbox "🐆 Chase says: \"${MASCOT_QUOTES[Chase]}\"\n\nYou're running Chase Edition - our smallest and fastest variant.\n\nAvailable Storage: ${available_storage}MB" 12 60

    # Ask if user wants to switch
    if ! $dialog_cmd --title "Edition Selection" \
                     --yesno "Would you like to switch to a different mythOS edition?\n\nYour personal files will be preserved." 10 60; then
        return 0  # User chose to stay with Chase
    fi

    # Build edition menu
    local tag=1
    for edition in Chase Pegasus Nekomata Hydra Dragon; do
        local size=${EDITION_SIZES[$edition]}
        local desc="${EDITION_DESC[$edition]}"

        if [ $available_storage -ge $size ]; then
            menu_items+=("$tag" "$edition ($size MB) - $desc" "ON")
        else
            menu_items+=("$tag" "$edition ($size MB) - INSUFFICIENT STORAGE" "OFF")
        fi
        ((tag++))
    done

    # Show edition selector
    local choice=$($dialog_cmd --title "Select mythOS Edition" \
                               --menu "Available Storage: ${available_storage}MB\n\nChoose an edition:" 20 70 5 \
                               "${menu_items[@]}" 2>&1 >/dev/tty)

    if [ -n "$choice" ]; then
        local editions=(Chase Pegasus Nekomata Hydra Dragon)
        local selected_edition="${editions[$((choice-1))]}"

        if $dialog_cmd --title "Confirm Installation" \
                       --yesno "Install $selected_edition Edition?\n\nThis will replace Chase Edition but preserve your personal files." 10 60; then
            install_edition "$selected_edition"
        fi
    fi
}

################################################################################
# Main Function
################################################################################

main() {
    # Check if this is first boot
    if [ -f "$FIRST_BOOT_FLAG" ]; then
        # Already completed first boot setup
        exit 0
    fi

    # Get available storage
    local available_storage=$(get_available_storage)

    # Fetch latest sizes from GitHub (optional)
    fetch_github_sizes

    # Check which dialog tool is available
    local dialog_tool=$(check_dialog_available)

    # Show appropriate menu
    if [ "$dialog_tool" = "none" ]; then
        # Fallback to text-based menu
        show_text_menu "$available_storage"
    else
        # Use dialog or whiptail for better UI
        show_dialog_menu "$available_storage" "$dialog_tool"
    fi

    # Mark first boot as complete if staying with Chase
    touch "$FIRST_BOOT_FLAG"

    echo ""
    echo "Welcome to mythOS Chase Edition!"
    echo ""
    echo "Quick commands:"
    echo "  startx          - Launch graphical environment"
    echo "  dillo           - Open web browser"
    echo "  pcmanfm         - File manager"
    echo ""
    echo "For help, type: man mythos"
    echo ""
}

# Only run if executed directly (not sourced)
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    main "$@"
fi
