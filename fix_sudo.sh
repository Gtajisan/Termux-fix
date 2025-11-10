#!/bin/bash
# Termux Root Fix Tool — updated for Gtajisan (Farhan)
# Version: 1.2
# Maintainer: Gtajisan (Farhan)
# Changelog:
# - Added support for /system/product/bin/su
# - Improved su path search and validation
# - Cleaned up redundant messages

# ════════════════════════════════════════════════════
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

# Expanded SU search paths
SU_SEARCH_PATHS=(
  /system/bin/su
  /debug_ramdisk/su
  /system/xbin/su
  /sbin/su
  /sbin/bin/su
  /system/sbin/su
  /su/xbin/su
  /su/bin/su
  /magisk/.core/bin/su
  /system/product/bin/su   # newly added path
)

root_check() {
  # If already root
  if [ "$(id -u 2>/dev/null)" = "0" ]; then
    echo -e "${GREEN}✓ You are already root (uid 0).${RESET}"
    return 0
  fi

  # Try passwordless sudo
  if command -v sudo >/dev/null 2>&1 && sudo -n true 2>/dev/null; then
    whoami_out="$(sudo whoami 2>/dev/null || true)"
    echo -e "${GREEN}✓ sudo is available — remote identity: ${whoami_out}${RESET}"
    return 0
  fi

  # Try to find any working 'su' in known paths
  echo -e "${CYAN}→ Searching for working 'su' binary...${RESET}"
  for su_path in "${SU_SEARCH_PATHS[@]}"; do
    if [ -x "$su_path" ]; then
      echo -e "${YELLOW}• Found su: ${su_path}${RESET}"
      if "$su_path" -c "id -u" >/dev/null 2>&1; then
        echo -e "${GREEN}✓ su binary at ${su_path} works for root access.${RESET}"
        read -p "[?] Launch root shell now using '${su_path} -c sh'? (y/N): " ans
        ans="${ans:-n}"
        if [[ "$ans" =~ ^[Yy]$ ]]; then
          exec "$su_path" -c "sh"
        else
          echo -e "${YELLOW}→ You can manually run: ${su_path} -c sh${RESET}"
        fi
        return 0
      fi
    fi
  done

  echo -e "${RED}✗ No working su binary detected in known locations.${RESET}"
  echo -e "${YELLOW}→ Ensure Magisk or another su provider is properly installed.${RESET}"
  return 1
}

root_check
echo ""

# Finishing note
echo -e "${GREEN}${BOLD}✔ Root fix attempt finished.${RESET}"
echo -e "${CYAN}Maintainer: Gtajisan (Farhan) — stay safe and test carefully.${RESET}"
