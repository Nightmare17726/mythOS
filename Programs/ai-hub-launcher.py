#!/usr/bin/env python3
"""
mythOS AI Hub Launcher
A unified launcher for AI assistants and tools

Supported AI Tools:
- Claude (Anthropic)
- ChatGPT (OpenAI)
- Gemini (Google)
- Perplexity AI
- NotebookLM (Google)
- Local LLMs (Ollama)

Features:
- Browser-based launching
- Lightweight GUI
- Keyboard shortcuts
- Recent tools tracking
- Customizable favorites
"""

import os
import sys
import json
import subprocess
import webbrowser
from pathlib import Path
from typing import Dict, List, Optional
from datetime import datetime

# Try to import GUI libraries (fallback to CLI if unavailable)
GUI_AVAILABLE = False
try:
    import tkinter as tk
    from tkinter import ttk, messagebox
    GUI_AVAILABLE = True
except ImportError:
    print("Warning: tkinter not available, using CLI mode")

################################################################################
# Configuration
################################################################################

MYTHOS_VERSION = "1.0.0"
CONFIG_DIR = Path.home() / ".config" / "mythos"
CONFIG_FILE = CONFIG_DIR / "ai-hub-config.json"
HISTORY_FILE = CONFIG_DIR / "ai-hub-history.json"

# AI Service URLs
AI_SERVICES = {
    "Claude": {
        "name": "Claude (Anthropic)",
        "url": "https://claude.ai",
        "description": "Advanced AI assistant with long context",
        "shortcut": "Ctrl+1",
        "icon": "🤖",
        "category": "Chat"
    },
    "ChatGPT": {
        "name": "ChatGPT (OpenAI)",
        "url": "https://chat.openai.com",
        "description": "Popular conversational AI",
        "shortcut": "Ctrl+2",
        "icon": "💬",
        "category": "Chat"
    },
    "Gemini": {
        "name": "Gemini (Google)",
        "url": "https://gemini.google.com",
        "description": "Google's multimodal AI",
        "shortcut": "Ctrl+3",
        "icon": "✨",
        "category": "Chat"
    },
    "Perplexity": {
        "name": "Perplexity AI",
        "url": "https://www.perplexity.ai",
        "description": "AI-powered search and answers",
        "shortcut": "Ctrl+4",
        "icon": "🔍",
        "category": "Search"
    },
    "NotebookLM": {
        "name": "NotebookLM (Google)",
        "url": "https://notebooklm.google.com",
        "description": "AI research and note-taking",
        "shortcut": "Ctrl+5",
        "icon": "📓",
        "category": "Productivity"
    },
    "HuggingChat": {
        "name": "HuggingChat",
        "url": "https://huggingface.co/chat",
        "description": "Open-source AI chat",
        "shortcut": "Ctrl+6",
        "icon": "🤗",
        "category": "Chat"
    },
    "Ollama": {
        "name": "Ollama (Local)",
        "url": "http://localhost:11434",
        "description": "Run LLMs locally",
        "shortcut": "Ctrl+7",
        "icon": "🏠",
        "category": "Local"
    }
}

# Browser preferences (in order of preference)
BROWSERS = [
    "brave-browser",
    "firefox",
    "chromium",
    "google-chrome",
    "dillo",  # Lightweight fallback for mythOS
    "links",  # Text-based ultimate fallback
]

################################################################################
# Configuration Management
################################################################################

class Config:
    """Manage AI Hub configuration"""

    def __init__(self):
        self.config_dir = CONFIG_DIR
        self.config_file = CONFIG_FILE
        self.history_file = HISTORY_FILE
        self.config = self.load_config()
        self.history = self.load_history()

    def ensure_config_dir(self):
        """Ensure configuration directory exists"""
        self.config_dir.mkdir(parents=True, exist_ok=True)

    def load_config(self) -> Dict:
        """Load configuration from file"""
        self.ensure_config_dir()

        if self.config_file.exists():
            try:
                with open(self.config_file, 'r') as f:
                    return json.load(f)
            except Exception as e:
                print(f"Warning: Could not load config: {e}")

        # Default configuration
        return {
            "version": MYTHOS_VERSION,
            "favorites": ["Claude", "ChatGPT", "Perplexity"],
            "default_browser": None,
            "theme": "light",
            "show_descriptions": True,
            "recent_limit": 10
        }

    def save_config(self):
        """Save configuration to file"""
        self.ensure_config_dir()
        try:
            with open(self.config_file, 'w') as f:
                json.dump(self.config, f, indent=2)
        except Exception as e:
            print(f"Warning: Could not save config: {e}")

    def load_history(self) -> List[Dict]:
        """Load usage history"""
        if self.history_file.exists():
            try:
                with open(self.history_file, 'r') as f:
                    return json.load(f)
            except Exception as e:
                print(f"Warning: Could not load history: {e}")
        return []

    def save_history(self):
        """Save usage history"""
        self.ensure_config_dir()
        try:
            # Keep only recent entries
            recent_limit = self.config.get("recent_limit", 10)
            self.history = self.history[-recent_limit:]

            with open(self.history_file, 'w') as f:
                json.dump(self.history, f, indent=2)
        except Exception as e:
            print(f"Warning: Could not save history: {e}")

    def add_to_history(self, service: str):
        """Add service to history"""
        entry = {
            "service": service,
            "timestamp": datetime.now().isoformat(),
            "url": AI_SERVICES.get(service, {}).get("url", "")
        }
        self.history.append(entry)
        self.save_history()

################################################################################
# Browser Management
################################################################################

def find_available_browser() -> Optional[str]:
    """Find the first available browser from preferences"""
    for browser in BROWSERS:
        if subprocess.run(["which", browser], capture_output=True).returncode == 0:
            return browser
    return None

def launch_url(url: str, browser: Optional[str] = None) -> bool:
    """Launch URL in specified or default browser"""
    try:
        if browser:
            subprocess.Popen([browser, url], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        else:
            # Try to use webbrowser module
            webbrowser.open(url)
        return True
    except Exception as e:
        print(f"Error launching browser: {e}")
        return False

def launch_ai_service(service_key: str, config: Config):
    """Launch an AI service in the browser"""
    if service_key not in AI_SERVICES:
        print(f"Error: Unknown service '{service_key}'")
        return False

    service = AI_SERVICES[service_key]
    url = service["url"]

    print(f"Launching {service['name']}...")
    print(f"URL: {url}")

    browser = config.config.get("default_browser") or find_available_browser()

    if browser:
        print(f"Using browser: {browser}")
    else:
        print("Warning: No browser found, using system default")

    success = launch_url(url, browser)

    if success:
        config.add_to_history(service_key)
        print(f"✓ {service['name']} launched successfully")
    else:
        print(f"✗ Failed to launch {service['name']}")

    return success

################################################################################
# GUI Interface
################################################################################

class AIHubGUI:
    """Graphical interface for AI Hub"""

    def __init__(self, config: Config):
        self.config = config
        self.root = tk.Tk()
        self.root.title("mythOS AI Hub")
        self.root.geometry("600x500")

        # Set icon (if available)
        try:
            self.root.iconbitmap("@/usr/share/pixmaps/mythos.xbm")
        except:
            pass

        self.setup_ui()
        self.setup_keyboard_shortcuts()

    def setup_ui(self):
        """Setup user interface"""
        # Title
        title_frame = ttk.Frame(self.root, padding="10")
        title_frame.pack(fill=tk.X)

        title = ttk.Label(
            title_frame,
            text="🤖 mythOS AI Hub",
            font=("Sans", 16, "bold")
        )
        title.pack()

        subtitle = ttk.Label(
            title_frame,
            text="Your Gateway to AI Assistants",
            font=("Sans", 10)
        )
        subtitle.pack()

        # Separator
        ttk.Separator(self.root, orient=tk.HORIZONTAL).pack(fill=tk.X, pady=10)

        # Services notebook (tabs)
        notebook = ttk.Notebook(self.root)
        notebook.pack(fill=tk.BOTH, expand=True, padx=10, pady=5)

        # All Services tab
        all_frame = self.create_services_tab(notebook, list(AI_SERVICES.keys()))
        notebook.add(all_frame, text="All Services")

        # Favorites tab
        favorites = self.config.config.get("favorites", [])
        if favorites:
            fav_frame = self.create_services_tab(notebook, favorites)
            notebook.add(fav_frame, text="⭐ Favorites")

        # Recent tab
        if self.config.history:
            recent_services = [entry["service"] for entry in reversed(self.config.history)]
            # Remove duplicates while preserving order
            seen = set()
            recent_services = [x for x in recent_services if not (x in seen or seen.add(x))]

            recent_frame = self.create_services_tab(notebook, recent_services)
            notebook.add(recent_frame, text="🕐 Recent")

        # Status bar
        self.status_var = tk.StringVar(value="Ready")
        status_bar = ttk.Label(
            self.root,
            textvariable=self.status_var,
            relief=tk.SUNKEN,
            anchor=tk.W
        )
        status_bar.pack(side=tk.BOTTOM, fill=tk.X)

    def create_services_tab(self, parent, service_keys: List[str]) -> ttk.Frame:
        """Create a tab with service buttons"""
        frame = ttk.Frame(parent, padding="10")

        # Create scrollable canvas if needed
        canvas = tk.Canvas(frame)
        scrollbar = ttk.Scrollbar(frame, orient=tk.VERTICAL, command=canvas.yview)
        scrollable_frame = ttk.Frame(canvas)

        scrollable_frame.bind(
            "<Configure>",
            lambda e: canvas.configure(scrollregion=canvas.bbox("all"))
        )

        canvas.create_window((0, 0), window=scrollable_frame, anchor=tk.NW)
        canvas.configure(yscrollcommand=scrollbar.set)

        # Add service buttons
        for service_key in service_keys:
            if service_key not in AI_SERVICES:
                continue

            service = AI_SERVICES[service_key]
            self.create_service_button(scrollable_frame, service_key, service)

        canvas.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)
        scrollbar.pack(side=tk.RIGHT, fill=tk.Y)

        return frame

    def create_service_button(self, parent, service_key: str, service: Dict):
        """Create a button for an AI service"""
        frame = ttk.Frame(parent, padding="5")
        frame.pack(fill=tk.X, pady=2)

        # Icon and name
        btn_text = f"{service['icon']}  {service['name']}"
        if self.config.config.get("show_descriptions", True):
            btn = ttk.Button(
                frame,
                text=btn_text,
                command=lambda: self.launch_service(service_key),
                width=30
            )
            btn.pack(side=tk.LEFT)

            desc_label = ttk.Label(
                frame,
                text=service['description'],
                font=("Sans", 9),
                foreground="gray"
            )
            desc_label.pack(side=tk.LEFT, padx=10)
        else:
            btn = ttk.Button(
                frame,
                text=btn_text,
                command=lambda: self.launch_service(service_key)
            )
            btn.pack(fill=tk.X)

    def launch_service(self, service_key: str):
        """Launch a service and update status"""
        service = AI_SERVICES[service_key]
        self.status_var.set(f"Launching {service['name']}...")
        self.root.update()

        success = launch_ai_service(service_key, self.config)

        if success:
            self.status_var.set(f"✓ {service['name']} launched")
        else:
            self.status_var.set(f"✗ Failed to launch {service['name']}")
            messagebox.showerror(
                "Launch Error",
                f"Could not launch {service['name']}\n\nPlease check your internet connection and browser."
            )

    def setup_keyboard_shortcuts(self):
        """Setup keyboard shortcuts"""
        for service_key, service in AI_SERVICES.items():
            shortcut = service.get("shortcut")
            if shortcut:
                # Convert "Ctrl+1" to "<Control-1>"
                tk_shortcut = shortcut.replace("Ctrl", "Control").replace("+", "-")
                tk_shortcut = f"<{tk_shortcut}>"
                self.root.bind(tk_shortcut, lambda e, sk=service_key: self.launch_service(sk))

        # Quit shortcut
        self.root.bind("<Control-q>", lambda e: self.root.quit())

    def run(self):
        """Start the GUI main loop"""
        self.root.mainloop()

################################################################################
# CLI Interface
################################################################################

def print_banner():
    """Print CLI banner"""
    print("╔══════════════════════════════════════════════════════════════╗")
    print("║                                                              ║")
    print("║              mythOS AI Hub Launcher                          ║")
    print("║          Your Gateway to AI Assistants                       ║")
    print("║                                                              ║")
    print("╚══════════════════════════════════════════════════════════════╝")
    print()

def list_services():
    """List all available AI services"""
    print("Available AI Services:")
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print()

    for i, (key, service) in enumerate(AI_SERVICES.items(), 1):
        print(f"{i}. {service['icon']} {service['name']}")
        print(f"   {service['description']}")
        print(f"   URL: {service['url']}")
        print(f"   Shortcut: {service.get('shortcut', 'N/A')}")
        print()

def interactive_cli(config: Config):
    """Interactive CLI mode"""
    print_banner()
    list_services()

    while True:
        print("\nOptions:")
        print("  1-7: Launch service by number")
        print("  list: Show all services")
        print("  recent: Show recent services")
        print("  quit: Exit")
        print()

        choice = input("Select an option: ").strip().lower()

        if choice == "quit" or choice == "q":
            print("Goodbye!")
            break
        elif choice == "list" or choice == "l":
            list_services()
        elif choice == "recent" or choice == "r":
            if config.history:
                print("\nRecent Services:")
                for entry in reversed(config.history[-5:]):
                    print(f"  • {entry['service']} - {entry['timestamp']}")
                print()
            else:
                print("No recent services")
        elif choice.isdigit():
            idx = int(choice) - 1
            services = list(AI_SERVICES.keys())
            if 0 <= idx < len(services):
                launch_ai_service(services[idx], config)
            else:
                print("Invalid selection")
        elif choice in AI_SERVICES:
            launch_ai_service(choice, config)
        else:
            print(f"Unknown option: {choice}")

def show_help():
    """Show help message"""
    print(f"""
mythOS AI Hub Launcher v{MYTHOS_VERSION}

USAGE:
    ai-hub-launcher.py [COMMAND] [OPTIONS]

COMMANDS:
    gui                 Launch GUI (default if tkinter available)
    cli                 Launch interactive CLI
    launch <service>    Launch specific AI service
    list                List all available services
    help                Show this help message

SERVICES:
    Claude, ChatGPT, Gemini, Perplexity, NotebookLM, HuggingChat, Ollama

EXAMPLES:
    ai-hub-launcher.py                  # Launch GUI
    ai-hub-launcher.py cli              # Launch CLI
    ai-hub-launcher.py launch Claude    # Launch Claude directly
    ai-hub-launcher.py list             # List services

KEYBOARD SHORTCUTS (GUI):
    Ctrl+1 through Ctrl+7: Launch services
    Ctrl+Q: Quit

CONFIGURATION:
    Config file: {CONFIG_FILE}
    History file: {HISTORY_FILE}

For more information: https://github.com/Nightmare17726/mythOS
""")

################################################################################
# Main Entry Point
################################################################################

def main():
    """Main entry point"""
    config = Config()

    # Parse command line arguments
    if len(sys.argv) > 1:
        command = sys.argv[1].lower()

        if command == "help" or command == "--help" or command == "-h":
            show_help()
        elif command == "list":
            list_services()
        elif command == "cli":
            interactive_cli(config)
        elif command == "gui":
            if GUI_AVAILABLE:
                app = AIHubGUI(config)
                app.run()
            else:
                print("Error: GUI not available (tkinter not installed)")
                print("Falling back to CLI mode...")
                interactive_cli(config)
        elif command == "launch":
            if len(sys.argv) > 2:
                service = sys.argv[2]
                if service in AI_SERVICES:
                    launch_ai_service(service, config)
                else:
                    print(f"Error: Unknown service '{service}'")
                    print("Run 'ai-hub-launcher.py list' to see available services")
            else:
                print("Error: Please specify a service to launch")
                print("Example: ai-hub-launcher.py launch Claude")
        else:
            print(f"Error: Unknown command '{command}'")
            print("Run 'ai-hub-launcher.py help' for usage information")
    else:
        # Default: Launch GUI if available, otherwise CLI
        if GUI_AVAILABLE:
            app = AIHubGUI(config)
            app.run()
        else:
            interactive_cli(config)

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\n\nInterrupted by user")
        sys.exit(0)
    except Exception as e:
        print(f"\nError: {e}")
        sys.exit(1)
