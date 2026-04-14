# 🔧 Termux Toolkit

A collection of handy scripts to enhance your **Termux** workflow — from installing essential packages to fixing root/sudo issues. Simple, fast, and ready to use.

---

## 📌 Key Features

* Install **essential Termux tools** with a single command
* Quick **sudo/root fixer** for better compatibility
* Lightweight, clean, shell-based scripts for daily use

---

## 📂 Repository Layout

| Script        | Purpose                                          |
| ------------- | ------------------------------------------------ |
| `basic.sh`    | Installs core packages and development utilities |
| `fix_sudo.sh` | Fixes sudo behavior and improves root access     |

---

## ⚡ Quick Start

### 1️⃣ Install Core Termux Packages

```bash
curl -sL https://raw.githubusercontent.com/Gtajisan/Termux-fix/main/basic.sh | bash
```

### 2️⃣ Fix or Enable Sudo Access

```bash
curl -sL https://raw.githubusercontent.com/Gtajisan/Termux-fix/main/fix_sudo.sh | bash
```

---

## 💡 Notes

* Scripts are **interactive by default**, but you can pass flags (like `--all`) for full automation.
* Tested on Termux (Android 10+) with standard repositories.
* Always make sure you **backup important data** before running scripts that modify root or sudo behavior.

---

# credit 
- source by @anbuinfosec
