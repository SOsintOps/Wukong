#!/usr/bin/env bash
################################################################################
## Domain & Infrastructure OSINT — Spoke Script
## Version 0.1.0 - Manifest-driven via tools.conf + common.sh
################################################################################

set -uo pipefail

SCRIPT_NAME="DOMAIN OSINT"
SCRIPT_VERSION="0.1.0"
VERBOSE=false
[[ "${1:-}" == "-v" || "${1:-}" == "--verbose" ]] && VERBOSE=true

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

main() {
  print_banner "domain · subdomain · infrastructure"
  check_required_tools amass subfinder
  ensure_base_dir

  while true; do
    print_banner "domain · subdomain · infrastructure"
    local inputValue
    inputValue=$(zenity --entry \
      --title="Domain OSINT v${SCRIPT_VERSION}" \
      --text="Enter a domain to investigate:" \
      --width=460 2>/dev/null) || break
    [ -z "${inputValue:-}" ] && break

    _session_log "Input: '$inputValue' -> category: domain"
    printf "\n  ${COL_DOMAIN}${BOLD}>  DOMAIN${RESET}  ${C_GRAY}%s${RESET}\n" "$inputValue"
    run_category "domain" "$inputValue" "DOMAIN TOOLS" "$COL_DOMAIN"

    zenity --question \
      --title="New query?" --text="Scan another domain?" \
      --ok-label="Yes" --cancel-label="No" 2>/dev/null || break
  done
}

main
