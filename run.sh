#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PERSONAL=false

# ══════════════════════════════════════════════════════════════════════════════
# ARGS
# ══════════════════════════════════════════════════════════════════════════════
for arg in "$@"; do
  case $arg in
    --personal) PERSONAL=true ;;
    *) echo "Unknown argument: $arg"; exit 1 ;;
  esac
done

# ══════════════════════════════════════════════════════════════════════════════
# CHECKS
# ══════════════════════════════════════════════════════════════════════════════
[[ $EUID -eq 0 ]] || { echo "ERROR: Run with sudo, not as root directly. (sudo ./run.sh)"; exit 1; }
[[ -n "${SUDO_USER:-}" ]] || { echo "ERROR: SUDO_USER is not set. Run with sudo."; exit 1; }

command -v ansible-playbook &>/dev/null || { echo "ERROR: ansible-playbook not found."; exit 1; }

# ══════════════════════════════════════════════════════════════════════════════
# RUN
# ══════════════════════════════════════════════════════════════════════════════
echo "==> Running meta playbook as user: $SUDO_USER"
ansible-playbook -i "$SCRIPT_DIR/inventory" "$SCRIPT_DIR/playbook.yml"

if $PERSONAL; then
  echo "==> Running personal playbook..."
  ansible-playbook -i "$SCRIPT_DIR/inventory" "$SCRIPT_DIR/personal.yml"
fi

echo "==> Done."
