# mythOS Chase Edition - Complete Program List

**Target Size**: 100MB (increased from 50MB due to office needs)
**Focus**: Terminal power + lightweight office editing

## Office & Document Editing

### Local (Lightweight)
- **sc-im** - Spreadsheet Calculator Improvised (Vim-like Excel in terminal)
- **WordGrinder** - Lightweight word processor (terminal)
- **Pandoc** - Universal document converter (Markdown ↔ DOCX/PDF)
- **LibreOffice Writer (headless)** - Command-line document processing
- **wkhtmltopdf** - HTML to PDF converter
- **pdfgrep** - Search PDFs from terminal
- **poppler-utils** - PDF manipulation (pdfunite, pdfseparate, etc.)

### Cloud-Based (via Links/Lynx browser)
- **Microsoft Office Online** - Full Word/Excel/PowerPoint via browser
- **Google Docs/Sheets/Slides** - Via browser
- **OnlyOffice Cloud** - Via browser
- **Cryptpad** - Privacy-focused office suite

## Terminal Productivity
- **Vim** - Text editor with office plugins
- **Emacs** - With org-mode for documents
- **Mutt** - Email client (terminal)
- **Calcurse** - Calendar and tasks
- **Ledger** - Plain text accounting
- **sc-im** - Spreadsheet in terminal

## File Management
- **Ranger** - Vim-like file manager with previews
- **nnn** - Fast file manager
- **Midnight Commander** - Classic dual-pane
- **fzf** - Fuzzy finder

## Development
- **Git + tig** - Version control
- **Vim with plugins** - IDE-like editing
- **Neovim** - Modern Vim
- **Python 3 + pip** - Scripting
- **Node.js (minimal)** - JavaScript runtime
- **GCC/Make** - C compilation

## System Utilities
- **tmux** - Terminal multiplexer
- **htop** - Process viewer
- **glances** - System monitor
- **ncdu** - Disk usage analyzer
- **rsync** - File sync
- **wget/curl** - Downloads

## Network Tools
- **Links** - Web browser (text + basic graphics)
- **Lynx** - Pure text browser
- **mtr** - Network diagnostic
- **nmap** - Network scanner
- **WireGuard** - VPN
- **SSH/Mosh** - Remote access

## Document Viewing
- **less** - Text viewer with search
- **bat** - Syntax highlighting viewer
- **pdftotext** - PDF to text
- **catdoc** - DOC to text
- **xlsx2csv** - Excel to CSV

## Cloud Office Access Script
```bash
#!/bin/bash
# office-cloud - Quick access to cloud office suites
echo "Cloud Office Suite Launcher"
echo "1. Microsoft Office Online"
echo "2. Google Docs"
echo "3. OnlyOffice"
read -p "Choose [1-3]: " choice
case $choice in
    1) links https://office.com;;
    2) links https://docs.google.com;;
    3) links https://onlyoffice.com;;
esac
```

## Total Packages: 35+
## Estimated Size: 95-105MB
