#!/usr/bin/env bash
# editsimple.sh — Launch EditSimple, the video editor to explain a fact or show
# evidence (tracking, zoom, pixelation, slides). A video or a project passed
# by the menu or the file manager is opened at once.
# Version: 0.1.0

set -euo pipefail

EDITSIMPLE_DIR="$HOME/.local/share/wukong/programs/EditSimple"
EDITSIMPLE_PY="$EDITSIMPLE_DIR/EditSimpleEnvironment/bin/python"

if [ ! -f "$EDITSIMPLE_DIR/EditSimple.py" ] || [ ! -x "$EDITSIMPLE_PY" ]; then
    zenity --error --text="EditSimple not found at $EDITSIMPLE_DIR.\nRun wukong_install.sh to install it." 2>/dev/null \
        || echo "ERROR: EditSimple not found at $EDITSIMPLE_DIR"
    exit 1
fi

cd "$EDITSIMPLE_DIR"
exec "$EDITSIMPLE_PY" EditSimple.py "$@"
