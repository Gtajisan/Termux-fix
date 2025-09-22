#!/bin/bash
# Termux Root Fix Tool — updated for Gtajisan (Farhan)
# Version: 1.1
# Maintainer: Gtajisan (Farhan)

# Color palette
BOLD="\e[1m"
RESET="\e[0m"
GREEN="\e[0;32m"
CYAN="\e[1;36m"
YELLOW="\e[1;33m"
MAGENTA="\e[1;35m"
RED="\e[1;31m"

clear
echo -e "${MAGENTA}${BOLD}"
echo "╔═════════════════════════════════════════════════════════╗"
echo "║                  TERMUX ROOT FIX TOOL                   ║"
echo "║              Maintainer: Gtajisan (Farhan)             ║"
echo "╚═════════════════════════════════════════════════════════╝"
echo -e "${RESET}"
echo ""

# helper: print step header
step() {
  echo -e "${YELLOW}[${1}/4] ${2}${RESET}"
}

# 1. Remove potentially conflicting tsu package
step 1 "Removing conflicting 'tsu' package..."
if pkg uninstall tsu -y > /dev/null 2>&1; then
  echo -e "${GREEN}✓ tsu removed (if it existed)${RESET}"
else
  echo -e "${YELLOW}! tsu may not be installed or removal failed (continuing)${RESET}"
fi
echo ""

# 2. Update & upgrade
step 2 "Updating and upgrading packages..."
if pkg update -y > /dev/null 2>&1 && pkg upgrade -y > /dev/null 2>&1; then
  echo -e "${GREEN}✓ Packages updated${RESET}"
else
  echo -e "${YELLOW}! Update/upgrade returned with warnings (check output manually)${RESET}"
fi
echo ""

# 3. Install sudo
step 3 "Installing 'sudo' package..."
if pkg install sudo -y > /dev/null 2>&1; then
  echo -e "${GREEN}✓ sudo installed${RESET}"
else
  echo -e "${RED}✗ Failed to install sudo — try 'pkg install sudo' manually${RESET}"
fi
echo ""

# 4. Retest root access (safe)
step 4 "Retesting root access (safe check)..."
root_check() {
  # If already root
  if [ "$(id -u 2>/dev/null)" = "0" ]; then
    echo -e "${GREEN}✓ You are already root (uid 0).${RESET}"
    return 0
  fi

  # Try passwordless sudo check (won't prompt for password due to -n)
  if command -v sudo >/dev/null 2>&1 && sudo -n true 2>/dev/null; then
    whoami_out="$(sudo whoami 2>/dev/null || true)"
    echo -e "${GREEN}✓ sudo is available — remote identity: ${whoami_out}${RESET}"
    return 0
  fi

  # If sudo exists but requires password, inform user and offer to open a shell
  if command -v sudo >/dev/null 2>&1; then
    echo -e "${YELLOW}! sudo is installed but requires a password or interaction.${RESET}"
    read -p "[?] Drop to a root shell now using 'sudo su'? (y/N): " reply
    reply="${reply:-n}"
    if [[ "$reply" =~ ^[Yy]$ ]]; then
      echo -e "${CYAN}Launching: sudo su${RESET}"
      exec sudo su
      # exec replaces the script; if it returns, continue
    else
      echo -e "${YELLOW}→ Skipping interactive root shell. You can run 'sudo su' yourself.${RESET}"
    fi
    return 1
  fi

  # Try su if available (some rooted devices)
  if command -v su >/dev/null 2>&1; then
    echo -e "${YELLOW}! 'su' binary found — attempting a non-interactive uid check...${RESET}"
    if su -c 'id -u' >/dev/null 2>&1; then
      echo -e "${GREEN}✓ 'su' worked — you can use su to gain root.${RESET}"
      read -p "[?] Open an interactive root shell with 'su -c \"sh\"'? (y/N): " r2
      r2="${r2:-n}"
      if [[ "$r2" =~ ^[Yy]$ ]]; then
        exec su -c "sh"
      else
        echo -e "${YELLOW}→ Skipping interactive root shell. You can run 'su' yourself.${RESET}"
      fi
      return 0
    else
      echo -e "${RED}✗ 'su' present but failed to elevate (or requires interaction).${RESET}"
      return 1
    fi
  fi

  echo -e "${RED}✗ No interactive root method detected (sudo/su not available or restricted).${RESET}"
  echo -e "${YELLOW}→ If your device is rooted, ensure a su provider (Magisk/SuperSU) is installed and try again.${RESET}"
  return 1
}

root_check
echo ""

# Finishing note
echo -e "${GREEN}${BOLD}✔ Root fix attempt finished.${RESET}"
echo -e "${CYAN}Maintainer: Gtajisan (Farhan) — stay safe and test carefully.${RESET}"
