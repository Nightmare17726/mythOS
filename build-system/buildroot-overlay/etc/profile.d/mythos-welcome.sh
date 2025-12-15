#!/bin/sh
# mythOS Auto-Welcome Script
# Runs appropriate welcome screen on first login

# Only run in interactive shells
if [ -z "$PS1" ]; then
    return
fi

# Only run once per session
if [ -n "$MYTHOS_WELCOME_SHOWN" ]; then
    return
fi

export MYTHOS_WELCOME_SHOWN=1

# Detect edition and run appropriate welcome
if [ -f /etc/mythos-release ]; then
    . /etc/mythos-release

    case "$MYTHOS_EDITION" in
        Chase)
            # Terminal-based welcome
            if [ -x /usr/local/bin/chase-welcome ]; then
                /usr/local/bin/chase-welcome
            fi
            ;;
        Hydra)
            if [ -n "$DISPLAY" ] && [ -x /usr/local/bin/hydra-welcome ]; then
                /usr/local/bin/hydra-welcome &
            fi
            ;;
        Dragon)
            if [ -n "$DISPLAY" ] && [ -x /usr/local/bin/dragon-welcome ]; then
                /usr/local/bin/dragon-welcome &
            fi
            ;;
        Pegasus)
            if [ -n "$DISPLAY" ] && [ -x /usr/local/bin/pegasus-welcome ]; then
                /usr/local/bin/pegasus-welcome &
            fi
            ;;
        Nekomata)
            if [ -n "$DISPLAY" ] && [ -x /usr/local/bin/nekomata-welcome ]; then
                /usr/local/bin/nekomata-welcome &
            fi
            ;;
    esac
fi
