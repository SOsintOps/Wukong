#!/usr/bin/env bash
################################################################################
## Sinophone OSINT — Spoke Script (Wukong)
## Version 0.1.0 - Manifest-driven via tools.conf + common.sh
## Handles the "china" category: Chinese web, social, search and cyberspace
## reconnaissance tools (Baidu/Sogou, Weibo/Douyin/Xiaohongshu, fofa/ZoomEye).
################################################################################

set -uo pipefail

SCRIPT_NAME="SINOPHONE OSINT"
SCRIPT_VERSION="0.1.0"
VERBOSE=false
[[ "${1:-}" == "-v" || "${1:-}" == "--verbose" ]] && VERBOSE=true

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

main() {
  print_banner "china · weibo · douyin · fofa · baidu"
  ensure_base_dir

  while true; do
    print_banner "china · weibo · douyin · fofa · baidu"
    local inputValue
    inputValue=$(zenity --entry \
      --title="Sinophone OSINT v${SCRIPT_VERSION}" \
      --text="Enter a target (username, domain, keyword in 中文, URL):" \
      --width=460 2>/dev/null) || break
    [ -z "${inputValue:-}" ] && break

    _session_log "Input: '$inputValue' -> category: china"
    printf "\n  ${C_RED}${BOLD}>  CHINA${RESET}  ${C_GRAY}%s${RESET}\n" "$inputValue"
    run_category "china" "$inputValue" "SINOPHONE TOOLS" "$C_RED"

    zenity --question \
      --title="New query?" --text="Investigate another target?" \
      --ok-label="Yes" --cancel-label="No" 2>/dev/null || break
  done
}

main
