#!/usr/bin/env bash
################################################################################
## Video & Media Download — Spoke Script
## Version 0.1.0 - Manifest-driven via tools.conf + common.sh
################################################################################

set -uo pipefail

SCRIPT_NAME="VIDEO OSINT"
SCRIPT_VERSION="0.1.0"
VERBOSE=false
[[ "${1:-}" == "-v" || "${1:-}" == "--verbose" ]] && VERBOSE=true

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

main() {
  print_banner "video · stream · gallery download"
  check_required_tools yt-dlp
  ensure_base_dir

  while true; do
    print_banner "video · stream · gallery download"
    local inputValue
    inputValue=$(zenity --entry \
      --title="Video OSINT v${SCRIPT_VERSION}" \
      --text="Enter a URL to download/archive:" \
      --width=460 2>/dev/null) || break
    [ -z "${inputValue:-}" ] && break

    _session_log "Input: '$inputValue' -> category: video"
    printf "\n  ${C_RED}${BOLD}>  VIDEO${RESET}  ${C_GRAY}%s${RESET}\n" "$inputValue"
    run_category "video" "$inputValue" "VIDEO TOOLS" "$C_RED"

    zenity --question \
      --title="New query?" --text="Download another URL?" \
      --ok-label="Yes" --cancel-label="No" 2>/dev/null || break
  done
}

main
