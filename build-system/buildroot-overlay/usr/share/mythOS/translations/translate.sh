#!/bin/bash
# mythOS Translation Framework
# Multi-language support for English, Spanish, French

LANG_DIR="/usr/share/mythOS/translations"
DEFAULT_LANG="en"
CURRENT_LANG="${MYTH_LANG:-$DEFAULT_LANG}"

# Load translation file
load_translations(){
    local lang="${1:-$CURRENT_LANG}"
    local file="$LANG_DIR/${lang}.lang"

    [ -f "$file" ]&&source "$file"||source "$LANG_DIR/en.lang"
}

# Translate function
t(){
    local key="$1"
    local var="TR_${key}"
    echo "${!var:-$key}"
}

# Export for use in other scripts
export -f t
export MYTH_LANG="$CURRENT_LANG"
load_translations
