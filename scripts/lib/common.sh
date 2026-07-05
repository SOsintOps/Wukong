#!/usr/bin/env bash
###############################################################################
## scripts/lib/common.sh — Shared library for Wukong OSINT launchers
## Version 0.1.0
## Source this file at the top of every launcher script.
## Set SCRIPT_NAME and SCRIPT_VERSION before sourcing.
###############################################################################

[[ -n "${_COMMON_SH_LOADED:-}" ]] && return 0
_COMMON_SH_LOADED=1

[ "${XDG_SESSION_TYPE:-}" = "wayland" ] && export GDK_BACKEND=x11
export PATH="$HOME/.local/bin:$PATH"

EVIDENCE_DIR="$HOME/Downloads/evidence"
PROGRAMS_DIR="$HOME/.local/share/wukong/programs"
COMMON_VERSION="0.1.0"

_REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
TOOLS_CONF="${_REPO_DIR}/config/tools.conf"

: "${SCRIPT_VERSION:=$COMMON_VERSION}"
: "${SCRIPT_NAME:=OSINT Tool}"
: "${VERBOSE:=false}"

###############################################################################
# ANSI palette
###############################################################################
RESET="\033[0m"; BOLD="\033[1m"; DIM="\033[2m"
C_CYAN="\033[38;5;39m";   C_YELLOW="\033[38;5;220m"; C_GREEN="\033[38;5;82m"
C_RED="\033[38;5;196m";   C_ORANGE="\033[38;5;214m"; C_PURPLE="\033[38;5;135m"
C_GRAY="\033[38;5;245m";  C_DGRAY="\033[38;5;238m";  C_BLUE="\033[38;5;75m"
COL_EMAIL="$C_CYAN"; COL_HASH="$C_YELLOW"; COL_USER="$C_GREEN"
COL_NAME="$C_BLUE"; COL_DOMAIN="$C_ORANGE"; COL_PHONE="$C_PURPLE"

###############################################################################
# Session log
###############################################################################
SESSION_LOG_FILE=""
SESSION_LOG_DIR=""
declare -A TOOL_STATUS=()
declare -A TOOL_DURATION=()
_session_log() {
  [ -z "$SESSION_LOG_FILE" ] && return
  (
    flock -x 9
    printf "[%s] %s\n" "$(date +'%Y-%m-%d %H:%M:%S')" "$*"
  ) 9>>"$SESSION_LOG_FILE"
}

###############################################################################
# Terminal output primitives
###############################################################################
_line() {
  local char="$1" len="${2:-62}" col="${3:-$C_DGRAY}"
  printf "${col}"; printf '%*s' "$len" '' | tr ' ' "$char"; printf "${RESET}\n"
}

print_banner() {
  local subtitle="${1:-email · username · fullname · hash}"
  clear; echo ""
  _line "=" 62 "$C_PURPLE"
  printf "${C_PURPLE}${BOLD}  %-46s${RESET}${C_DGRAY}%s${RESET}\n" \
    "${SCRIPT_NAME}  v${SCRIPT_VERSION}" "$(date +'%d/%m/%Y %H:%M')"
  printf "${C_GRAY}  %-58s${RESET}\n" "$subtitle"
  $VERBOSE && printf "  ${C_ORANGE}${BOLD}VERBOSE MODE${RESET}${C_GRAY} — live output active${RESET}\n"
  _line "=" 62 "$C_PURPLE"; echo ""
}

print_section_header() {
  local title="$1" sub="$2" col="${3:-$C_PURPLE}"
  echo ""; _line "-" 62 "$col"
  printf "${col}${BOLD}  %-58s${RESET}\n" "$title"
  printf "${C_GRAY}  %-58s${RESET}\n" "$sub"
  _line "-" 62 "$col"; echo ""
}

log_step() {
  local name="$1" stato="$2" extra="${3:-}"
  case "$stato" in
    run)  printf "  ${C_CYAN}*${RESET}  ${BOLD}%-22s${RESET} ${C_CYAN}running...${RESET}\n" "$name" ;;
    ok)   printf "  ${C_GREEN}+${RESET}  ${BOLD}%-22s${RESET} ${C_GREEN}done${RESET}${C_GRAY}%s${RESET}\n" \
            "$name" "$extra" ;;
    skip) printf "  ${C_ORANGE}o${RESET}  ${BOLD}%-22s${RESET} ${C_ORANGE}not available — skipped%s${RESET}\n" "$name" "$extra" ;;
    fail) printf "  ${C_RED}x${RESET}  ${BOLD}%-22s${RESET} ${C_RED}error%s${RESET}\n" "$name" "$extra" ;;
    info) printf "  ${C_GRAY}i${RESET}  ${C_GRAY}%s%s${RESET}\n" "$name" "$extra" ;;
  esac
  _session_log "[$stato] $name $extra"
}

log_result() {
  printf "  ${C_DGRAY}    > %s${RESET}\n" "$1"
  _session_log "  output: $1"
}

status_bar() {
  echo ""; _line "-" 62 "$C_DGRAY"
  printf "${C_GRAY}${DIM}  %-58s${RESET}\n" "$1"
  _line "-" 62 "$C_DGRAY"; echo ""
}

pause_ok() {
  echo ""; printf "  ${C_GREEN}${BOLD}>${RESET}  ${C_GRAY}(press ENTER to continue)${RESET} "
  read -r _
}

print_summary() {
  local ok=0 fail=0 skip=0
  echo ""; _line "=" 62 "$C_PURPLE"
  printf "${C_PURPLE}${BOLD}  SUMMARY${RESET}\n"; _line "-" 62 "$C_DGRAY"
  for label in "${!TOOL_STATUS[@]}"; do
    local st="${TOOL_STATUS[$label]}" dur="${TOOL_DURATION[$label]:-}"
    local dur_str=""; [ -n "$dur" ] && dur_str="  ${C_DGRAY}(${dur}s)${RESET}"
    case "$st" in
      ok)   printf "  ${C_GREEN}+${RESET}  %-26s%b\n" "$label" "$dur_str"; ((ok++)) ;;
      fail) printf "  ${C_RED}x${RESET}  %-26s%b\n"   "$label" "$dur_str"; ((fail++)) ;;
      skip) printf "  ${C_ORANGE}o${RESET}  %-26s\n"  "$label"; ((skip++)) ;;
    esac
  done
  _line "-" 62 "$C_DGRAY"
  printf "  ${C_GREEN}+ %d ok${RESET}   ${C_RED}x %d errors${RESET}   ${C_ORANGE}o %d skipped${RESET}\n" \
    "$ok" "$fail" "$skip"
  _line "=" 62 "$C_PURPLE"; echo ""
  TOOL_STATUS=(); TOOL_DURATION=()
}

_progress() {
  local cur="$1" tot="$2" label="$3"
  local filled=$(( cur * 20 / tot )) empty=$(( 20 - cur * 20 / tot ))
  local bar=""
  for ((i=0; i<filled; i++)); do bar+="X"; done
  for ((i=0; i<empty;  i++)); do bar+="."; done
  printf "\n  ${C_PURPLE}[%s]${RESET} ${C_GRAY}%d/%d${RESET}  ${BOLD}%s${RESET}\n\n" \
    "$bar" "$cur" "$tot" "$label"
}

###############################################################################
# Semantic error detection
###############################################################################
SEMANTIC_ERROR_PATTERNS=(
  "traceback" "exception" "error:" "fatal:" "errno" "failed to"
  "connection refused" "connection timed out" "unauthorized" "forbidden"
  "invalid api" "api key" "no such file" "permission denied"
  "segmentation fault" "module not found" "modulenotfounderror"
  "attributeerror" "nameerror" "syntaxerror"
  "no targets found in user input" "quitting"
)

_check_semantic_errors() {
  local combined; combined=$(cat "$1" "$2" 2>/dev/null)
  for pattern in "${SEMANTIC_ERROR_PATTERNS[@]}"; do
    echo "$combined" | grep -iq "$pattern" && { echo "$pattern"; return 0; }
  done
  return 1
}

_save_error_log() {
  local label="$1" rc="$2" out="$3" err="$4"
  [ -z "$SESSION_LOG_DIR" ] && return
  local lf="$SESSION_LOG_DIR/${label// /_}-error.log"
  { echo "=== $label === $(date +'%Y-%m-%d %H:%M:%S')"
    echo "Exit code: $rc"
    echo "--- stdout ---"; cat "$out"  2>/dev/null
    echo "--- stderr ---"; cat "$err"  2>/dev/null
  } >> "$lf"
  printf "  ${C_GRAY}    i error log: %s${RESET}\n" "$lf"
}

###############################################################################
# run_tool — execute a command, capture output, detect errors
###############################################################################
run_tool() {
  local label="$1" outfile="$2"; shift 2
  local out err rc=0 t_start t_end duration
  out="$(mktemp /tmp/osint_out_XXXXXX)"
  err="$(mktemp /tmp/osint_err_XXXXXX)"

  log_step "$label" "run"
  _session_log "[START] $label | $(date +'%H:%M:%S') | cmd: $*"
  t_start=$(date +%s)

  if $VERBOSE; then
    printf "  ${C_DGRAY}  +--- live output ---${RESET}\n"
    if [ "$outfile" = "-" ]; then
      "$@" 2>&1 | while IFS= read -r l; do
        printf "  ${C_DGRAY}  |${RESET} %s\n" "$l"; echo "$l" >> "$out"
      done; rc=${PIPESTATUS[0]}
    else
      "$@" 2>&1 | tee "$outfile" | while IFS= read -r l; do
        printf "  ${C_DGRAY}  |${RESET} %s\n" "$l"; echo "$l" >> "$out"
      done; rc=${PIPESTATUS[0]}
    fi
    printf "  ${C_DGRAY}  +---${RESET}\n"
  else
    if [ "$outfile" = "-" ]; then
      "$@" >"$out" 2>"$err" || rc=$?
    else
      "$@" >"$outfile" 2>"$err" || rc=$?
      cp "$outfile" "$out" 2>/dev/null || true
    fi
  fi

  t_end=$(date +%s); duration=$(( t_end - t_start ))

  if [ -n "${SESSION_LOG_FILE:-}" ]; then
    (
      flock -x 9
      [ -s "$out" ] && { printf "  [stdout]\n"; cat "$out"; printf "\n"; }
      [ -s "$err" ] && { printf "  [stderr]\n"; cat "$err"; printf "\n"; }
    ) 9>>"$SESSION_LOG_FILE"
  fi

  if [ $rc -ne 0 ]; then
    TOOL_STATUS["$label"]="fail"; TOOL_DURATION["$label"]="$duration"
    log_step "$label" "fail" "  (exit $rc, ${duration}s)"
    if [ -s "$err" ]; then
      printf "  ${C_RED}    +- stderr -${RESET}\n"
      head -10 "$err" | while IFS= read -r l; do
        printf "  ${C_RED}    |${RESET} %s\n" "$l"
      done
      printf "  ${C_RED}    +---${RESET}\n"
    fi
    _save_error_log "$label" "$rc" "$out" "$err"
    rm -f "$out" "$err"; return 1
  fi

  local sem_pat
  if sem_pat=$(_check_semantic_errors "$out" "$err"); then
    TOOL_STATUS["$label"]="fail"; TOOL_DURATION["$label"]="$duration"
    log_step "$label" "fail" "  (semantic: '${sem_pat}', ${duration}s)"
    printf "  ${C_RED}    +- semantic error -${RESET}\n"
    grep -i "$sem_pat" "$out" "$err" 2>/dev/null | head -5 | \
      while IFS= read -r l; do printf "  ${C_RED}    |${RESET} %s\n" "$l"; done
    printf "  ${C_RED}    +---${RESET}\n"
    _save_error_log "$label" "0(semantic:$sem_pat)" "$out" "$err"
    rm -f "$out" "$err"; return 1
  fi

  TOOL_STATUS["$label"]="ok"; TOOL_DURATION["$label"]="$duration"
  log_step "$label" "ok" "  (${duration}s)"
  if [ -s "$err" ]; then
    printf "  ${C_ORANGE}    +- warnings -${RESET}\n"
    head -5 "$err" | while IFS= read -r l; do
      printf "  ${C_ORANGE}    |${RESET}${C_GRAY} %s${RESET}\n" "$l"
    done
    printf "  ${C_ORANGE}    +---${RESET}\n"
  fi
  rm -f "$out" "$err"; return 0
}

###############################################################################
# Repo venv helpers
###############################################################################
repo_venv_python() {
  local d="$1" base; base="$(basename "$d")"
  for c in "$d/${base}Environment/bin/python" "$d/venv/bin/python" "$d/.venv/bin/python"; do
    [ -x "$c" ] && { echo "$c"; return 0; }
  done
  return 1
}
run_repo_python_tool() {
  local label="$1" repo_dir="$2" script="$3" outfile="$4"; shift 4
  if [ ! -d "$repo_dir" ]; then
    log_step "$label" "skip"; TOOL_STATUS["$label"]="skip"; return 1
  fi
  local pybin="python3"
  repo_venv_python "$repo_dir" >/dev/null 2>&1 && pybin="$(repo_venv_python "$repo_dir")"
  (
    cd "$repo_dir" || { log_step "$label" "fail" " (cd failed)"; exit 1; }
    run_tool "$label" "$outfile" "$pybin" "$script" "$@"
  )
  return $?
}

###############################################################################
# Tool availability
###############################################################################
MISSING_TOOLS=()

tool_available() {
  local t="$1"
  for m in "${MISSING_TOOLS[@]:-}"; do [ "$m" = "$t" ] && return 1; done
  command -v "$t" &>/dev/null
}

warn_unavailable() { log_step "$1" "skip"; TOOL_STATUS["$1"]="skip"; }

_avail() {
  local val="$1" type="${2:-cmd}"
  case "$type" in
    dir)  [ -d "$val" ]  && echo "ready" || echo "not installed" ;;
    file) [ -f "$val" ]  && echo "ready" || echo "not installed" ;;
    *)    tool_available "$val" && echo "ready" || echo "not installed" ;;
  esac
}

check_required_tools() {
  local -a req=("$@")
  local -a missing_list=()
  for t in "${req[@]}"; do
    command -v "$t" &>/dev/null || { MISSING_TOOLS+=("$t"); missing_list+=("  - $t"); }
  done
  [ ${#missing_list[@]} -eq 0 ] && return
  local msg="The following tools are not installed or not in PATH:\n\n"
  msg+="$(printf '%s\n' "${missing_list[@]}")"
  msg+="\n\nThe script will continue with reduced functionality."
  zenity --warning --title="Missing Tools" --text="$msg" --width=440 2>/dev/null
}

###############################################################################
# Session directory
###############################################################################
ensure_base_dir() { [ ! -d "$EVIDENCE_DIR" ] && mkdir -p "$EVIDENCE_DIR"; }

create_session_dir() {
  local target="$1" d="$EVIDENCE_DIR/$target"
  [ ! -d "$d" ] && mkdir -p "$d"
  SESSION_LOG_DIR="$d/logs"
  [ ! -d "$SESSION_LOG_DIR" ] && mkdir -p "$SESSION_LOG_DIR"
  local ts; ts="$(date +'%Y%m%d-%H%M%S')"
  SESSION_LOG_FILE="$SESSION_LOG_DIR/session-${ts}.log"
  { echo "========================================"
    echo " ${SCRIPT_NAME} v${SCRIPT_VERSION}"
    echo " Session: $(date +'%Y-%m-%d %H:%M:%S')"
    echo " Target:  $target"
    echo "========================================"
  } > "$SESSION_LOG_FILE"
  echo "$d"
}

###############################################################################
# Manifest loading — reads config/tools.conf for a given category
###############################################################################
declare -A _MF_NAME=()
declare -A _MF_CHECK_TYPE=()
declare -A _MF_CHECK_VAL=()
declare -A _MF_CMD=()
declare -A _MF_OUTPUT_EXT=()
declare -A _MF_VENV=()
declare -A _MF_VENV_NAME=()
_MF_IDS=()

load_manifest() {
  local category="$1"
  _MF_IDS=()
  _MF_NAME=(); _MF_CHECK_TYPE=(); _MF_CHECK_VAL=()
  _MF_CMD=(); _MF_OUTPUT_EXT=(); _MF_VENV=(); _MF_VENV_NAME=()

  [ ! -f "$TOOLS_CONF" ] && return 1

  while IFS='|' read -r name id cat check_type check_value \
      cmd output_ext venv venv_name; do
    [[ "$name" =~ ^#.*$ || -z "$name" ]] && continue
    [ "$cat" != "$category" ] && continue
    _MF_IDS+=("$id")
    _MF_NAME["$id"]="$name"
    _MF_CHECK_TYPE["$id"]="$check_type"
    _MF_CHECK_VAL["$id"]="$check_value"
    _MF_CMD["$id"]="$cmd"
    _MF_OUTPUT_EXT["$id"]="$output_ext"
    _MF_VENV["$id"]="$venv"
    _MF_VENV_NAME["$id"]="$venv_name"
  done < "$TOOLS_CONF"
}

###############################################################################
# Zenity checklist from loaded manifest
###############################################################################
zenity_checklist() {
  local title="$1" text="$2"
  local -a zargs=()
  for id in "${_MF_IDS[@]}"; do
    local ct="${_MF_CHECK_TYPE[$id]}" cv="${_MF_CHECK_VAL[$id]}" status
    case "$ct" in
      repo) status="$(_avail "$PROGRAMS_DIR/$cv" dir)" ;;
      *)    status="$(_avail "$cv")" ;;
    esac
    zargs+=(FALSE "$id" "${_MF_NAME[$id]}" "$status")
  done
  zenity --list --checklist \
    --title="$title" --text="$text" \
    --column="Run" --column="ID" --column="Tool" --column="Status" \
    "${zargs[@]}" \
    --separator=":" --print-column=2 --hide-column=2 \
    --width=500 --height=400 2>/dev/null
}

###############################################################################
# Run a single tool from the loaded manifest
###############################################################################
run_manifest_tool() {
  local id="$1" target="$2" session_dir="$3"
  local name="${_MF_NAME[$id]}"
  local check_type="${_MF_CHECK_TYPE[$id]}"
  local check_val="${_MF_CHECK_VAL[$id]}"
  local cmd_tpl="${_MF_CMD[$id]}"
  local output_ext="${_MF_OUTPUT_EXT[$id]}"

  # Availability check
  case "$check_type" in
    repo) [ ! -d "$PROGRAMS_DIR/$check_val" ] && { warn_unavailable "$name"; return 1; } ;;
    *)    command -v "$check_val" &>/dev/null || { warn_unavailable "$name"; return 1; } ;;
  esac

  # Build output file path
  local safe="${target// /_}"
  safe="${safe//[^a-zA-Z0-9._@+-]/}"
  local outfile="$session_dir/${safe}-${id}.${output_ext}"

  # Detect stdout redirection in template before expansion: "cmd ... > path"
  local rt_tpl="-" cmd_work="$cmd_tpl"
  if [[ "$cmd_work" =~ ^(.+)[[:space:]]\>[[:space:]](.+)$ ]]; then
    cmd_work="${BASH_REMATCH[1]}"
    rt_tpl="${BASH_REMATCH[2]}"
  fi

  # Split template into array BEFORE substituting values (templates have no spaces
  # in placeholders, so word splitting is safe on the template itself)
  local -a parts
  read -ra parts <<< "$cmd_work"
  [ ${#parts[@]} -eq 0 ] && return 1

  # Expand placeholders in each array element (preserves spaces in values)
  local i
  for i in "${!parts[@]}"; do
    parts[$i]="${parts[$i]//\{target\}/$target}"
    parts[$i]="${parts[$i]//\{outfile\}/$outfile}"
    parts[$i]="${parts[$i]//\{outdir\}/$session_dir}"
    parts[$i]="${parts[$i]//\{programs_dir\}/$PROGRAMS_DIR}"
    parts[$i]="${parts[$i]//\$HOME/$HOME}"
  done

  # Expand redirection path
  local rt_outfile="$rt_tpl"
  if [ "$rt_outfile" != "-" ]; then
    rt_outfile="${rt_outfile//\{target\}/$target}"
    rt_outfile="${rt_outfile//\{outfile\}/$outfile}"
    rt_outfile="${rt_outfile//\{outdir\}/$session_dir}"
    rt_outfile="${rt_outfile//\$HOME/$HOME}"
  fi

  # Prompt for any remaining {placeholder} values (e.g. {session_id})
  for i in "${!parts[@]}"; do
    while [[ "${parts[$i]}" =~ \{([a-z_]+)\} ]]; do
      local ph="${BASH_REMATCH[0]}" ph_label="${BASH_REMATCH[1]}"
      local val
      val=$(zenity --entry --title="$ph_label" \
        --text="Enter ${ph_label} for ${target}:" \
        --width=400 2>/dev/null) || { warn_unavailable "$name"; return 1; }
      [ -z "$val" ] && { warn_unavailable "$name"; return 1; }
      parts[$i]="${parts[$i]//$ph/$val}"
    done
  done

  local rc=0

  if [ "$check_type" = "repo" ]; then
    local repo_dir="$PROGRAMS_DIR/$check_val"
    if [ "${parts[0]}" = "python3" ] && [ ${#parts[@]} -ge 2 ]; then
      run_repo_python_tool "$name" "$repo_dir" "${parts[1]}" "$rt_outfile" "${parts[@]:2}"
      rc=$?
    else
      (
        cd "$repo_dir" || { log_step "$name" "fail" " (cd failed)"; exit 1; }
        run_tool "$name" "$rt_outfile" "${parts[@]}"
      )
      rc=$?
    fi
  else
    run_tool "$name" "$rt_outfile" "${parts[@]}"
    rc=$?
  fi

  # Report result path
  if [ $rc -eq 0 ]; then
    local result="$session_dir"
    [ "$rt_outfile" != "-" ] && [ -f "$rt_outfile" ] && result="$rt_outfile"
    [ -f "$outfile" ] && result="$outfile"
    log_result "$result"
    [ -f "$result" ] && xdg-open "$result" >/dev/null 2>&1 &
  fi

  return $rc
}

###############################################################################
# run_category — generic end-to-end flow for any tool category
###############################################################################
run_category() {
  local category="$1" target="$2" title="$3" color="$4"
  local parallel="${5:-false}"

  ensure_base_dir
  local safe="${target// /_}"
  local session_dir
  session_dir="$(create_session_dir "$safe")"
  print_section_header "$title" "Target: $target" "$color"

  load_manifest "$category"
  if [ ${#_MF_IDS[@]} -eq 0 ]; then
    log_step "No tools configured for '$category'" "info"
    pause_ok; return
  fi

  local sel
  sel=$(zenity_checklist "$title — $target" "Select tools to run:") || return
  [ -z "$sel" ] && return

  TOOL_STATUS=(); TOOL_DURATION=()
  IFS=':' read -ra selected <<< "$sel"
  _session_log "Selected: ${selected[*]}"
  local total=${#selected[@]} cur=0

  if [ "$parallel" = "true" ] && [ "$total" -gt 1 ]; then
    _session_log "Parallel mode: launching $total tools"
    local -a pids=()
    local -a status_files=()
    local status_dir; status_dir="$(mktemp -d /tmp/osint_parallel_XXXXXX)"

    for id in "${selected[@]}"; do
      ((cur++))
      local name="${_MF_NAME[$id]}"
      local sf="$status_dir/${id}.status"
      log_step "$name" "run"
      (
        run_manifest_tool "$id" "$target" "$session_dir"
        echo "$?|${TOOL_STATUS[$name]:-unknown}|${TOOL_DURATION[$name]:-0}" > "$sf"
      ) &
      pids+=($!)
      status_files+=("$id:$sf")
    done

    printf "\n  ${C_GRAY}Waiting for %d tools to complete...${RESET}\n" "$total"

    for pid in "${pids[@]}"; do
      wait "$pid" 2>/dev/null || true
    done

    for entry in "${status_files[@]}"; do
      local id="${entry%%:*}" sf="${entry#*:}"
      local name="${_MF_NAME[$id]}"
      if [ -f "$sf" ]; then
        IFS='|' read -r _rc _st _dur < "$sf"
        TOOL_STATUS["$name"]="${_st:-fail}"
        TOOL_DURATION["$name"]="${_dur:-0}"
      else
        TOOL_STATUS["$name"]="fail"
      fi
    done

    rm -rf "$status_dir"
  else
    for id in "${selected[@]}"; do
      ((cur++))
      _progress $cur $total "${_MF_NAME[$id]}"
      run_manifest_tool "$id" "$target" "$session_dir"
    done
  fi

  status_bar "Done -> $session_dir"
  print_summary
  pause_ok
}
