#!/bin/bash
# Test mythOS in QEMU with WebDT 366-like settings
# Emulates old tablet hardware

EDITION="${1:-chase}"
ISO_PATH="../output/mythOS-${EDITION}-v1.0.0.iso"

if [ ! -f "$ISO_PATH" ]; then
    echo "Error: ISO not found at $ISO_PATH"
    echo "Usage: $0 [chase|pegasus|nekomata|hydra|dragon]"
    exit 1
fi

echo "Testing mythOS ${EDITION^} Edition in WebDT 366 mode..."
echo "ISO: $ISO_PATH"
echo ""
echo "Emulated hardware:"
echo "  CPU: Intel i586 (Pentium-class)"
echo "  RAM: 128MB"
echo "  Display: 800x600"
echo "  Network: Intel e100"
echo ""

qemu-system-i386 \
    -cpu pentium \
    -m 128M \
    -cdrom "$ISO_PATH" \
    -boot d \
    -vga cirrus \
    -display sdl \
    -net nic,model=e100 \
    -net user \
    -name "mythOS on WebDT 366" \
    -enable-kvm 2>/dev/null || \
qemu-system-i386 \
    -cpu pentium \
    -m 128M \
    -cdrom "$ISO_PATH" \
    -boot d \
    -vga cirrus \
    -display sdl \
    -net nic,model=e100 \
    -net user \
    -name "mythOS on WebDT 366"
