#!/usr/bin/env bash
# maigret-web.sh — Launch Maigret Enhanced web interface
# Version: 0.3.0

set -euo pipefail

PORT=5001
URL="http://127.0.0.1:${PORT}"
PROGRAMS_DIR="$HOME/.local/share/speculator/programs"
SCRIPTS_DIR="$HOME/.local/share/speculator/scripts"
MAIGRET_VENV="$PROGRAMS_DIR/maigret/maigretEnvironment"
ENHANCED_DIR="$SCRIPTS_DIR/maigret-enhanced"
EVIDENCE_DIR="$HOME/Downloads/evidence/maigret"

if [ ! -d "$MAIGRET_VENV" ]; then
    echo "ERROR: maigret venv not found at $MAIGRET_VENV"
    echo "Run speculator_install.sh to install maigret from the SOsintOps fork."
    read -rp "Press Enter to close..."
    exit 1
fi

if [ ! -f "$ENHANCED_DIR/server.py" ]; then
    echo "ERROR: maigret-enhanced not found at $ENHANCED_DIR"
    echo "Run speculator_install.sh to install the enhanced web UI."
    read -rp "Press Enter to close..."
    exit 1
fi

mkdir -p "$EVIDENCE_DIR"

echo "Starting Maigret Enhanced on ${URL} ..."
echo "Evidence: ${EVIDENCE_DIR}/"
sleep 1
xdg-open "$URL" 2>/dev/null &

cd "$ENHANCED_DIR"
exec "$MAIGRET_VENV/bin/python" -m uvicorn server:app --host 127.0.0.1 --port "$PORT"
