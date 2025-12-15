#!/usr/bin/env python3
################################################################################
# mythOS GUI Theme Selector
# Visual edition selector with mascot cards
# Storage-aware compatibility checking
################################################################################

import gi
gi.require_version('Gtk', '3.0')
from gi.repository import Gtk, GdkPixbuf, Pango
import subprocess
import os

class ThemeSelectorWindow(Gtk.Window):
    def __init__(self):
        Gtk.Window.__init__(self, title="mythOS Edition Selector")
        self.set_border_width(20)
        self.set_default_size(900, 700)
        self.set_position(Gtk.WindowPosition.CENTER)

        # Main container
        vbox = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=15)
        self.add(vbox)

        # Header
        header_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=5)

        title = Gtk.Label()
        title.set_markup('<span size="xx-large" weight="bold">Choose Your mythOS Edition</span>')
        header_box.pack_start(title, False, False, 5)

        subtitle = Gtk.Label()
        subtitle.set_markup('<span size="large">Select the perfect system for your needs</span>')
        header_box.pack_start(subtitle, False, False, 5)

        vbox.pack_start(header_box, False, False, 10)

        # Storage info bar
        storage_bar = self.create_storage_bar()
        vbox.pack_start(storage_bar, False, False, 5)

        # Separator
        separator = Gtk.Separator(orientation=Gtk.Orientation.HORIZONTAL)
        vbox.pack_start(separator, False, False, 5)

        # Scrolled window for theme grid
        scrolled = Gtk.ScrolledWindow()
        scrolled.set_policy(Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC)
        scrolled.set_min_content_height(400)

        # Theme grid
        grid = Gtk.Grid()
        grid.set_row_spacing(20)
        grid.set_column_spacing(20)
        grid.set_halign(Gtk.Align.CENTER)

        scrolled.add(grid)
        vbox.pack_start(scrolled, True, True, 5)

        # Define themes
        self.themes = {
            'chase': {
                'name': 'Chase',
                'tagline': 'Base Edition',
                'size': 50,
                'icon': '/usr/share/mythOS/mascots/chase-icon-128.png',
                'description': 'Minimal system - fast & efficient',
                'quote': '"Let\'s see how fast we can make this run!"'
            },
            'pegasus': {
                'name': 'Pegasus',
                'tagline': 'Simplified Edition',
                'size': 85,
                'icon': '/usr/share/mythOS/mascots/pegasus-icon-128.png',
                'description': 'Elderly-friendly - patient guidance',
                'quote': '"Take all the time you need."'
            },
            'nekomata': {
                'name': 'Nekomata',
                'tagline': 'Professional Edition',
                'size': 120,
                'icon': '/usr/share/mythOS/mascots/nekomata-icon-128.png',
                'description': 'Productivity suite - office tools',
                'quote': '"Efficiency is elegance."'
            },
            'hydra': {
                'name': 'Hydra',
                'tagline': 'Education Edition',
                'size': 150,
                'icon': '/usr/share/mythOS/mascots/hydra-icon-128.png',
                'description': 'Multi-disciplinary tools - AI assistants',
                'quote': '"Every head is better than one!"'
            },
            'dragon': {
                'name': 'Dragon',
                'tagline': 'Gaming Edition',
                'size': 250,
                'icon': '/usr/share/mythOS/mascots/dragon-icon-128.png',
                'description': 'Retro gaming - emulators & WINE',
                'quote': '"Time to raid the retro gaming vault!"'
            }
        }

        # Get available storage
        self.available_storage = self.get_available_storage()

        # Create theme cards in 2-column grid
        row = 0
        col = 0
        for theme_id in ['chase', 'pegasus', 'nekomata', 'hydra', 'dragon']:
            theme_data = self.themes[theme_id]
            card = self.create_theme_card(theme_id, theme_data)
            grid.attach(card, col, row, 1, 1)

            col += 1
            if col > 1:  # 2 columns
                col = 0
                row += 1

        # Close button
        close_btn = Gtk.Button(label="Close")
        close_btn.connect("clicked", lambda w: Gtk.main_quit())
        vbox.pack_start(close_btn, False, False, 10)

    def create_storage_bar(self):
        """Create storage information bar"""
        box = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=10)
        box.set_halign(Gtk.Align.CENTER)

        label = Gtk.Label()
        label.set_markup(f'<span size="large">Available Storage: <b>{self.get_available_storage()}MB</b></span>')
        box.pack_start(label, False, False, 0)

        return box

    def create_theme_card(self, theme_id, theme_data):
        """Create a visual card for each theme"""
        # Determine compatibility
        is_compatible = self.available_storage >= theme_data['size']
        is_current = self.is_current_edition(theme_data['name'])

        # Card frame
        frame = Gtk.Frame()
        if is_current:
            frame.set_label(" Current Edition ")
        frame.set_shadow_type(Gtk.ShadowType.ETCHED_IN)

        # Card content box
        card_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=10)
        card_box.set_border_width(15)
        card_box.set_size_request(380, 300)

        # Mascot icon
        if os.path.exists(theme_data['icon']):
            try:
                pixbuf = GdkPixbuf.Pixbuf.new_from_file_at_scale(
                    theme_data['icon'], 128, 128, True
                )
                icon = Gtk.Image.new_from_pixbuf(pixbuf)
                card_box.pack_start(icon, False, False, 5)
            except:
                # Placeholder emoji
                icon_label = Gtk.Label()
                icon_label.set_markup('<span size="70000">🎭</span>')
                card_box.pack_start(icon_label, False, False, 5)
        else:
            # Placeholder emoji
            icon_label = Gtk.Label()
            icon_label.set_markup('<span size="70000">🎭</span>')
            card_box.pack_start(icon_label, False, False, 5)

        # Theme name
        name_label = Gtk.Label()
        name_label.set_markup(f'<span size="x-large" weight="bold">{theme_data["name"]}</span>')
        card_box.pack_start(name_label, False, False, 0)

        # Tagline
        tagline_label = Gtk.Label()
        tagline_label.set_markup(f'<span style="italic">{theme_data["tagline"]}</span>')
        card_box.pack_start(tagline_label, False, False, 0)

        # Description
        desc_label = Gtk.Label()
        desc_label.set_text(theme_data['description'])
        desc_label.set_line_wrap(True)
        desc_label.set_max_width_chars(35)
        desc_label.set_justify(Gtk.Justification.CENTER)
        card_box.pack_start(desc_label, True, True, 5)

        # Quote
        quote_label = Gtk.Label()
        quote_label.set_markup(f'<span size="small" style="italic">{theme_data["quote"]}</span>')
        quote_label.set_line_wrap(True)
        quote_label.set_max_width_chars(35)
        card_box.pack_start(quote_label, False, False, 5)

        # Status and button
        if is_current:
            status_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=5)

            status_label = Gtk.Label()
            status_label.set_markup('<span color="#28a745">✓ Currently Installed</span>')
            status_box.pack_start(status_label, False, False, 0)

            size_label = Gtk.Label()
            size_label.set_markup(f'<span size="small">{theme_data["size"]}MB</span>')
            status_box.pack_start(size_label, False, False, 0)

            card_box.pack_start(status_box, False, False, 5)

        elif is_compatible:
            status_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=5)

            # Tight fit warning
            remaining = self.available_storage - theme_data['size']
            if remaining < 20:
                status_label = Gtk.Label()
                status_label.set_markup(f'<span color="#ffc107">⚠ Tight Fit ({remaining}MB remains)</span>')
                status_box.pack_start(status_label, False, False, 0)
            else:
                status_label = Gtk.Label()
                status_label.set_markup(f'<span color="#28a745">✓ Compatible ({theme_data["size"]}MB)</span>')
                status_box.pack_start(status_label, False, False, 0)

            # Install button
            install_btn = Gtk.Button(label=f"Install {theme_data['name']}")
            install_btn.connect("clicked", self.on_install, theme_id, theme_data['name'])
            status_box.pack_start(install_btn, False, False, 5)

            card_box.pack_start(status_box, False, False, 5)

        else:
            # Incompatible
            status_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=5)

            shortfall = theme_data['size'] - self.available_storage
            status_label = Gtk.Label()
            status_label.set_markup(f'<span color="#dc3545">✗ Need {shortfall}MB More</span>')
            status_box.pack_start(status_label, False, False, 0)

            size_label = Gtk.Label()
            size_label.set_markup(f'<span size="small">Requires {theme_data["size"]}MB</span>')
            status_box.pack_start(size_label, False, False, 0)

            card_box.pack_start(status_box, False, False, 5)

            # Gray out the card
            card_box.set_opacity(0.5)

        frame.add(card_box)
        return frame

    def get_available_storage(self):
        """Get available storage in MB"""
        try:
            result = subprocess.run(
                ['df', '-BM', '/system'],
                capture_output=True,
                text=True
            )
            if result.returncode == 0:
                lines = result.stdout.strip().split('\n')
                if len(lines) > 1:
                    parts = lines[1].split()
                    if len(parts) > 3:
                        return int(parts[3].replace('M', ''))
        except:
            pass

        # Fallback
        try:
            result = subprocess.run(
                ['df', '-BM', '/'],
                capture_output=True,
                text=True
            )
            if result.returncode == 0:
                lines = result.stdout.strip().split('\n')
                if len(lines) > 1:
                    parts = lines[1].split()
                    if len(parts) > 3:
                        return int(parts[3].replace('M', ''))
        except:
            pass

        return 180  # Default fallback

    def is_current_edition(self, edition_name):
        """Check if this is the currently installed edition"""
        try:
            if os.path.exists('/etc/mythos-release'):
                with open('/etc/mythos-release', 'r') as f:
                    content = f.read()
                    return edition_name.upper() in content.upper()
        except:
            pass
        return False

    def on_install(self, widget, theme_id, theme_name):
        """Handle installation request"""
        # Confirmation dialog
        dialog = Gtk.MessageDialog(
            transient_for=self,
            flags=0,
            message_type=Gtk.MessageType.QUESTION,
            buttons=Gtk.ButtonsType.YES_NO,
            text=f"Install {theme_name} Edition?"
        )
        dialog.format_secondary_text(
            "This will download and install the selected edition.\n\n"
            "• System files will be replaced\n"
            "• Personal files in /home will be preserved\n"
            "• A backup will be created\n"
            "• System will reboot when complete\n\n"
            "Continue with installation?"
        )

        response = dialog.run()
        dialog.destroy()

        if response == Gtk.ResponseType.YES:
            # Launch theme installer in terminal
            try:
                subprocess.Popen([
                    'x-terminal-emulator',
                    '-e',
                    f'sudo theme-installer install {theme_name}'
                ])
                Gtk.main_quit()
            except:
                # Fallback to direct execution
                try:
                    subprocess.Popen([
                        'sudo',
                        'theme-installer',
                        'install',
                        theme_name
                    ])
                    Gtk.main_quit()
                except Exception as e:
                    error_dialog = Gtk.MessageDialog(
                        transient_for=self,
                        flags=0,
                        message_type=Gtk.MessageType.ERROR,
                        buttons=Gtk.ButtonsType.OK,
                        text="Installation Error"
                    )
                    error_dialog.format_secondary_text(
                        f"Could not launch theme installer:\n{str(e)}"
                    )
                    error_dialog.run()
                    error_dialog.destroy()


def main():
    win = ThemeSelectorWindow()
    win.connect("destroy", Gtk.main_quit)
    win.show_all()
    Gtk.main()


if __name__ == "__main__":
    main()
