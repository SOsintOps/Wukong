#!/usr/bin/env bash
################################################################################
## OSINT Frameworks — Spoke Script
## Version 0.1.0 - Launches interactive OSINT frameworks
################################################################################

set -uo pipefail

SCRIPT_NAME="OSINT FRAMEWORKS"
SCRIPT_VERSION="0.1.0"
VERBOSE=false
[[ "${1:-}" == "-v" || "${1:-}" == "--verbose" ]] && VERBOSE=true

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

main() {
  print_banner "recon-ng · sn0int · changedetection · maigret web"
  ensure_base_dir

  load_manifest "frameworks"
  if [ ${#_MF_IDS[@]} -eq 0 ]; then
    zenity --error --text="No framework tools found in manifest." --width=300 2>/dev/null
    return 1
  fi

  # Build display names array for zenity
  local names=()
  for id in "${_MF_IDS[@]}"; do
    local avail="not installed"
    tool_available "${_MF_CHECK_VAL[$id]}" && avail="ready"
    names+=("${_MF_NAME[$id]}" "$avail")
  done

  local choice
  choice=$(zenity --list \
    --title="OSINT Frameworks v${SCRIPT_VERSION}" \
    --text="Select a framework to launch:" \
    --column="Framework" --column="Status" \
    "${names[@]}" \
    --width=400 --height=300 2>/dev/null) || return 0
  [ -z "${choice:-}" ] && return 0

  # Map display name back to ID and run
  for id in "${_MF_IDS[@]}"; do
    if [ "${_MF_NAME[$id]}" = "$choice" ]; then
      if ! tool_available "${_MF_CHECK_VAL[$id]}"; then
        zenity --warning --text="${_MF_NAME[$id]} is not installed." --width=300 2>/dev/null
        return 0
      fi
      _session_log "Launching framework: ${_MF_NAME[$id]}"
      printf "\n  ${C_PURPLE}${BOLD}>  FRAMEWORK${RESET}  ${C_GRAY}%s${RESET}\n" "${_MF_NAME[$id]}"

      local session_dir
      session_dir=$(create_session_dir "frameworks")
      run_manifest_tool "$id" "" "$session_dir"
      break
    fi
  done
}

main
