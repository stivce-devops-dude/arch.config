#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PERSONAL=false

for arg in "$@"; do
  case $arg in
    --personal|--gaming) PERSONAL=true ;;
    *) echo "Unknown argument: $arg"; exit 1 ;;
  esac
done

[[ $EUID -eq 0 ]] || { echo "ERROR: Run with sudo."; exit 1; }
[[ -n "${SUDO_USER:-}" ]] || { echo "ERROR: SUDO_USER not set. Run with sudo."; exit 1; }

command -v ansible-playbook &>/dev/null || { echo "ERROR: ansible-playbook not found."; exit 1; }

 echo "==> Running playbook..."
if $PERSONAL; then
  ansible-playbook -i "$SCRIPT_DIR/inventory" "$SCRIPT_DIR/playbook.yml" --tags "pacman,makepkg,system,aur,boot,directories,packages,hyprland,gaming,dotfiles"
else
  ansible-playbook -i "$SCRIPT_DIR/inventory" "$SCRIPT_DIR/playbook.yml" --skip-tags "gaming"
fi

echo "==> Done."