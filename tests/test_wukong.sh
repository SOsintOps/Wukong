#!/usr/bin/env bash
###############################################################################
## test_wukong.sh — Validate Wukong china/kyc manifest + spokes
## Runs without Zenity, OSINT tools, or network access (static validation).
## Complements the on-VM end-to-end run of wukong_install.sh.
###############################################################################

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PASS=0; FAIL=0; TOTAL=0

_test() {
  local name="$1" expected="$2" actual="$3"
  ((TOTAL++))
  if [ "$expected" = "$actual" ]; then
    printf "  \033[32m✔\033[0m  %s\n" "$name"
    ((PASS++))
  else
    printf "  \033[31m✖\033[0m  %s\n" "$name"
    printf "       expected: '%s'\n" "$expected"
    printf "       actual:   '%s'\n" "$actual"
    ((FAIL++))
  fi
}

echo ""
echo "═══════════════════════════════════════════════════"
echo "  Wukong Tests — china / kyc manifest + spokes"
echo "═══════════════════════════════════════════════════"
echo ""

###############################################################################
echo "── 1. Source common.sh ──"
###############################################################################

SCRIPT_NAME="TEST"
SCRIPT_VERSION="0.0.0"
VERBOSE=false
source "$SCRIPT_DIR/scripts/lib/common.sh" 2>/dev/null
_test "common.sh sources without error" "0" "$?"
_test "_COMMON_SH_LOADED is set" "1" "${_COMMON_SH_LOADED:-0}"
_test "PROGRAMS_DIR rebranded to wukong" "$HOME/.local/share/wukong/programs" "$PROGRAMS_DIR"
_test "TOOLS_CONF points to existing file" "true" "$([ -f "$TOOLS_CONF" ] && echo true || echo false)"

###############################################################################
echo ""
echo "── 2. load_manifest(): china ──"
###############################################################################

load_manifest "china"
china_count=${#_MF_IDS[@]}
_test "china category loads tools" "true" "$([ "$china_count" -gt 0 ] && echo true || echo false)"
_test "china tool count = 7" "7" "$china_count"
_test "china has fofax" "Fofax (FOFA)" "${_MF_NAME[fofax]:-missing}"
_test "china has quake" "Quake (360)" "${_MF_NAME[quake]:-missing}"
_test "china has youget" "You-get (info)" "${_MF_NAME[youget]:-missing}"
_test "china has snscrape-weibo" "snscrape (Weibo user)" "${_MF_NAME[snscrape-weibo]:-missing}"
_test "china has pydork-baidu" "PyDork (Baidu)" "${_MF_NAME[pydork-baidu]:-missing}"
_test "china has shuize" "ShuiZe (domain recon)" "${_MF_NAME[shuize]:-missing}"

###############################################################################
echo ""
echo "── 3. load_manifest(): kyc ──"
###############################################################################

load_manifest "kyc"
kyc_count=${#_MF_IDS[@]}
_test "kyc tool count = 1" "1" "$kyc_count"
_test "kyc has enscan" "ENScan_GO (company)" "${_MF_NAME[enscan]:-missing}"

###############################################################################
echo ""
echo "── 4. Manifest field integrity (china + kyc) ──"
###############################################################################

for cat in china kyc; do
  load_manifest "$cat"
  for id in "${_MF_IDS[@]}"; do
    _test "$cat/$id has check_type" "true" "$([ -n "${_MF_CHECK_TYPE[$id]:-}" ] && echo true || echo false)"
    _test "$cat/$id has check_val"  "true" "$([ -n "${_MF_CHECK_VAL[$id]:-}"  ] && echo true || echo false)"
    _test "$cat/$id has cmd"        "true" "$([ -n "${_MF_CMD[$id]:-}"        ] && echo true || echo false)"
    _test "$cat/$id cmd uses {target}" "true" "$([[ "${_MF_CMD[$id]:-}" == *'{target}'* ]] && echo true || echo false)"
  done
done

###############################################################################
echo ""
echo "── 5. Validated command templates (regression lock) ──"
###############################################################################

load_manifest "china"
# pydork: engine via -t, query after -- (positional 'baidu' was a bug)
_test "pydork uses -t baidu"      "true" "$([[ "${_MF_CMD[pydork-baidu]}" == *'-t baidu'* ]] && echo true || echo false)"
_test "pydork uses -- separator"  "true" "$([[ "${_MF_CMD[pydork-baidu]}" == *' -- {target}'* ]] && echo true || echo false)"
# fofax: -q query flag + stdout redirect
_test "fofax uses -q query"       "true" "$([[ "${_MF_CMD[fofax]}" == *'-q {target}'* ]] && echo true || echo false)"
# snscrape: weibo-user module, --jsonl global before subcommand
_test "snscrape weibo-user module" "true" "$([[ "${_MF_CMD[snscrape-weibo]}" == *'--jsonl weibo-user {target}'* ]] && echo true || echo false)"
# ShuiZe: passive info-gathering only (no active vuln scan)
_test "shuize is passive (justInfoGather)" "true" "$([[ "${_MF_CMD[shuize]}" == *'--justInfoGather 1'* ]] && echo true || echo false)"
load_manifest "kyc"
# ENScan: output routed into the evidence session dir
_test "enscan outputs to {outdir}" "true" "$([[ "${_MF_CMD[enscan]}" == *'-o {outdir}'* ]] && echo true || echo false)"

###############################################################################
echo ""
echo "── 6. Spokes wired correctly ──"
###############################################################################

china_sh="$SCRIPT_DIR/scripts/china.sh"
kyc_sh="$SCRIPT_DIR/scripts/kyc.sh"
_test "china.sh sources common.sh"   "1" "$(grep -c '^source.*common.sh' "$china_sh")"
_test "china.sh calls run_category china" "true" "$(grep -q 'run_category "china"' "$china_sh" && echo true || echo false)"
_test "kyc.sh sources common.sh"     "1" "$(grep -c '^source.*common.sh' "$kyc_sh")"
_test "kyc.sh calls run_category kyc" "true" "$(grep -q 'run_category "kyc"' "$kyc_sh" && echo true || echo false)"

###############################################################################
echo ""
echo "── 6. Frameworks: Quaesitor and Flowsint ──"
###############################################################################

load_manifest "frameworks"
_test "frameworks tool count = 6" "6" "${#_MF_IDS[@]}"
_test "frameworks has quaesitor" "Quaesitor" "${_MF_NAME[quaesitor]:-missing}"
_test "frameworks has flowsint" "Flowsint" "${_MF_NAME[flowsint]:-missing}"
_test "manifest_tool_ready exists" "function" "$(type -t manifest_tool_ready)"
installer="$SCRIPT_DIR/wukong_install.sh"
for _t in quaesitor flowsint; do
  _test "scripts/$_t.sh exists and is executable" "true" "$([ -x "$SCRIPT_DIR/scripts/$_t.sh" ] && echo true || echo false)"
  _test "installer clones $_t" "true" "$(grep -qE "/$_t(\\.git)?\"" "$installer" && echo true || echo false)"
done
for _pkg in tesseract-ocr tesseract-ocr-chi-sim tesseract-ocr-chi-tra python3-icu; do
  _test "installer package list has $_pkg (Quaesitor OCR/transliteration)" "true"     "$(grep -qE "(^|[[:space:]])$_pkg([[:space:]]|$)" "$installer" && echo true || echo false)"
done
_test "installer installs the manifest next to the scripts" "true" \
  "$(grep -q 'cp "$_REPO_DIR/config/tools.conf" "$REAL_HOME/.local/share/wukong/config/tools.conf"' "$installer" && echo true || echo false)"
_test "frameworks.sh launches in the foreground (launch_framework)" "true" \
  "$(grep -q '^launch_framework()' "$SCRIPT_DIR/scripts/frameworks.sh" && echo true || echo false)"
_test "installer installs ONLYOFFICE Desktop Editors" "true" \
  "$(grep -q 'apt install -y onlyoffice-desktopeditors' "$installer" && echo true || echo false)"
_test "ONLYOFFICE repository is signed-by a dedicated keyring" "true" \
  "$(grep -q 'signed-by=/etc/apt/keyrings/onlyoffice.gpg' "$installer" && echo true || echo false)"
_test "Firefox policies install 18 extensions" "18" \
  "$(grep -c '"installation_mode": "normal_installed"' "$SCRIPT_DIR/config/policies.json")"
_test "installer deploys the Brave extension policy" "true" \
  "$(grep -q 'config/brave-policies.json' "$installer" && echo true || echo false)"
_test "Brave policy force-installs 3 extensions" "3" \
  "$(grep -c 'clients2.google.com/service/update2/crx' "$SCRIPT_DIR/config/brave-policies.json")"

###############################################################################
# Summary
###############################################################################
echo ""
echo "═══════════════════════════════════════════════════"
printf "  \033[32m✔ %d passed\033[0m   \033[31m✖ %d failed\033[0m   (total: %d)\n" \
  "$PASS" "$FAIL" "$TOTAL"
echo "═══════════════════════════════════════════════════"
echo ""

[ "$FAIL" -eq 0 ] && exit 0 || exit 1
