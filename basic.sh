#!/bin/bash

# Termux Setup Tool — rewritten for Gtajisan (Farhan)
# Version: 1.1
# Created by: Gtajisan (Farhan)

clear

# Colors
BOLD="\e[1m"
RESET="\e[0m"
RED="\e[1;31m"
GREEN="\e[1;32m"
YELLOW="\e[1;33m"
BLUE="\e[1;34m"
MAGENTA="\e[1;35m"
CYAN="\e[1;36m"

echo -e "${MAGENTA}${BOLD}"
echo "╔══════════════════════════════════════╗"
echo "║          TERMUX SETUP UTILITY         ║"
echo "║         maintained by Gtajisan        ║"
echo "║               (Farhan)                ║"
echo "╚══════════════════════════════════════╝"
echo -e "${RESET}"

INSTALL_ALL=false
if [[ "$1" == "--all" ]]; then
  INSTALL_ALL=true
fi

# show a small header with timestamp
echo -e "${CYAN}[i] Started at: $(date '+%Y-%m-%d %H:%M:%S')${RESET}"
echo ""

update_termux() {
  echo -e "${GREEN}[+] Updating Termux packages...${RESET}"
  pkg update -y && pkg upgrade -y
}

install_group() {
  local description="$1"
  shift
  # build a nice display list for the packages
  local pkg_list="$*"
  if $INSTALL_ALL; then
    echo -e "${BLUE}[→] Installing:${YELLOW} $description${RESET}"
    pkg install -y $pkg_list
  else
    # default to 'n' if empty
    read -p "[?] Install ${description}? (y/N): " choice
    choice="${choice:-n}"
    if [[ "$choice" =~ ^[Yy]$ ]]; then
      echo -e "${BLUE}[→] Installing:${YELLOW} $description${RESET}"
      pkg install -y $pkg_list
    else
      echo -e "${YELLOW}[! ] Skipped:${RESET} $description"
    fi
  fi
  echo ""
}

# Start actions
update_termux

install_group "Essential packages" git curl wget unzip zip tar nano vim neofetch
install_group "Development & build tools" clang make cmake build-essential python nodejs
install_group "Network & security utilities" nmap net-tools tsu dnsutils openssh
install_group "Python environment" python python-pip
# upgrade pip only if pip exists
if command -v pip >/dev/null 2>&1; then
  echo -e "${GREEN}[+] Upgrading pip...${RESET}"
  pip install --upgrade pip
fi
install_group "Linux-like utilities" htop tree proot termux-api
install_group "Web stack (optional)" php apache2
install_group "Optional security & pentest tools" hydra sqlmap metasploit
install_group "Fun & style" toilet cowsay lolcat

# request storage permission
echo -e "${MAGENTA}[•] Requesting storage permission (termux-setup-storage)...${RESET}"
termux-setup-storage

# small finishing flourish
echo -e "${GREEN}${BOLD}"
echo "======================================="
echo "   🎉  Setup finished — stay awesome!  🎉"
echo "   Maintainer: Gtajisan (Farhan)"
echo "======================================="
echo -e "${RESET}"

