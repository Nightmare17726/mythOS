#!/bin/bash
# Test mythOS Chase Edition in QEMU

ISO_PATH="../output/mythOS-chase-v1.0.0.iso"

if [ ! -f "$ISO_PATH" ]; then
    echo "Error: ISO not found at $ISO_PATH"
    echo "Build it first with: ../scripts/build-mythos-chase.sh"
    exit 1
fi

echo "Testing mythOS Chase Edition in QEMU..."
echo "ISO: $ISO_PATH"
echo ""
echo "Press Ctrl+Alt+G to release mouse"
echo "Press Ctrl+Alt+F to toggle fullscreen"
echo ""

qemu-system-i386 \
    -m 256M \
    -cdrom "$ISO_PATH" \
    -boot d \
    -vga std \
    -net nic,model=e1000 \
    -net user \
    -name "mythOS Chase Edition" \
    -enable-kvm 2>/dev/null || \
qemu-system-i386 \
    -m 256M \
    -cdrom "$ISO_PATH" \
    -boot d \
    -vga std \
    -net nic,model=e1000 \
    -net user \
    -name "mythOS Chase Edition"
