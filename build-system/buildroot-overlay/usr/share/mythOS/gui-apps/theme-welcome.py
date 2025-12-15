#!/usr/bin/env python3
################################################################################
# mythOS GUI Welcome Dialog
# For themed editions (Hydra, Dragon, Pegasus, Nekomata)
# Displays mascot image and welcome message
################################################################################

import gi
gi.require_version('Gtk', '3.0')
from gi.repository import Gtk, GdkPixbuf, Gdk
import sys
import os
import subprocess

class WelcomeWindow(Gtk.Window):
    def __init__(self, theme_name, mascot_path, welcome_text):
        Gtk.Window.__init__(self, title=f"Welcome to mythOS {theme_name} Edition")
        self.set_border_width(20)
        self.set_default_size(700, 600)
        self.set_position(Gtk.WindowPosition.CENTER)
        self.set_resizable(False)

        # Create main vertical box
        vbox = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=15)
        self.add(vbox)

        # mythOS ASCII logo as label
        logo_label = Gtk.Label()
        logo_markup = '''<span font="monospace 10">    __  ___     __  __    ____  _____
   /  |/  /_  _/ /_/ /_  / __ \/ ___/
  / /|_/ / / / / __/ __ \/ / / /\__ \\
 / /  / / /_/ / /_/ / / / /_/ /___/ /
/_/  /_/\__, /\__/_/ /_/\____//____/
       /____/</span>'''
        logo_label.set_markup(logo_markup)
        logo_label.set_justify(Gtk.Justification.CENTER)
        vbox.pack_start(logo_label, False, False, 10)

        # Edition title
        title_label = Gtk.Label()
        title_label.set_markup(f'<span size="xx-large" weight="bold">{theme_name} Edition</span>')
        vbox.pack_start(title_label, False, False, 5)

        # Mascot image
        if os.path.exists(mascot_path):
            try:
                pixbuf = GdkPixbuf.Pixbuf.new_from_file_at_scale(
                    mascot_path, 256, 256, True
                )
                mascot_image = Gtk.Image.new_from_pixbuf(pixbuf)
                vbox.pack_start(mascot_image, False, False, 15)
            except Exception as e:
                print(f"Could not load mascot image: {e}")
                # Show placeholder
                placeholder = Gtk.Label()
                placeholder.set_markup('<span size="xx-large">🎭</span>')
                vbox.pack_start(placeholder, False, False, 15)
        else:
            # Placeholder if image missing
            placeholder = Gtk.Label()
            placeholder.set_markup('<span size="xx-large">🎭</span>')
            vbox.pack_start(placeholder, False, False, 15)

        # Welcome message
        welcome_label = Gtk.Label()
        welcome_label.set_markup(f'<span size="large">{welcome_text}</span>')
        welcome_label.set_line_wrap(True)
        welcome_label.set_max_width_chars(60)
        welcome_label.set_justify(Gtk.Justification.CENTER)
        vbox.pack_start(welcome_label, True, True, 15)

        # Separator
        separator = Gtk.Separator(orientation=Gtk.Orientation.HORIZONTAL)
        vbox.pack_start(separator, False, False, 10)

        # Button box
        button_box = Gtk.Box(spacing=15)
        button_box.set_halign(Gtk.Align.CENTER)

        # Browse Themes button
        theme_btn = Gtk.Button(label="📚 Browse Other Editions")
        theme_btn.connect("clicked", self.on_theme_clicked)
        button_box.pack_start(theme_btn, False, False, 0)

        # System Info button
        info_btn = Gtk.Button(label="ℹ️  System Info")
        info_btn.connect("clicked", self.on_info_clicked)
        button_box.pack_start(info_btn, False, False, 0)

        # Close button
        close_btn = Gtk.Button(label="✓ Close")
        close_btn.connect("clicked", self.on_close_clicked)
        button_box.pack_start(close_btn, False, False, 0)

        vbox.pack_start(button_box, False, False, 15)

        # Set window icon if available
        try:
            icon_path = mascot_path.replace('avatar-256', 'icon-64')
            if os.path.exists(icon_path):
                self.set_icon_from_file(icon_path)
        except:
            pass

    def on_theme_clicked(self, widget):
        subprocess.Popen(["theme-selector-gui"],
                        stdout=subprocess.DEVNULL,
                        stderr=subprocess.DEVNULL)

    def on_info_clicked(self, widget):
        subprocess.Popen(["system-info-gui"],
                        stdout=subprocess.DEVNULL,
                        stderr=subprocess.DEVNULL)

    def on_close_clicked(self, widget):
        Gtk.main_quit()


def main():
    theme = sys.argv[1] if len(sys.argv) > 1 else "mythOS"
    mascot = sys.argv[2] if len(sys.argv) > 2 else ""
    message = sys.argv[3] if len(sys.argv) > 3 else "Welcome to mythOS!"

    win = WelcomeWindow(theme, mascot, message)
    win.connect("destroy", Gtk.main_quit)
    win.show_all()
    Gtk.main()


if __name__ == "__main__":
    main()
