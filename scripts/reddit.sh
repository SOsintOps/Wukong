#!/usr/bin/env bash
################################################################################
## Reddit OSINT — Spoke Script
## Version 0.1.0 - Manifest-driven via tools.conf + common.sh
################################################################################

set -uo pipefail

SCRIPT_NAME="REDDIT OSINT"
SCRIPT_VERSION="0.1.0"
VERBOSE=false
[[ "${1:-}" == "-v" || "${1:-}" == "--verbose" ]] && VERBOSE=true

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

main() {
  print_banner "reddit user analysis"
  check_required_tools bdfr
  ensure_base_dir

  while true; do
    print_banner "reddit user analysis"
    local inputValue
    inputValue=$(zenity --entry \
      --title="Reddit OSINT v${SCRIPT_VERSION}" \
      --text="Enter a Reddit username:" \
      --width=460 2>/dev/null) || break
    [ -z "${inputValue:-}" ] && break

    _session_log "Input: '$inputValue' -> category: reddit"
    printf "\n  ${C_RED}${BOLD}>  REDDIT${RESET}  ${C_GRAY}%s${RESET}\n" "$inputValue"
    run_category "reddit" "$inputValue" "REDDIT TOOLS" "$C_RED"

    zenity --question \
      --title="New query?" --text="Scan another user?" \
      --ok-label="Yes" --cancel-label="No" 2>/dev/null || break
  done
}

main
