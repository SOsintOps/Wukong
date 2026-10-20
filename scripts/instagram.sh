#!/usr/bin/env bash
################################################################################
## Instagram OSINT — Spoke Script
## Version 0.1.0 - Manifest-driven via tools.conf + common.sh
################################################################################

set -uo pipefail

SCRIPT_NAME="INSTAGRAM OSINT"
SCRIPT_VERSION="0.1.0"
VERBOSE=false
[[ "${1:-}" == "-v" || "${1:-}" == "--verbose" ]] && VERBOSE=true

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

main() {
  print_banner "instagram profiles & media"
  check_required_tools instaloader
  ensure_base_dir

  while true; do
    print_banner "instagram profiles & media"
    local inputValue
    inputValue=$(zenity --entry \
      --title="Instagram OSINT v${SCRIPT_VERSION}" \
      --text="Enter an Instagram username:" \
      --width=460 2>/dev/null) || break
    [ -z "${inputValue:-}" ] && break

    _session_log "Input: '$inputValue' -> category: instagram"
    printf "\n  ${C_ORANGE}${BOLD}>  INSTAGRAM${RESET}  ${C_GRAY}%s${RESET}\n" "$inputValue"
    run_category "instagram" "$inputValue" "INSTAGRAM TOOLS" "$C_ORANGE"

    zenity --question \
      --title="New query?" --text="Scan another profile?" \
      --ok-label="Yes" --cancel-label="No" 2>/dev/null || break
  done
}

main
