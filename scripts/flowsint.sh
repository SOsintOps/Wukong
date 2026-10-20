#!/usr/bin/env bash
# flowsint.sh — Start Flowsint (graph-based investigation platform) from its
# Docker images, open the browser, stop the containers when the window closes.
# The data stays in the Docker volumes; the passwords are in
# ~/.config/wukong/flowsint.env (never delete it).
# Version: 0.1.0

set -uo pipefail

URL="http://127.0.0.1:5173"
FLOWSINT_DIR="$HOME/.local/share/wukong/programs/flowsint"
FLOWSINT_ENV="$HOME/.config/wukong/flowsint.env"

compose() {
    docker compose --env-file "$FLOWSINT_ENV" -f "$FLOWSINT_DIR/docker-compose.prod.yml" "$@"
}

stop_flowsint() {
    echo ""
    echo "Stopping Flowsint (the data stays in the Docker volumes)..."
    compose down >/dev/null 2>&1 || echo "WARNING: docker compose down failed."
}

if [ ! -f "$FLOWSINT_DIR/docker-compose.prod.yml" ] || [ ! -f "$FLOWSINT_ENV" ]; then
    echo "ERROR: Flowsint not found at $FLOWSINT_DIR (or $FLOWSINT_ENV is missing)."
    echo "Run wukong_install.sh to install it."
    read -rp "Press Enter to close..."
    exit 1
fi
if ! command -v docker >/dev/null 2>&1; then
    echo "ERROR: docker is not installed. Run wukong_install.sh."
    read -rp "Press Enter to close..."
    exit 1
fi
if ! docker info >/dev/null 2>&1; then
    echo "ERROR: Docker cannot be reached by your user."
    echo "If Flowsint was just installed, log out and in again: your user joined the docker group."
    read -rp "Press Enter to close..."
    exit 1
fi

if ! curl -s -o /dev/null "$URL"; then
    # The API publishes 127.0.0.1:5001, the port of Maigret Web as well.
    if [ -z "$(compose ps -q api 2>/dev/null)" ] && curl -s -o /dev/null http://127.0.0.1:5001; then
        echo "ERROR: port 5001 is used by another program (Maigret Web?). Close it and try again."
        read -rp "Press Enter to close..."
        exit 1
    fi
    echo "Starting Flowsint containers..."
    if ! compose up -d; then
        echo "ERROR: Flowsint could not start (see the messages above)."
        read -rp "Press Enter to close..."
        exit 1
    fi
    printf 'Waiting for %s (the databases take a while)' "$URL"
    for ((i = 0; i < 180; i++)); do
        curl -s -o /dev/null "$URL" && break
        printf '.'
        sleep 1
    done
    echo ""
    if ! curl -s -o /dev/null "$URL"; then
        echo "ERROR: Flowsint is not answering at $URL. Logs: docker compose -f $FLOWSINT_DIR/docker-compose.prod.yml logs"
        stop_flowsint
        read -rp "Press Enter to close..."
        exit 1
    fi
fi

echo "Flowsint is running at $URL"
echo "First visit: create your account at $URL/register"
xdg-open "$URL" 2>/dev/null &

trap stop_flowsint EXIT INT TERM
read -rp "Press Enter (or close this window) to stop Flowsint..."
