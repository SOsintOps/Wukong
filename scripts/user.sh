#!/usr/bin/env bash
################################################################################
## OSINT Unified Input Script — Hub
## Version 0.5.0 - Refactored to source common.sh; manifest-driven via tools.conf
##
## This is the hub of the hub-and-spoke architecture.
## Person tracking categories (email, username, fullname, hash, phone) are
## handled internally via run_category(). Other investigation types dispatch
## to dedicated spoke scripts (domain.sh, instagram.sh, etc.).
################################################################################

set -uo pipefail

SCRIPT_NAME="OSINT UNIFIED TOOL"
SCRIPT_VERSION="0.5.0"
VERBOSE=false
[[ "${1:-}" == "-v" || "${1:-}" == "--verbose" ]] && VERBOSE=true

# Source shared library
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

###############################################################################
# Input classification (hub-specific)
###############################################################################
advanced_hash_detection() {
  tool_available "nth" || return 1
  nth --text "$1" 2>/dev/null | grep -iq "Possible Hashes"
}

classify_input() {
  local v="$1"
  [[ "$v" =~ ^[^@]+@[^@]+\.[^@]+$ ]] && { echo "email"; return; }
  [[ "$v" =~ ^\+?[0-9]{7,15}$ ]] && { echo "phone"; return; }
  if advanced_hash_detection "$v"; then echo "hash"; return; fi
  local len=${#v}
  if [[ "$v" =~ ^[A-Fa-f0-9]+$ ]] && \
     { [ "$len" -eq 32 ] || [ "$len" -eq 40 ] || \
       [ "$len" -eq 64 ] || [ "$len" -eq 128 ]; }; then
    echo "hash"; return
  fi
  if [[ "$v" =~ [[:space:]] ]]; then
    local valid=true; local -a toks
    IFS=' ' read -ra toks <<< "$v"
    for t in "${toks[@]}"; do [[ "$t" =~ ^[[:alpha:]-]+$ ]] || { valid=false; break; }; done
    $valid && [ ${#toks[@]} -ge 2 ] && { echo "fullname"; return; }
    echo "unknown"; return
  fi
  [[ "$v" =~ ^[a-zA-Z0-9_.\-]+$ ]] && { echo "username"; return; }
  echo "unknown"
}

resolve_unknown_category() {
  local choice
  choice=$(zenity --list \
    --title="Input classification" \
    --text="Could not classify: $1\n\nSelect the correct category:" \
    --column="Category" --column="Use for" \
    "Username"  "Social profile search" \
    "Fullname"  "Name-based search" \
    "Email"     "Email tools" \
    "Hash"      "Hash identification and cracking" \
    "Phone"     "Phone number lookup" \
    --width=420 --height=320 2>/dev/null) || return 1
  case "$choice" in
    "Username") echo "username" ;;
    "Fullname") echo "fullname" ;;
    "Email")    echo "email" ;;
    "Hash")     echo "hash" ;;
    "Phone")    echo "phone" ;;
    *)          echo "cancel" ;;
  esac
}

###############################################################################
# Main
###############################################################################
main() {
  print_banner "email · username · fullname · hash · phone"
  check_required_tools holehe socialscan sherlock maigret nth sth
  ensure_base_dir

  while true; do
    print_banner "email · username · fullname · hash · phone"
    local inputValue
    inputValue=$(zenity --entry \
      --title="OSINT Unified Tool v${SCRIPT_VERSION}" \
      --text="Enter username, email, full name, phone or hash:\n(launch with -v for live output)" \
      --width=460 2>/dev/null) || break
    [ -z "${inputValue:-}" ] && break

    local category; category=$(classify_input "$inputValue")
    if [ "$category" = "unknown" ]; then
      category=$(resolve_unknown_category "$inputValue") || continue
      [ "$category" = "cancel" ] && continue
    fi

    _session_log "Input: '$inputValue' -> category: $category"

    case "$category" in
      "email")
        printf "\n  ${COL_EMAIL}${BOLD}>  EMAIL${RESET}  ${C_GRAY}%s${RESET}\n" "$inputValue"
        run_category "email" "$inputValue" "EMAIL TOOLS" "$COL_EMAIL" ;;
      "hash")
        printf "\n  ${COL_HASH}${BOLD}>  HASH${RESET}  ${C_GRAY}%s${RESET}\n" "$inputValue"
        run_category "hash" "$inputValue" "HASH TOOLS" "$COL_HASH" ;;
      "fullname")
        printf "\n  ${COL_NAME}${BOLD}>  FULLNAME${RESET}  ${C_GRAY}%s${RESET}\n" "$inputValue"
        run_category "fullname" "$inputValue" "FULLNAME TOOLS" "$COL_NAME" ;;
      "username")
        printf "\n  ${COL_USER}${BOLD}>  USERNAME${RESET}  ${C_GRAY}%s${RESET}\n" "$inputValue"
        run_category "username" "$inputValue" "USERNAME TOOLS" "$COL_USER" ;;
      "phone")
        printf "\n  ${COL_PHONE}${BOLD}>  PHONE${RESET}  ${C_GRAY}%s${RESET}\n" "$inputValue"
        run_category "phone" "$inputValue" "PHONE TOOLS" "$COL_PHONE" ;;
    esac

    zenity --question \
      --title="New query?" --text="Run another search?" \
      --ok-label="Yes" --cancel-label="No" 2>/dev/null || break
  done

  [ -n "$SESSION_LOG_FILE" ] && {
    _session_log "Session ended: $(date +'%Y-%m-%d %H:%M:%S')"
    printf "\n  ${C_GRAY}i  Session log: %s${RESET}\n" "$SESSION_LOG_FILE"
  }
  echo ""; _line "=" 62 "$C_PURPLE"
  printf "${C_PURPLE}${BOLD}  Session ended.${RESET}\n"
  _line "=" 62 "$C_PURPLE"; echo ""
}

main
