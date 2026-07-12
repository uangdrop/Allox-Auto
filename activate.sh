#!/usr/bin/env bash
# Activate the venv (or create it if it doesn't exist yet).
# Usage:  source ./activate.sh   (note: must be sourced, not executed)

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_DIR="$SCRIPT_DIR/.venv"

if [ ! -d "$VENV_DIR" ]; then
    echo "[activate] No .venv found — creating one with python3 -m venv"
    python3 -m venv "$VENV_DIR"
    echo "[activate] venv created at $VENV_DIR"
fi

# shellcheck disable=SC1091
source "$VENV_DIR/bin/activate"

# Auto-install requirements on first activate (idempotent — only if needed)
if [ ! -f "$VENV_DIR/.installed" ] || [ requirements.txt -nt "$VENV_DIR/.installed" ]; then
    echo "[activate] Installing requirements.txt ..."
    pip install --quiet --upgrade pip
    pip install --quiet -r requirements.txt
    touch "$VENV_DIR/.installed"
    echo "[activate] dependencies installed"
fi

echo "[activate] venv active. python=$(which python)  pip=$(which pip)"
echo "[activate] to run:  python bot.py"
echo "[activate] to exit: deactivate"
