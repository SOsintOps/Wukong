#!/usr/bin/env bash
################################################################################
## Image & Metadata OSINT — Spoke Script
## Version 0.1.0 - Manifest-driven via tools.conf + common.sh
################################################################################

set -uo pipefail

SCRIPT_NAME="IMAGE & METADATA OSINT"
SCRIPT_VERSION="0.1.0"
VERBOSE=false
[[ "${1:-}" == "-v" || "${1:-}" == "--verbose" ]] && VERBOSE=true

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

main() {
  print_banner "exif · metadata · forensics"
  check_required_tools exiftool
  ensure_base_dir

  while true; do
    print_banner "exif · metadata · forensics"
    local inputValue
    inputValue=$(zenity --file-selection \
      --title="Image & Metadata OSINT v${SCRIPT_VERSION} — Select file or folder" \
      2>/dev/null) || break
    [ -z "${inputValue:-}" ] && break

    _session_log "Input: '$inputValue' -> category: image"
    printf "\n  ${C_CYAN}${BOLD}>  IMAGE${RESET}  ${C_GRAY}%s${RESET}\n" "$inputValue"
    run_category "image" "$inputValue" "IMAGE & METADATA TOOLS" "$C_CYAN"

    zenity --question \
      --title="New query?" --text="Analyze another file?" \
      --ok-label="Yes" --cancel-label="No" 2>/dev/null || break
  done
}

main
