#!/usr/bin/env bash
# quaesitor.sh — Launch Quaesitor (SOsintOps fork of OSInt Graph): the case
# as a graph in the browser. The archive is kept in the evidence folder.
# Version: 0.1.0

set -euo pipefail

# 5000 is Changedetection.io, 5001 Maigret Web: Quaesitor takes 5002.
PORT=5002
URL="http://127.0.0.1:${PORT}"
PROGRAMS_DIR="$HOME/.local/share/wukong/programs"
QUAESITOR_DIR="$PROGRAMS_DIR/quaesitor"
QUAESITOR_PY="$QUAESITOR_DIR/quaesitorEnvironment/bin/python"
DATA_DIR="$HOME/Downloads/evidence/quaesitor"

if [ ! -f "$QUAESITOR_DIR/app.py" ] || [ ! -x "$QUAESITOR_PY" ]; then
    echo "ERROR: Quaesitor not found at $QUAESITOR_DIR"
    echo "Run wukong_install.sh to install it."
    read -rp "Press Enter to close..."
    exit 1
fi

mkdir -p "$DATA_DIR"

echo "Starting Quaesitor on ${URL} ..."
echo "Archive: ${DATA_DIR}/"
echo "Close this window or press Ctrl+C to stop it."
sleep 1
xdg-open "$URL" 2>/dev/null &

cd "$QUAESITOR_DIR"
DATA_DIR="$DATA_DIR" PORT="$PORT" exec "$QUAESITOR_PY" app.py
