#!/usr/bin/env bash
################################################################################
## OSINT Frameworks — Spoke Script
## Version 0.2.0 - Interactive frameworks run in the foreground of the terminal
################################################################################

set -uo pipefail

SCRIPT_NAME="OSINT FRAMEWORKS"
SCRIPT_VERSION="0.2.0"
VERBOSE=false
[[ "${1:-}" == "-v" || "${1:-}" == "--verbose" ]] && VERBOSE=true

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

# launch_framework ID: run a framework from the loaded manifest in this terminal.
# Frameworks are interactive (prompts, menus, web servers), so their output is
# not captured: the analyst works with them directly.
launch_framework() {
  local id="$1" cmd="${_MF_CMD[$1]}" dir="" pybin
  cmd="${cmd//\$HOME/$HOME}"
  cmd="${cmd//\{programs_dir\}/$PROGRAMS_DIR}"
  local -a parts
  read -ra parts <<< "$cmd"
  if [ "${_MF_CHECK_TYPE[$id]}" = "repo" ]; then
    dir="$PROGRAMS_DIR/${_MF_CHECK_VAL[$id]}"
    if [ "${parts[0]}" = "python3" ] && pybin="$(repo_venv_python "$dir")"; then
      parts[0]="$pybin"
    fi
  fi
  _session_log "Launching framework: ${_MF_NAME[$id]} | cmd: ${parts[*]}"
  printf "\n  ${C_PURPLE}${BOLD}>  FRAMEWORK${RESET}  ${C_GRAY}%s${RESET}\n\n" "${_MF_NAME[$id]}"
  if [ -n "$dir" ]; then
    (cd "$dir" || exit 1; "${parts[@]}")
  else
    "${parts[@]}"
  fi
}

main() {
  print_banner "recon-ng · sn0int · changedetection · maigret web · quaesitor · flowsint"
  ensure_base_dir

  load_manifest "frameworks"
  if [ ${#_MF_IDS[@]} -eq 0 ]; then
    zenity --error --text="No framework tools found in manifest." --width=300 2>/dev/null
    return 1
  fi

  local -a rows=()
  local id status
  for id in "${_MF_IDS[@]}"; do
    status="not installed"
    manifest_tool_ready "$id" && status="ready"
    rows+=("$id" "${_MF_NAME[$id]}" "$status")
  done

  local choice
  choice=$(zenity --list \
    --title="OSINT Frameworks v${SCRIPT_VERSION}" \
    --text="Select a framework to launch:" \
    --column="ID" --column="Framework" --column="Status" \
    "${rows[@]}" --print-column=1 --hide-column=1 \
    --width=420 --height=320 2>/dev/null) || return 0
  [ -z "${choice:-}" ] && return 0

  if ! manifest_tool_ready "$choice"; then
    zenity --warning --text="${_MF_NAME[$choice]} is not installed." --width=300 2>/dev/null
    return 0
  fi
  create_session_dir "frameworks" >/dev/null
  launch_framework "$choice"
  pause_ok
}

[[ "${BASH_SOURCE[0]}" == "$0" ]] && main "$@"
