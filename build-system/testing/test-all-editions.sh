#!/bin/bash
# Test all mythOS editions in QEMU

OUTPUT_DIR="../output"

editions=("chase" "pegasus" "nekomata" "hydra" "dragon")
edition_memory=("256M" "384M" "512M" "768M" "1G")

echo "mythOS Edition Tester"
echo "====================="
echo ""

for i in "${!editions[@]}"; do
    edition="${editions[$i]}"
    memory="${edition_memory[$i]}"
    iso="$OUTPUT_DIR/mythOS-${edition}-v1.0.0.iso"

    echo "$((i+1)). ${edition^} Edition ($memory RAM)"
    if [ -f "$iso" ]; then
        echo "   ✓ ISO found: $iso"
    else
        echo "   ✗ ISO not found"
    fi
done

echo ""
read -p "Select edition to test [1-${#editions[@]}]: " choice

if [ "$choice" -ge 1 ] && [ "$choice" -le "${#editions[@]}" ]; then
    edition="${editions[$((choice-1))]}"
    memory="${edition_memory[$((choice-1))]}"
    iso="$OUTPUT_DIR/mythOS-${edition}-v1.0.0.iso"

    if [ ! -f "$iso" ]; then
        echo "Error: ISO not found. Build it first."
        exit 1
    fi

    echo ""
    echo "Starting mythOS ${edition^} Edition with $memory RAM..."
    echo "Press Ctrl+Alt+G to release mouse"
    echo "Press Ctrl+Alt+F to toggle fullscreen"
    echo ""

    qemu-system-i386 \
        -m "$memory" \
        -cdrom "$iso" \
        -boot d \
        -vga std \
        -net nic,model=e1000 \
        -net user \
        -name "mythOS ${edition^} Edition" \
        -enable-kvm 2>/dev/null || \
    qemu-system-i386 \
        -m "$memory" \
        -cdrom "$iso" \
        -boot d \
        -vga std \
        -net nic,model=e1000 \
        -net user \
        -name "mythOS ${edition^} Edition"
else
    echo "Invalid selection"
    exit 1
fi
