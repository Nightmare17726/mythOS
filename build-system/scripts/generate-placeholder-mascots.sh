#!/bin/bash
# Generate placeholder mascot images for mythOS
# Creates simple SVG placeholders until real artwork is generated

set -e

MASCOTS_DIR="../buildroot-overlay/usr/share/mythOS/mascots"

# Colors for each edition
declare -A COLORS
COLORS[chase]="#00BFFF"      # Sky blue
COLORS[pegasus]="#87CEEB"    # Light sky blue
COLORS[nekomata]="#2F4F4F"   # Dark slate gray
COLORS[hydra]="#4B0082"      # Indigo
COLORS[dragon]="#FF4500"     # Orange red

# Names
declare -A NAMES
NAMES[chase]="Chase"
NAMES[pegasus]="Pegasus"
NAMES[nekomata]="Nekomata"
NAMES[hydra]="Hydra"
NAMES[dragon]="Dragon"

create_svg_placeholder() {
    local edition="$1"
    local size="$2"
    local type="$3"  # avatar, logo, or icon
    local color="${COLORS[$edition]}"
    local name="${NAMES[$edition]}"
    local output="$MASCOTS_DIR/$edition/images/${type}-${size}x${size}.svg"

    local font_size=$((size / 8))
    local name_y=$((size / 2 + font_size / 2))

    cat > "$output" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<svg width="$size" height="$size" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <linearGradient id="grad_${edition}_${size}" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:$color;stop-opacity:1" />
      <stop offset="100%" style="stop-color:$color;stop-opacity:0.6" />
    </linearGradient>
  </defs>

  <!-- Background circle -->
  <circle cx="$((size/2))" cy="$((size/2))" r="$((size/2 - 10))"
          fill="url(#grad_${edition}_${size})" stroke="#FFFFFF" stroke-width="3"/>

  <!-- Mascot initial -->
  <text x="50%" y="40%" font-family="Arial, sans-serif"
        font-size="$((size/3))" font-weight="bold"
        fill="#FFFFFF" text-anchor="middle" dominant-baseline="middle">
    ${name:0:1}
  </text>

  <!-- Mascot name -->
  <text x="50%" y="70%" font-family="Arial, sans-serif"
        font-size="$font_size" font-weight="normal"
        fill="#FFFFFF" text-anchor="middle" dominant-baseline="middle">
    $name
  </text>
</svg>
EOF

    echo "Created: $output"
}

create_png_from_svg() {
    local svg_file="$1"
    local png_file="${svg_file%.svg}.png"

    if command -v convert &> /dev/null; then
        convert "$svg_file" "$png_file"
        echo "Converted to PNG: $png_file"
    elif command -v inkscape &> /dev/null; then
        inkscape "$svg_file" --export-filename="$png_file"
        echo "Converted to PNG: $png_file"
    else
        echo "Warning: ImageMagick or Inkscape not found, skipping PNG conversion"
        echo "Install with: sudo apt-get install imagemagick"
    fi
}

main() {
    echo "Generating placeholder mascot images..."
    echo ""

    for edition in chase pegasus nekomata hydra dragon; do
        echo "Creating placeholders for $edition..."

        # Create different sizes for different use cases
        # Avatar: 512x512 (large, for welcome screens)
        create_svg_placeholder "$edition" 512 "avatar"

        # Logo: 256x256 (medium, for theme selector)
        create_svg_placeholder "$edition" 256 "logo"

        # Icon: 128x128 (small, for menus/taskbar)
        create_svg_placeholder "$edition" 128 "icon"

        # Favicon: 64x64 (tiny, for browser/window)
        create_svg_placeholder "$edition" 64 "favicon"

        echo ""
    done

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Placeholder mascots created successfully!"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "These are temporary placeholders. To create proper mascots:"
    echo "  1. See: ../buildroot-overlay/usr/share/mythOS/mascots/MASCOT_GENERATION_GUIDE.md"
    echo "  2. Use AI tools (DALL-E, Midjourney, Stable Diffusion)"
    echo "  3. Replace the placeholder SVG files with real artwork"
    echo ""
    echo "Optional: Convert SVG to PNG (requires ImageMagick or Inkscape)"
    read -p "Convert to PNG now? (y/N): " convert

    if [[ $convert =~ ^[Yy]$ ]]; then
        echo ""
        for edition in chase pegasus nekomata hydra dragon; do
            for type in avatar logo icon favicon; do
                for size in 512 256 128 64; do
                    svg_file="$MASCOTS_DIR/$edition/images/${type}-${size}x${size}.svg"
                    [ -f "$svg_file" ] && create_png_from_svg "$svg_file"
                done
            done
        done
    fi

    echo ""
    echo "Done!"
}

main "$@"
