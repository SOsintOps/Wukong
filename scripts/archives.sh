#!/usr/bin/env bash
################################################################################
## Web Archives — Spoke Script
## Version 0.1.0 - Manifest-driven via tools.conf + common.sh
################################################################################

set -uo pipefail

SCRIPT_NAME="ARCHIVES OSINT"
SCRIPT_VERSION="0.1.0"
VERBOSE=false
[[ "${1:-}" == "-v" || "${1:-}" == "--verbose" ]] && VERBOSE=true

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

main() {
  print_banner "wayback · internet archive"
  check_required_tools waybackpy
  ensure_base_dir

  while true; do
    print_banner "wayback · internet archive"
    local inputValue
    inputValue=$(zenity --entry \
      --title="Archives OSINT v${SCRIPT_VERSION}" \
      --text="Enter a URL to search in archives:" \
      --width=460 2>/dev/null) || break
    [ -z "${inputValue:-}" ] && break

    _session_log "Input: '$inputValue' -> category: archives"
    printf "\n  ${C_BLUE}${BOLD}>  ARCHIVES${RESET}  ${C_GRAY}%s${RESET}\n" "$inputValue"
    run_category "archives" "$inputValue" "ARCHIVES TOOLS" "$C_BLUE"

    zenity --question \
      --title="New query?" --text="Search another URL?" \
      --ok-label="Yes" --cancel-label="No" 2>/dev/null || break
  done
}

main
