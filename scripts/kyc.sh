#!/usr/bin/env bash
################################################################################
## Chinese Corporate Due Diligence / KYC — Spoke Script (Wukong)
## Version 0.1.0 - Manifest-driven via tools.conf + common.sh
## Handles the "kyc" category: Chinese company investigation — ICP filing
## lookup, corporate registries (GSXT/TianYanCha/QCC), ENScan_GO enumeration.
################################################################################

set -uo pipefail

SCRIPT_NAME="CHINA KYC / DUE DILIGENCE"
SCRIPT_VERSION="0.1.0"
VERBOSE=false
[[ "${1:-}" == "-v" || "${1:-}" == "--verbose" ]] && VERBOSE=true

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

main() {
  print_banner "company · ICP备案 · 天眼查 · GSXT · ENScan"
  ensure_base_dir

  while true; do
    print_banner "company · ICP备案 · 天眼查 · GSXT · ENScan"
    local inputValue
    inputValue=$(zenity --entry \
      --title="China KYC / Due Diligence v${SCRIPT_VERSION}" \
      --text="Enter a company (中文 legal name / USCC), domain or ICP number:" \
      --width=480 2>/dev/null) || break
    [ -z "${inputValue:-}" ] && break

    _session_log "Input: '$inputValue' -> category: kyc"
    printf "\n  ${C_YELLOW}${BOLD}>  KYC${RESET}  ${C_GRAY}%s${RESET}\n" "$inputValue"
    run_category "kyc" "$inputValue" "CHINA DUE DILIGENCE TOOLS" "$C_YELLOW"

    zenity --question \
      --title="New query?" --text="Investigate another company?" \
      --ok-label="Yes" --cancel-label="No" 2>/dev/null || break
  done
}

main
