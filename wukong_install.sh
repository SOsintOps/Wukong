#!/usr/bin/env bash

# ###############################################################
# # WUKONG (悟空) - CHINA OSINT VM INSTALLATION SCRIPT
# # Version: 0.1.0
# # Target:  Debian 13 "Trixie" (amd64)
# # A China-focused OSINT spinoff of the Speculator Project.
# # Adds: full CJK stack (fonts + fcitx5 IME + zh locales),
# #       Chinese cyberspace/social tooling and corporate KYC tools.
# # Language Support: English, Italian, Chinese (Simplified + Traditional)
# ###############################################################
#
# USAGE:
#   sudo ./wukong_install.sh              # Normal installation
#   sudo ./wukong_install.sh --dry-run    # Simulate without installing
# ###############################################################


# ---------------------------------------------------------------
# ARGUMENT PARSING
# ---------------------------------------------------------------
DRY_RUN=false
for _arg in "$@"; do
    case "$_arg" in
        --dry-run) DRY_RUN=true ;;
        --help|-h)
            echo "Usage: sudo $0 [--dry-run]"
            echo "  --dry-run   Simulate installation without making any changes."
            exit 0
            ;;
    esac
done


# ---------------------------------------------------------------
# USER DETECTION (sudo-safe)
# When invoked via sudo, target the invoking user, not root.
# ---------------------------------------------------------------
if [ -n "${SUDO_USER:-}" ]; then
    REAL_USER="$SUDO_USER"
    REAL_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
else
    REAL_USER="${USER:-$(id -un)}"
    REAL_HOME="${HOME:-$(getent passwd "$(id -un)" | cut -d: -f6)}"
fi


# ---------------------------------------------------------------
# XDG-COMPLIANT DIRECTORY STRUCTURE
# ---------------------------------------------------------------
PROGRAMS_DIR="$REAL_HOME/.local/share/wukong/programs"
LOG_DIR="$REAL_HOME/Downloads"
SCRIPTS_DIR="$REAL_HOME/.local/share/wukong/scripts"
ICONS_DIR="$REAL_HOME/.local/share/icons/wukong"
DESKTOP_DIR="$REAL_HOME/.local/share/applications"
CONFIG_DIR="$REAL_HOME/.config/wukong"
LOG_FILE="$LOG_DIR/install_$(date +%Y-%m-%d_%H-%M-%S).log"
_REPO_DIR="$(cd "$(dirname "$0")" && pwd)"


# ---------------------------------------------------------------
# DRY-RUN MODE
# When --dry-run is active, dangerous commands are intercepted and
# printed instead of executed. Safe read-only operations run normally
# so logic flow can be validated.
# ---------------------------------------------------------------
if [ "$DRY_RUN" = "true" ]; then
    echo ""
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║  DRY-RUN MODE — No changes will be made to the system   ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo ""

    # Override run_as_user: print the command instead of running it
    run_as_user() { echo "  [DRY-RUN | user:${REAL_USER}] $*"; }

    # Override sudo: print system-level commands
    sudo() { echo "  [DRY-RUN | sudo] $*"; }

    # Override pipx, git, go, flatpak, wget, curl (for download side-effects)
    pipx()     { echo "  [DRY-RUN | pipx] $*"; }
    git()      { echo "  [DRY-RUN | git] $*"; }
    go()       { echo "  [DRY-RUN | go] $*"; }
    flatpak()  { echo "  [DRY-RUN | flatpak] $*"; }
    wget()     { echo "  [DRY-RUN | wget] $*"; }
    curl()     { echo "  [DRY-RUN | curl] $*"; }
    gsettings(){ echo "  [DRY-RUN | gsettings] $*"; }
    systemctl(){ echo "  [DRY-RUN | systemctl] $*"; }
    pkill()    { echo "  [DRY-RUN | pkill] $*"; }
    chown()    { echo "  [DRY-RUN | chown] $*"; }
    cp()       { echo "  [DRY-RUN | cp] $*"; }
    mkdir()    { echo "  [DRY-RUN | mkdir] $*"; }

    # mark_ok/mark_fail still work normally — tracking is always active
    # gnome-shell/pgrep run normally so version detection can be tested
fi


# ---------------------------------------------------------------
# DEBIAN DETECTION
# Exits immediately if the system is not Debian-based.
# ---------------------------------------------------------------
check_debian() {
    if [ ! -f /etc/debian_version ]; then
        if [ "$DRY_RUN" = "true" ]; then
            echo "[DRY-RUN] WARNING: /etc/debian_version not found."
            echo "[DRY-RUN] On a real run this would abort. Continuing simulation..."
            return 0
        fi
        echo ""
        echo "##################################################################"
        echo "# ERROR: Non-Debian system detected.                            #"
        echo "# The Wukong Project is designed exclusively for Debian.    #"
        echo "# Please install on Debian 13 'Trixie' (amd64).                #"
        echo "##################################################################"
        echo ""
        exit 1
    fi

    local debian_version
    debian_version=$(cat /etc/debian_version)
    echo "--> Debian detected: $debian_version"

    # Warn if not Trixie (13.x), but continue — allows bookworm (12.x) users to try
    if [[ "$debian_version" != 13* ]] && [[ "$debian_version" != "trixie"* ]]; then
        echo ""
        echo "WARNING: This script targets Debian 13 'Trixie'."
        echo "WARNING: Detected version: $debian_version"
        echo "WARNING: Some packages may not be available. Proceeding in 5s..."
        echo ""
        [ "$DRY_RUN" = "false" ] && sleep 5
    fi
}


# ---------------------------------------------------------------
# HELPER: Run a command as the real (non-root) user
# ---------------------------------------------------------------
run_as_user() {
    if [ "$(id -u)" -eq 0 ] && [ "$REAL_USER" != "root" ]; then
        sudo -u "$REAL_USER" -- "$@"
    else
        "$@"
    fi
}


# ---------------------------------------------------------------
# INSTALLATION TRACKING
# Records which components installed successfully and which failed.
# ---------------------------------------------------------------
_INSTALL_OK=()
_INSTALL_FAIL=()

mark_ok()   { _INSTALL_OK+=("$1"); }
mark_fail() { _INSTALL_FAIL+=("$1"); echo "FAIL: $1"; }

# Run a command and record result under a given label.
# Usage: tracked "label" command [args...]
tracked() {
    local label="$1"; shift
    if "$@" 2>&1; then
        mark_ok "$label"
    else
        mark_fail "$label"
    fi
}


# ---------------------------------------------------------------
# HELPER: Install a Python tool from a Git repository
# Uses a dedicated venv per tool; does NOT require venv activation
# ---------------------------------------------------------------
install_py_tool_from_git() {
    local repo_url="$1"
    local req_filename="${2:-requirements.txt}"
    local tool_name
    tool_name=$(basename "$repo_url" .git)
    local tool_dir="$PROGRAMS_DIR/$tool_name"
    local venv_dir="$tool_dir/${tool_name}Environment"

    echo "--> Installing $tool_name..."

    if [ ! -d "$tool_dir" ]; then
        if ! run_as_user git clone "$repo_url" "$tool_dir"; then
            echo "WARNING: Failed to clone $tool_name. Skipping."
            mark_fail "git:$tool_name"
            return 0
        fi
    else
        echo "    $tool_name already cloned, skipping clone."
    fi

    # Locate requirements file (up to 3 levels deep)
    local full_req_path
    full_req_path=$(find "$tool_dir" -maxdepth 3 -name "$req_filename" -print -quit 2>/dev/null)

    if [ -z "$full_req_path" ]; then
        # Fallback: if setup.py exists, install via pip install -e .
        if [ -f "$tool_dir/setup.py" ]; then
            echo "    No '$req_filename' found; trying pip install -e . (setup.py detected)..."
            if ! run_as_user python3 -m venv --system-site-packages "$venv_dir"; then
                echo "WARNING: Failed to create venv for $tool_name."
                mark_fail "git:$tool_name"
                return 0
            fi
            if run_as_user "$venv_dir/bin/pip" install --quiet -e "$tool_dir"; then
                mark_ok "git:$tool_name"
            else
                echo "WARNING: pip install -e . failed for $tool_name (non-fatal)."
                mark_fail "git:$tool_name"
            fi
        elif [ -f "$tool_dir/pyproject.toml" ]; then
            echo "    No '$req_filename' found; trying pip install . (pyproject.toml detected)..."
            if ! run_as_user python3 -m venv --system-site-packages "$venv_dir"; then
                echo "WARNING: Failed to create venv for $tool_name."
                mark_fail "git:$tool_name"
                return 0
            fi
            if run_as_user "$venv_dir/bin/pip" install --quiet "$tool_dir"; then
                mark_ok "git:$tool_name"
            else
                echo "WARNING: pip install . failed for $tool_name (non-fatal)."
                mark_fail "git:$tool_name"
            fi
        else
            echo "WARNING: '$req_filename' not found in $tool_name. Skipping pip install."
            mark_fail "git:$tool_name"
        fi
        return 0
    fi

    # Create venv and install dependencies (no activation needed — use venv pip directly)
    if ! run_as_user python3 -m venv --system-site-packages "$venv_dir"; then
        echo "WARNING: Failed to create venv for $tool_name."
        mark_fail "git:$tool_name"
        return 0
    fi

    if run_as_user "$venv_dir/bin/pip" install --quiet -r "$full_req_path"; then
        mark_ok "git:$tool_name"
    else
        echo "WARNING: pip install failed for $tool_name (non-fatal)."
        mark_fail "git:$tool_name"
    fi
}


# ---------------------------------------------------------------
# HELPER: install_network_circumvention
#   Circumvention tier of the network layer: Xray-core (modern
#   v2ray-core, XTLS/Xray-core) + mihomo (Clash.Meta, MetaCubeX/mihomo)
#   from GitHub release binaries into /usr/local/bin. Engine only —
#   server/config and mainland endpoint are supplied by the analyst
#   at runtime, never committed. Respects --dry-run.
#   Uses echo + mark_ok/mark_fail (installer has no log_* helpers).
# ---------------------------------------------------------------
install_network_circumvention() {
    echo "--> Installing circumvention engines (Xray-core + mihomo)..."

    # --- architecture ---
    local arch dl_arch
    arch="$(uname -m)"
    case "$arch" in
        x86_64|amd64)  dl_arch="64" ;;        # Xray uses "64" for amd64
        aarch64|arm64) dl_arch="arm64-v8a" ;;
        *) echo "INFO: arch $arch unsupported for Xray/mihomo; skipping."
           mark_fail "bin:xray"; mark_fail "bin:mihomo"; return 0 ;;
    esac

    if [ "$DRY_RUN" = "true" ]; then
        echo "  [DRY-RUN] would download Xray-core + mihomo (arch $arch) into /usr/local/bin"
        return 0
    fi

    local tmp; tmp="$(mktemp -d)"

    # --- Xray-core (XTLS/Xray-core) — stable asset name Xray-linux-<arch>.zip ---
    local xray_url="https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-${dl_arch}.zip"
    if curl -fsSL "$xray_url" -o "$tmp/xray.zip"; then
        unzip -o "$tmp/xray.zip" -d "$tmp/xray" >/dev/null
        install -m 0755 "$tmp/xray/xray" /usr/local/bin/xray
        echo "    xray installed: $(/usr/local/bin/xray version 2>/dev/null | head -1)"
        mark_ok "bin:xray"
    else
        echo "WARNING: Xray-core download failed (network/asset name?), skipping."
        mark_fail "bin:xray"
    fi

    # --- mihomo (MetaCubeX/mihomo, Clash.Meta) ---
    # Asset uses amd64/arm64 and carries the version in the filename, so the
    # 'latest' tag is resolved via the API and the URL is built from it.
    # grep -oE (not -oP) to match the installer's minimal-grep convention.
    local mh_arch mh_tag mh_url
    case "$arch" in
        x86_64|amd64)  mh_arch="amd64" ;;
        aarch64|arm64) mh_arch="arm64" ;;
    esac
    mh_tag="$(curl -fsSL https://api.github.com/repos/MetaCubeX/mihomo/releases/latest \
              | grep -oE '"tag_name":[[:space:]]*"[^"]+"' | head -1 | cut -d'"' -f4)"
    if [ -n "$mh_tag" ]; then
        mh_url="https://github.com/MetaCubeX/mihomo/releases/download/${mh_tag}/mihomo-linux-${mh_arch}-${mh_tag}.gz"
        if curl -fsSL "$mh_url" -o "$tmp/mihomo.gz"; then
            gunzip -f "$tmp/mihomo.gz"
            install -m 0755 "$tmp/mihomo" /usr/local/bin/mihomo
            echo "    mihomo installed: $(/usr/local/bin/mihomo -v 2>/dev/null | head -1)"
            mark_ok "bin:mihomo"
        else
            echo "WARNING: mihomo download failed (asset name?), skipping."
            mark_fail "bin:mihomo"
        fi
    else
        echo "WARNING: could not resolve mihomo tag via API, skipping."
        mark_fail "bin:mihomo"
    fi

    rm -rf "$tmp"
}


# ===============================================================
# PRE-FLIGHT CHECKS
# ===============================================================
check_debian

# Create all required directories before redirecting output
# In dry-run the log dir must still exist for tee to work
command mkdir -p "$LOG_DIR" "$PROGRAMS_DIR" "$SCRIPTS_DIR" "$ICONS_DIR" "$DESKTOP_DIR" "$CONFIG_DIR"

# Fix ownership if directories were created as root
if [ "$(id -u)" -eq 0 ] && [ "$REAL_USER" != "root" ]; then
    chown -R "$REAL_USER:$REAL_USER" \
        "$REAL_HOME/.local" \
        "$REAL_HOME/.config" \
        "$PROGRAMS_DIR" 2>/dev/null || true
fi

# Start logging — everything below is captured to the log file
exec > >(tee -a "$LOG_FILE") 2>&1

{
    echo "#################################################################"
    echo "# WUKONG (悟空) - CHINA OSINT VM INSTALLATION SCRIPT v0.1.0      #"
    echo "# Target: Debian 13 Trixie (amd64)                             #"
    echo "#################################################################"
    echo "# Real user : $REAL_USER"
    echo "# Home      : $REAL_HOME"
    echo "# Programs  : $PROGRAMS_DIR"
    echo "# Log       : $LOG_FILE"
    echo "#################################################################"
    echo ""


    # ###############################################################
    # PHASE 1: SYSTEM PREPARATION
    # ###############################################################
    echo "--- PHASE 1: System Preparation and Dependencies ---"
    echo "    [師傅] Blade of Grass, before the guest arrives we sweep the house and align its chi."

    sudo apt update

    # ---------------------------------------------------------------
    # VirtualBox Guest Additions — PREREQUISITE (manual install)
    # Must be installed by the user BEFORE running this script.
    # VirtualBox menu > Devices > Insert Guest Additions CD image...
    # then: sudo mount /dev/cdrom /mnt && sudo sh /mnt/VBoxLinuxAdditions.run
    # ---------------------------------------------------------------
    echo "--> Checking VirtualBox Guest Additions (prerequisite)..."
    if lsmod 2>/dev/null | grep -q "vboxguest"; then
        echo "INFO: VirtualBox Guest Additions detected. OK."
        mark_ok "vbox:guest-additions"
    else
        echo "INFO: VirtualBox Guest Additions not detected."
        echo "INFO: Install manually before next run:"
        echo "INFO:   VirtualBox menu > Devices > Insert Guest Additions CD image..."
        echo "INFO:   sudo mount /dev/cdrom /mnt && sudo sh /mnt/VBoxLinuxAdditions.run"
        echo "INFO: Continuing installation without Guest Additions."
    fi

    echo "--> Installing system packages (one-by-one for resilience)..."
    PACKAGES=(
        # Core build tools
        gnupg curl wget git pipx flatpak unzip build-essential
        pkg-config libsodium-dev libcairo2-dev golang-go cargo
        # Locale and base fonts (EN + IT + ZH)
        locales fonts-noto-core
        # Italian (analyst UI language option)
        firefox-esr-l10n-it libreoffice-l10n-it manpages-it
        # --- Chinese: browser/office localisation ---
        firefox-esr-l10n-zh-cn libreoffice-l10n-zh-cn
        # --- Chinese: CJK fonts (Simplified + Traditional + emoji) ---
        # fonts-noto-cjk alone renders both SC and TC; extra adds weights.
        # Arphic = Kai/Ming styles (formal docs); WQY = fallback for legacy pages.
        fonts-noto-cjk fonts-noto-cjk-extra fonts-noto-color-emoji
        fonts-arphic-ukai fonts-arphic-uming
        fonts-arphic-gbsn00lp fonts-arphic-gkai00mp
        fonts-wqy-zenhei fonts-wqy-microhei
        # Unifont: last-resort glyph coverage for rare hanzi (CJK Ext B/C/D)
        # so obscure characters render as a real glyph instead of tofu boxes.
        # (Noto Serif CJK is already provided by fonts-noto-cjk above.)
        fonts-unifont
        # --- Chinese: input method (fcitx5 full stack: Pinyin/Shuangpin/tables) ---
        fcitx5 fcitx5-chinese-addons fcitx5-table-extra fcitx5-config-qt
        fcitx5-frontend-gtk3 fcitx5-frontend-gtk4
        fcitx5-frontend-qt5 fcitx5-frontend-qt6 im-config
        # Rime engine: extra schemata beyond Pinyin — Cangjie/Wubi, Zhuyin/
        # Bopomofo (Taiwan) and Jyutping (Cantonese/HK). Selectable in
        # fcitx5-configtool; the pre-configured Pinyin default stays unchanged.
        fcitx5-rime
        # --- Chinese: offline dictionaries + Simplified<->Traditional conversion ---
        goldendict-ng stardict stardict-tools
        dictd dict dict-cc-cedict
        opencc python3-opencc
        # --- Chinese: NLP helpers (segmentation + pinyin) from official repo ---
        python3-pypinyin python3-jieba
        # Python
        python3-venv python3-pip python3-testresources python3-lxml
        libxml2-dev libxslt1-dev
        # Multimedia
        vlc ffmpeg
        # OSINT system tools
        default-jre httrack webhttrack libimage-exiftool-perl
        mediainfo-gui mat2 subversion
        # --- Network layer: generic VPN + proxy routing (Debian repos) ---
        # The "neutral" egress tier. These are the pipe toward a mainland
        # endpoint, not the endpoint itself — configs/IP supplied at runtime.
        # wireguard-tools: wg / wg-quick    | openvpn: .ovpn client
        # proxychains4: per-command SOCKS/HTTP routing (real pkg; 'proxychains-ng'
        #   is only a virtual name it provides — installing the real one is safer)
        # shadowsocks-libev: lightweight Shadowsocks client (ss-local, ss-redir)
        wireguard-tools openvpn proxychains4 shadowsocks-libev
        # Desktop / utilities
        zenity kazam bleachbit libxcb-cursor0 docker.io evince
        # GNOME extensions
        gnome-shell-extensions gnome-shell-extension-manager
        gnome-shell-extension-dash-to-panel
    )
    for pkg in "${PACKAGES[@]}"; do
        sudo apt install -y "$pkg" || echo "WARNING: Failed to install '$pkg', continuing..."
    done

    # ---------------------------------------------------------------
    # Chinese locales — enable zh_CN.UTF-8 and zh_TW.UTF-8 for correct
    # rendering/sorting of Chinese content, WITHOUT changing the system UI
    # language (analyst keeps English/Italian). Non-interactive.
    # ---------------------------------------------------------------
    echo "--> Enabling Chinese locales (zh_CN.UTF-8, zh_TW.UTF-8)..."
    sudo sed -i -E 's/^#\s*(zh_CN\.UTF-8\s+UTF-8)/\1/' /etc/locale.gen || true
    sudo sed -i -E 's/^#\s*(zh_TW\.UTF-8\s+UTF-8)/\1/' /etc/locale.gen || true
    sudo sed -i -E 's/^#\s*(en_GB\.UTF-8\s+UTF-8)/\1/' /etc/locale.gen || true
    sudo locale-gen || true

    # Set system default locale to British English (UI stays non-Chinese).
    echo "--> Setting system locale to en_GB.UTF-8..."
    sudo update-locale LANG=en_GB.UTF-8 LC_MESSAGES=en_GB.UTF-8 || true

    # ---------------------------------------------------------------
    # fcitx5 as the input-method framework for the analyst user.
    # GNOME/Wayland reaches fcitx5 through the GTK/Qt IM modules, so the
    # environment variables below are required. Default toggle: Ctrl+Space.
    # ---------------------------------------------------------------
    echo "--> Configuring fcitx5 (Pinyin) for user '$REAL_USER'..."
    run_as_user im-config -n fcitx5 || true
    if ! grep -q "GTK_IM_MODULE=fcitx" /etc/environment 2>/dev/null; then
        {
            echo "GTK_IM_MODULE=fcitx"
            echo "QT_IM_MODULE=fcitx"
            echo "XMODIFIERS=@im=fcitx"
            echo "SDL_IM_MODULE=fcitx"
        } | sudo tee -a /etc/environment > /dev/null
    fi
    # Autostart fcitx5 in the GNOME session
    run_as_user mkdir -p "$REAL_HOME/.config/autostart"
    if [ -f /usr/share/applications/org.fcitx.Fcitx5.desktop ]; then
        cp /usr/share/applications/org.fcitx.Fcitx5.desktop \
            "$REAL_HOME/.config/autostart/" 2>/dev/null || true
        chown "$REAL_USER:$REAL_USER" \
            "$REAL_HOME/.config/autostart/org.fcitx.Fcitx5.desktop" 2>/dev/null || true
    fi
    # Minimal fcitx5 profile: US keyboard + Pinyin engine
    run_as_user mkdir -p "$REAL_HOME/.config/fcitx5"
    if [ ! -f "$REAL_HOME/.config/fcitx5/profile" ]; then
        cat > "$REAL_HOME/.config/fcitx5/profile" <<'FCITX5_EOF'
[Groups/0]
Name=Default
Default Layout=us
DefaultIM=pinyin

[Groups/0/Items/0]
Name=keyboard-us

[Groups/0/Items/1]
Name=pinyin

[GroupOrder]
0=Default
FCITX5_EOF
        chown -R "$REAL_USER:$REAL_USER" "$REAL_HOME/.config/fcitx5" 2>/dev/null || true
    fi

    # sq (sequoia-sq) — used for GPG key dearmoring; fall back to gpg if unavailable
    sudo apt install -y sq || echo "INFO: 'sq' not available; sn0int install will use gpg --dearmor fallback."

    # Refresh shell's command hash table so newly installed binaries are found
    hash -r 2>/dev/null || true

    # Ensure pipx tools and Go binaries are accessible
    run_as_user pipx ensurepath || true
    REAL_GOPATH=$(run_as_user go env GOPATH 2>/dev/null || echo "$REAL_HOME/go")
    export PATH="$REAL_HOME/.local/bin:$REAL_GOPATH/bin:$PATH"


    # ###############################################################
    # PHASE 2: CORE APPLICATIONS
    # ###############################################################
    echo "--- PHASE 2: Core Applications ---"
    echo "    [師傅] Good tools are like good manners, Blade of Grass: invisible until the moment they are needed."

    # -- Firefox ESR: enterprise policies (privacy + OSINT bookmarks + extensions) --
    echo "--> Configuring Firefox ESR via policies.json..."
    _FF_POLICY_DIR="/usr/lib/firefox-esr/distribution"
    sudo mkdir -p "$_FF_POLICY_DIR"
    # policies.json holds a local file:// URL (Exploratores homepage + bookmark) using a
    # __HOME__ placeholder — substitute the real home at deploy time, the same mechanism
    # used for the .desktop shortcuts below.
    sed "s|__HOME__|$REAL_HOME|g" "$_REPO_DIR/config/policies.json" \
        | sudo tee "$_FF_POLICY_DIR/policies.json" > /dev/null
    sudo chmod 644 "$_FF_POLICY_DIR/policies.json"

    # -- Exploratores: browser-based OSINT toolkit (static HTML), opened in Firefox ESR --
    echo "--> Installing Exploratores..."
    _EXPLORATORES_DIR="$REAL_HOME/Documents/Exploratores"
    run_as_user mkdir -p "$REAL_HOME/Documents"
    if [ ! -d "$_EXPLORATORES_DIR/.git" ]; then
        if run_as_user git clone "https://github.com/SOsintOps/Exploratores.git" "$_EXPLORATORES_DIR"; then
            mark_ok "git:Exploratores"
        else
            echo "WARNING: Exploratores clone failed."
            mark_fail "git:Exploratores"
        fi
    else
        mark_ok "git:Exploratores"
    fi

    # -- Brave Browser --
    echo "--> Installing Brave Browser..."
    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg \
        "https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg"
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" \
        | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
    sudo apt update
    if sudo apt install -y brave-browser; then
        mark_ok "app:brave-browser"
    else
        echo "WARNING: Brave Browser install failed."
        mark_fail "app:brave-browser"
    fi

    # -- Tor Browser (Flatpak) --
    echo "--> Installing Tor Browser..."
    run_as_user flatpak remote-add --user --if-not-exists flathub \
        "https://dl.flathub.org/repo/flathub.flatpakrepo" || true
    if run_as_user flatpak install --user flathub org.torproject.torbrowser-launcher -y; then
        mark_ok "app:tor-browser"
    else
        echo "WARNING: Tor Browser install failed."
        mark_fail "app:tor-browser"
    fi

    # -- Google Earth Pro --
    echo "--> Installing Google Earth Pro..."
    curl -fsSL "https://dl.google.com/linux/linux_signing_key.pub" \
        | gpg --dearmor \
        | sudo tee /etc/apt/trusted.gpg.d/google-linux-signing-key.gpg > /dev/null
    run_as_user wget -q -O "$REAL_HOME/Downloads/google-earth-stable_current_amd64.deb" \
        "https://dl.google.com/dl/earth/client/current/google-earth-stable_current_amd64.deb" \
        || echo "WARNING: Google Earth download failed."
    if [ -f "$REAL_HOME/Downloads/google-earth-stable_current_amd64.deb" ]; then
        if sudo apt install -y "$REAL_HOME/Downloads/google-earth-stable_current_amd64.deb"; then
            mark_ok "app:google-earth-pro"
        else
            echo "WARNING: Google Earth install failed."
            mark_fail "app:google-earth-pro"
        fi
    else
        mark_fail "app:google-earth-pro"
    fi


    # ###############################################################
    # PHASE 3: OSINT TOOLS
    # ###############################################################
    echo "--- PHASE 3: OSINT Tools ---"
    echo "    [師傅] We gather more instruments than we will use, Blade of Grass. So does the wise physician."

    # -- 3a. pipx tools --
    echo "--> Installing tools via pipx..."
    # archivebox requires native deps that must be present before the pipx install
    echo "    Pre-installing archivebox native dependencies..."
    sudo apt install -y python3-dev libxml2-dev libxslt1-dev zlib1g-dev \
        ripgrep wget curl chromium nodejs npm || true

    PIPX_PACKAGES=(
        yt-dlp
        streamlink
        socialscan
        bdfr
        holehe
        ghunt
        h8mail
        search-that-hash
        name-that-hash
        gallery-dl
        instaloader
        toutatis
        waybackpy
        waybackpack
        "changedetection.io"
        archivebox
        xeuledoc
        internetarchive
        sherlock-project
        ignorant
        shodan
        fierce
        censys
        naminter
        # social-analyzer: 999 siti, web UI, OCR detection. NOTE: lo stato 'maybe'
        # genera falsi positivi — usare con filtro --threshold o esaminare i soli 'found'.
        social-analyzer
    )
    for pkg in "${PIPX_PACKAGES[@]}"; do
        if run_as_user pipx install "$pkg"; then
            mark_ok "pipx:$pkg"
        else
            echo "WARNING: pipx install failed for '$pkg'"
            mark_fail "pipx:$pkg"
        fi
    done

    # Refresh PATH after pipx installs
    export PATH="$REAL_HOME/.local/bin:$PATH"

    # -- 3b. Python tools from Git (isolated venvs) --
    echo "--> Installing Python tools from Git..."
    install_py_tool_from_git "https://github.com/p1ngul1n0/blackbird"
    install_py_tool_from_git "https://github.com/C3n7ral051nt4g3ncy/WhatsMyName-Python"
    install_py_tool_from_git "https://github.com/N0rz3/Eyes"
    install_py_tool_from_git "https://github.com/Datalux/Osintgram"
    install_py_tool_from_git "https://github.com/s0md3v/Photon"
    install_py_tool_from_git "https://github.com/aboul3la/Sublist3r"
    install_py_tool_from_git "https://github.com/Lazza/Carbon14"
    install_py_tool_from_git "https://github.com/opsdisk/metagoofil"
    install_py_tool_from_git "https://github.com/lanmaster53/recon-ng" "REQUIREMENTS"
    install_py_tool_from_git "https://github.com/sharsil/mailcat"
    install_py_tool_from_git "https://github.com/Greyjedix/Profil3r"
    # Aliens Eye: 841 siti, AI confidence scoring (0-100%), 3 livelli di scansione
    install_py_tool_from_git "https://github.com/arxhr007/Aliens_eye"

    # Maigret: fork SOsintOps with custom web UI (maigret-enhanced)
    install_py_tool_from_git "https://github.com/SOsintOps/maigret"
    # Install maigret-enhanced dependencies into the same venv
    local _maigret_venv="$PROGRAMS_DIR/maigret/maigretEnvironment"
    if [ -d "$_maigret_venv" ] && [ -f "$_REPO_DIR/scripts/maigret-enhanced/requirements.txt" ]; then
        echo "--> Installing maigret-enhanced dependencies..."
        run_as_user "$_maigret_venv/bin/pip" install --quiet \
            -r "$_REPO_DIR/scripts/maigret-enhanced/requirements.txt" || true
    fi

    # -- 3c. h8mail configuration --
    echo "--> Configuring h8mail..."
    run_as_user sh -c "cd \"$REAL_HOME\" && \"$REAL_HOME/.local/bin/h8mail\" -g" || true
    H8MAIL_CONFIG="$REAL_HOME/h8mail_config.ini"
    if [ -f "$H8MAIL_CONFIG" ]; then
        sed -i 's/\;leak\-lookup\_pub/leak\-lookup\_pub/g' "$H8MAIL_CONFIG" || true
        cp "$H8MAIL_CONFIG" "$CONFIG_DIR/h8mail_config.ini" || true
    fi

    # -- 3d. sn0int (signed APT repo, with sq/gpg fallback) --
    echo "--> Installing sn0int..."
    if command -v sq >/dev/null 2>&1; then
        curl -sSLf "https://apt.vulns.sexy/kpcyrd.pgp" | sq packet dearmor \
            | sudo tee /etc/apt/trusted.gpg.d/apt-vulns-sexy.gpg > /dev/null
    else
        curl -sSLf "https://apt.vulns.sexy/kpcyrd.pgp" | gpg --dearmor \
            | sudo tee /etc/apt/trusted.gpg.d/apt-vulns-sexy.gpg > /dev/null
    fi
    echo "deb [signed-by=/etc/apt/trusted.gpg.d/apt-vulns-sexy.gpg] https://apt.vulns.sexy stable main" \
        | sudo tee /etc/apt/sources.list.d/apt-vulns-sexy.list > /dev/null
    sudo apt update
    if sudo apt install -y sn0int; then
        mark_ok "apt:sn0int"
    else
        echo "WARNING: sn0int install failed."
        mark_fail "apt:sn0int"
    fi

    # -- 3e. theHarvester (via uv) --
    echo "--> Installing theHarvester..."
    # Check for uv binary directly — 'command -v' does not work well inside run_as_user
    if [ ! -f "$REAL_HOME/.local/bin/uv" ]; then
        # Run curl+pipe inside a single sudo call to avoid pipe/stdin issues
        run_as_user bash -c "curl -LsSf 'https://astral.sh/uv/install.sh' | sh"
        export PATH="$REAL_HOME/.local/bin:$PATH"
    fi
    # Source cargo env only if present AND we are not root (avoids env pollution as root)
    if [ "$(id -u)" -ne 0 ] && [ -f "$REAL_HOME/.cargo/env" ]; then
        source "$REAL_HOME/.cargo/env" || true
    fi
    if [ ! -d "$PROGRAMS_DIR/theHarvester" ]; then
        run_as_user git clone "https://github.com/laramies/theHarvester.git" \
            "$PROGRAMS_DIR/theHarvester" || echo "WARNING: theHarvester clone failed."
    fi
    if [ -d "$PROGRAMS_DIR/theHarvester" ]; then
        # 'uv --project <path> sync' is the correct syntax (--project is a global flag)
        if run_as_user "$REAL_HOME/.local/bin/uv" --project "$PROGRAMS_DIR/theHarvester" sync; then
            mark_ok "git:theHarvester"
        else
            echo "WARNING: 'uv sync' failed for theHarvester."
            mark_fail "git:theHarvester"
        fi
    else
        mark_fail "git:theHarvester"
    fi

    # -- 3f. Go-based tools --
    echo "--> Installing Go-based tools..."
    export GOTOOLCHAIN=auto
    # Run go installs as the real user so binaries land in their GOPATH
    tracked "go:amass"       run_as_user go install -v "github.com/owasp-amass/amass/v4/...@latest"
    tracked "go:subfinder"   run_as_user go install -v "github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest"
    tracked "go:httpx"       run_as_user go install -v "github.com/projectdiscovery/httpx/cmd/httpx@latest"
    tracked "go:nuclei"      run_as_user go install -v "github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest"
    # Enola: username hunter Go-based, 407 siti, binario singolo, veloce
    tracked "go:enola"       run_as_user go install -v "github.com/theyahya/enola/cmd/enola@latest"
    # Stalkie: 13 siti, confidence scoring multi-segnale, headless browser go-rod,
    # login wall detection, supporto Tor/SOCKS5
    tracked "go:stalkie"     run_as_user go install -v "github.com/ashendilantha/stalkie@latest"
    # Investigo: riscrittura Go di Sherlock con download contenuti profili,
    # 32 goroutine concorrenti, supporto Tor, usa DB Sherlock (~479 siti)
    tracked "go:investigo"   run_as_user go install -v "github.com/tdh8316/Investigo/cmd/investigo@latest"
    echo "--> Installing phoneinfoga (precompiled binary)..."
    tracked "bin:phoneinfoga" run_as_user bash -c "
        curl -fsSL 'https://github.com/sundowndev/phoneinfoga/releases/latest/download/phoneinfoga_Linux_x86_64.tar.gz' \
        -o /tmp/phoneinfoga.tar.gz && \
        tar -xz -C \$HOME/.local/bin/ -f /tmp/phoneinfoga.tar.gz phoneinfoga && \
        chmod +x \$HOME/.local/bin/phoneinfoga && \
        rm -f /tmp/phoneinfoga.tar.gz
    "

    # Ensure Go binaries are in PATH for subsequent commands
    REAL_GOPATH=$(run_as_user go env GOPATH 2>/dev/null || echo "$REAL_HOME/go")
    export PATH="$REAL_GOPATH/bin:$PATH"
    # Persist GOPATH in user's profile (marker prevents duplicate entries)
    _PROFILE_MARKER="# wukong-project: Go and pipx PATH"
    if ! grep -qF "$_PROFILE_MARKER" "$REAL_HOME/.profile" 2>/dev/null; then
        printf '\n%s\nexport PATH="$HOME/go/bin:$HOME/.local/bin:$PATH"\n' \
            "$_PROFILE_MARKER" >> "$REAL_HOME/.profile"
    fi

    # -- 3g. Mr.Holmes (git clone, no deps to install) --
    echo "--> Cloning Mr.Holmes..."
    if [ ! -d "$PROGRAMS_DIR/Mr.Holmes" ]; then
        if run_as_user git clone "https://github.com/Lucksi/Mr.Holmes" "$PROGRAMS_DIR/Mr.Holmes"; then
            mark_ok "git:Mr.Holmes"
        else
            echo "WARNING: Mr.Holmes clone failed."
            mark_fail "git:Mr.Holmes"
        fi
    else
        mark_ok "git:Mr.Holmes"
    fi

    # -- 3h. WireTapper (wireless/cellular network OSINT, requires API keys) --
    install_py_tool_from_git "https://github.com/h9zdev/WireTapper" "WireTapper.txt"

    # -- 3i. TLDSweep (domain TLD sweep, stdlib only — no requirements) --
    echo "--> Cloning TLDSweep..."
    if [ ! -d "$PROGRAMS_DIR/TLDSweep" ]; then
        if run_as_user git clone "https://github.com/DarkWebInformer/TLDSweep.git" "$PROGRAMS_DIR/TLDSweep"; then
            mark_ok "git:TLDSweep"
        else
            echo "WARNING: TLDSweep clone failed."
            mark_fail "git:TLDSweep"
        fi
    else
        mark_ok "git:TLDSweep"
    fi

    # -- 3j. Turbolehe (email variant generator for holehe; stdlib only — no requirements) --
    echo "--> Cloning Turbolehe..."
    if [ ! -d "$PROGRAMS_DIR/Turbolehe" ]; then
        if run_as_user git clone "https://github.com/purrsec/Turbolehe.git" "$PROGRAMS_DIR/Turbolehe"; then
            mark_ok "git:Turbolehe"
        else
            echo "WARNING: Turbolehe clone failed."
            mark_fail "git:Turbolehe"
        fi
    else
        mark_ok "git:Turbolehe"
    fi


    # ###############################################################
    # PHASE 3.5: CHINESE OSINT TOOLKIT (悟空)
    # Sinophone cyberspace / social / dorking + corporate KYC tools.
    # NOTE: many Chinese-platform scrapers require a real account (often a
    # +86 phone) and a mainland-China proxy; cyberspace engines (FOFA/Quake/
    # ZoomEye) require an API key. These install fine but need credentials
    # at runtime — see documents/CHINA_TOOLKIT.md.
    # ###############################################################
    echo "--- PHASE 3.5: Chinese OSINT Toolkit ---"
    echo "    [師傅] Where the crowd sees a wall, the master sees a door. 悟空 sees the hinge."

    # -- 3.5a. pipx tools (isolated) --
    echo "--> Installing Chinese OSINT tools via pipx..."
    ZH_PIPX_PACKAGES=(
        kunyu          # ZoomEye-based asset recon (needs ZoomEye API key)
        zoomeye        # official ZoomEye CLI/SDK
        fofa           # official FOFA Python SDK/CLI (needs FOFA key)
        you-get        # Bilibili/Youku/Douyin/Weibo media downloader
        weibospider    # Weibo post/user scraper (needs cookie)
        snscrape       # multi-social scraper incl. Weibo module (fragile)
        pydork         # dorking incl. Baidu engine
        hanzidentifier # Simplified/Traditional detection (not in apt)
    )
    for pkg in "${ZH_PIPX_PACKAGES[@]}"; do
        if run_as_user pipx install "$pkg"; then
            mark_ok "pipx:$pkg"
        else
            echo "WARNING: pipx install failed for '$pkg'"
            mark_fail "pipx:$pkg"
        fi
    done

    # -- 3.5b. Cyberspace mapping engines (FOFA + Quake) --
    echo "--> Installing Go-based Chinese cyberspace tools..."
    export GOTOOLCHAIN=auto
    tracked "go:fofax"  run_as_user go install -v "github.com/xiecat/fofax@latest"
    tracked "go:gofofa" run_as_user go install -v "github.com/FofaInfo/GoFOFA/cmd/gofofa@latest"

    # Quake (360) — the third major Chinese cyberspace engine alongside FOFA
    # and ZoomEye. quake_rs is the maintained Rust CLI; installed from the
    # release binary (x86_64-only asset). Needs a Quake API token at runtime:
    # 'quake init <apikey>' — see documents/CHINA_TOOLKIT.md.
    echo "--> Installing Quake CLI (360 quake_rs release binary)..."
    if [ "$DRY_RUN" = "true" ]; then
        echo "  [DRY-RUN] would download quake_rs (x86_64) into ~/.local/bin/quake"
    elif [ "$(uname -m)" = "x86_64" ]; then
        # Download + extract + install all as the real user (mktemp is user-owned,
        # so tar can write into it); the URL is a literal inside the user shell.
        if run_as_user bash -c '
            set -e
            t="$(mktemp -d)"
            curl -fsSL "https://github.com/360quake/quake_rs/releases/latest/download/quake-x86_64-unknown-linux-gnu.tar.gz" -o "$t/quake.tar.gz"
            tar -xzf "$t/quake.tar.gz" -C "$t"
            b="$(find "$t" -type f -name quake | head -1)"
            [ -n "$b" ] && install -m 0755 "$b" "$HOME/.local/bin/quake"
            rm -rf "$t"
        '; then
            mark_ok "bin:quake"
        else
            echo "WARNING: Quake CLI install failed (network/asset name?)."
            mark_fail "bin:quake"
        fi
    else
        echo "INFO: Quake release is x86_64-only; skipping on $(uname -m)."
        mark_fail "bin:quake"
    fi

    # -- 3.5c. Python tools from Git (isolated venvs) --
    echo "--> Installing Chinese OSINT tools from Git..."
    # ShuiZe 水泽 — automated recon from a domain (FOFA/Shodan/Quake keys optional)
    install_py_tool_from_git "https://github.com/0x727/ShuiZe_0x727"
    # MediaCrawler — Xiaohongshu/Douyin/Weibo/Bilibili/Kuaishou/Zhihu/Tieba (login QR)
    install_py_tool_from_git "https://github.com/NanmiCoder/MediaCrawler"
    # weibo-crawler — Weibo scraper with media download (needs cookie)
    install_py_tool_from_git "https://github.com/dataabc/weibo-crawler"
    # we-mp-rss — WeChat 公众号 to RSS/Markdown/PDF (needs WeChat account)
    install_py_tool_from_git "https://github.com/rachelos/we-mp-rss"
    # ICP_Query — local ICP备案 lookup API (domain -> registered company)
    install_py_tool_from_git "https://github.com/HG-ha/ICP_Query"

    # -- 3.5d. ENScan_GO — Chinese corporate enumeration (Go binary release) --
    # Collects subsidiaries, ICP备案, apps, mini-programs and 公众号 from
    # Aiqicha/TianYanCha etc. Requires platform cookies (see CHINA_TOOLKIT.md).
    echo "--> Installing ENScan_GO..."
    if [ ! -d "$PROGRAMS_DIR/ENScan_GO" ]; then
        if run_as_user git clone "https://github.com/wgpsec/ENScan_GO.git" "$PROGRAMS_DIR/ENScan_GO"; then
            # Build the Go binary into the analyst's PATH
            if run_as_user bash -c "cd '$PROGRAMS_DIR/ENScan_GO' && go build -o '$REAL_HOME/.local/bin/enscan' . 2>/dev/null"; then
                run_as_user chmod +x "$REAL_HOME/.local/bin/enscan" 2>/dev/null || true
                mark_ok "git:ENScan_GO"
            else
                echo "INFO: ENScan_GO cloned; 'go build' failed — build manually or use a release binary."
                mark_ok "git:ENScan_GO"
            fi
        else
            echo "WARNING: ENScan_GO clone failed."
            mark_fail "git:ENScan_GO"
        fi
    else
        mark_ok "git:ENScan_GO"
    fi

    # -- 3.5e. BBDown — Bilibili downloader (.NET tool) --
    # Debian repo ships dotnet; if absent BBDown is skipped gracefully.
    echo "--> Installing BBDown (Bilibili downloader)..."
    if run_as_user bash -c "command -v dotnet >/dev/null 2>&1"; then
        if run_as_user dotnet tool install --global BBDown; then
            mark_ok "dotnet:BBDown"
        else
            echo "WARNING: BBDown install failed."
            mark_fail "dotnet:BBDown"
        fi
    else
        echo "INFO: dotnet not present; skipping BBDown (install dotnet-sdk to enable)."
        mark_fail "dotnet:BBDown"
    fi

    # -- 3.5f. Network / egress layer — circumvention engines --
    # Neutral tier (WireGuard/OpenVPN/proxychains4/shadowsocks-libev) is in
    # the Phase 1 apt list. This installs the anti-DPI engines from release.
    install_network_circumvention

    # Refresh PATH after Chinese-tool installs
    REAL_GOPATH=$(run_as_user go env GOPATH 2>/dev/null || echo "$REAL_HOME/go")
    export PATH="$REAL_HOME/.local/bin:$REAL_GOPATH/bin:$PATH"


    # ###############################################################
    # PHASE 4: LAUNCHERS AND SCRIPTS
    # ###############################################################
    echo "--- PHASE 4: Scripts and Launchers ---"
    echo "    [師傅] The path is now laid with stones. Even without the terminal, the feet will find their way."

    # Install all scripts from repo (top-level .sh files)
    echo "--> Installing scripts from repo..."
    for _sh in "$_REPO_DIR/scripts/"*.sh; do
        [ -f "$_sh" ] || continue
        _sname="$(basename "$_sh")"
        cp "$_sh" "$SCRIPTS_DIR/$_sname"
        chown "$REAL_USER:$REAL_USER" "$SCRIPTS_DIR/$_sname" 2>/dev/null || true
        chmod +x "$SCRIPTS_DIR/$_sname"
        echo "    Installed: $_sname"
    done

    # Install shared library (scripts/lib/)
    echo "--> Installing shared library..."
    mkdir -p "$SCRIPTS_DIR/lib"
    for _lib in "$_REPO_DIR/scripts/lib/"*.sh; do
        [ -f "$_lib" ] || continue
        cp "$_lib" "$SCRIPTS_DIR/lib/$(basename "$_lib")"
        chown "$REAL_USER:$REAL_USER" "$SCRIPTS_DIR/lib/$(basename "$_lib")" 2>/dev/null || true
        chmod +x "$SCRIPTS_DIR/lib/$(basename "$_lib")"
        echo "    Installed: lib/$(basename "$_lib")"
    done

    # Install Maigret Enhanced web UI
    if [ -d "$_REPO_DIR/scripts/maigret-enhanced" ]; then
        echo "--> Installing Maigret Enhanced web UI..."
        mkdir -p "$SCRIPTS_DIR/maigret-enhanced/static"
        cp "$_REPO_DIR/scripts/maigret-enhanced/"*.py "$SCRIPTS_DIR/maigret-enhanced/" 2>/dev/null || true
        cp "$_REPO_DIR/scripts/maigret-enhanced/"*.txt "$SCRIPTS_DIR/maigret-enhanced/" 2>/dev/null || true
        cp "$_REPO_DIR/scripts/maigret-enhanced/static/"*.{html,css,js} "$SCRIPTS_DIR/maigret-enhanced/static/" 2>/dev/null || true
        chown -R "$REAL_USER:$REAL_USER" "$SCRIPTS_DIR/maigret-enhanced" 2>/dev/null || true
        echo "    Installed: maigret-enhanced/"
    fi

    # Install icons from media/icons/ with wukong- naming convention.
    # Maps local icon filenames to the wukong-<name>.png convention.
    echo "--> Installing icons from repo..."
    declare -A _ICON_MAP=(
        [user.png]=wukong-user.png
        [domains.png]=wukong-domain.png
        [instagram.png]=wukong-instagram.png
        [youtube-dl.png]=wukong-video.png
        [metagoofil.png]=wukong-metadata.png
        [recon-ng.png]=wukong-api.png
        [evidence.png]=wukong-evidence.png
        [maigret.png]=wukong-maigret.png
        [spiderfoot.png]=wukong-framework.png
        [china.png]=wukong-china.png
        [kyc.png]=wukong-kyc.png
    )
    # Icons not yet in media/icons/ (pending generation):
    # china.png    -> wukong-china.png   (Monkey King / 悟空 theme)
    # kyc.png      -> wukong-kyc.png     (corporate / due-diligence theme)
    # archives.png -> wukong-archives.png
    # reddit.png   -> wukong-reddit.png
    # image.png    -> wukong-image.png
    # update.png   -> wukong-update.png
    for _src_icon in "${!_ICON_MAP[@]}"; do
        _src_path="$_REPO_DIR/media/icons/$_src_icon"
        _dst_path="$ICONS_DIR/${_ICON_MAP[$_src_icon]}"
        if [ -f "$_src_path" ]; then
            cp "$_src_path" "$_dst_path"
            chown "$REAL_USER:$REAL_USER" "$_dst_path" 2>/dev/null || true
        fi
    done

    # Install shortcuts from repo.
    # Each shortcuts/*.desktop is installed as wukong-<name>.desktop
    # with __HOME__ substituted for the actual home directory.
    echo "--> Installing shortcuts from repo..."
    for _df in "$_REPO_DIR/shortcuts/"*.desktop; do
        [ -f "$_df" ] || continue
        _dest_name="wukong-$(basename "$_df")"
        sed "s|__HOME__|$REAL_HOME|g" "$_df" > "$DESKTOP_DIR/$_dest_name"
        chown "$REAL_USER:$REAL_USER" "$DESKTOP_DIR/$_dest_name" 2>/dev/null || true
        echo "    Installed: $_dest_name"
    done

    # Copy the Speculatores document to ~/Documents
    echo "--> Installing Speculatores document..."
    run_as_user mkdir -p "$REAL_HOME/Documents"
    if [ -f "$_REPO_DIR/media/A Travelling Wukong.pdf" ]; then
        cp "$_REPO_DIR/media/A Travelling Wukong.pdf" \
            "$REAL_HOME/Documents/A Travelling Wukong.pdf"
        chown "$REAL_USER:$REAL_USER" \
            "$REAL_HOME/Documents/A Travelling Wukong.pdf" 2>/dev/null || true
    fi

    # Create evidence directory in Downloads and add Desktop symlink
    echo "--> Setting up evidence directory..."
    run_as_user mkdir -p "$REAL_HOME/Downloads/evidence"
    if [ ! -e "$REAL_HOME/Desktop/evidence" ]; then
        run_as_user ln -s "$REAL_HOME/Downloads/evidence" "$REAL_HOME/Desktop/evidence" \
            || echo "INFO: Could not create Desktop/evidence symlink (Desktop may not exist yet)."
    fi

    # Install desktop files system-wide so GNOME picks them up
    sudo cp "$DESKTOP_DIR"/wukong-*.desktop /usr/share/applications/ 2>/dev/null || true
    sudo gtk-update-icon-cache -f -t /usr/share/icons/hicolor 2>/dev/null || true

    # Set GNOME dock favourites (best-effort; may fail outside a GUI session)
    _GNOME_FAVS="['firefox-esr.desktop', 'org.torproject.torbrowser-launcher.desktop', 'org.gnome.Nautilus.desktop', 'wukong-evidence.desktop', 'org.gnome.Terminal.desktop', 'wukong-china.desktop', 'wukong-kyc.desktop', 'wukong-update.desktop', 'wukong-video.desktop', 'wukong-user.desktop', 'wukong-maigret.desktop', 'wukong-image.desktop', 'wukong-domain.desktop', 'wukong-instagram.desktop', 'wukong-frameworks.desktop', 'wukong-exploratores.desktop', 'google-earth-pro.desktop', 'kazam.desktop', 'org.gnome.Settings.desktop']"
    run_as_user gsettings set org.gnome.shell favorite-apps "$_GNOME_FAVS" \
        || echo "INFO: Could not set GNOME favorites (expected if outside a GUI session)."

    # Add Nautilus bookmark for direct access to the Wukong data directory.
    # .local is hidden by default; this makes maintenance easier via Files.
    _SPEC_BOOKMARK="file://$REAL_HOME/.local/share/wukong"
    _BOOKMARKS_FILE="$REAL_HOME/.config/gtk-3.0/bookmarks"
    run_as_user mkdir -p "$REAL_HOME/.config/gtk-3.0"
    grep -qF "$_SPEC_BOOKMARK" "$_BOOKMARKS_FILE" 2>/dev/null \
        || echo "$_SPEC_BOOKMARK Wukong" >> "$_BOOKMARKS_FILE"


    # ###############################################################
    # PHASE 5: GNOME LOOK AND FEEL
    # (Skipped automatically if GNOME 40+ is not detected)
    # ###############################################################
    echo "--- PHASE 5: GNOME Look and Feel ---"
    echo "    [師傅] A pleasing room calms the mind, and a calm mind sees what a busy one misses."

    # Use POSIX grep -o (no -P flag) for compatibility with minimal Debian installs
    GNOME_VERSION=$(gnome-shell --version 2>/dev/null | grep -o '[0-9]*' | head -1 || echo "0")
    if [ "$GNOME_VERSION" -ge 40 ]; then
        echo "--> GNOME $GNOME_VERSION detected. Applying configuration..."

        sudo apt install -y gnome-extensions-cli || true

        # Remove dash-to-dock if present — incompatible with GNOME 47 and causes the
        # top panel to disappear entirely.
        sudo apt remove -y gnome-shell-extension-dash-to-dock 2>/dev/null || true

        # gnome-extensions enable requires a running gnome-shell session
        if command -v pgrep >/dev/null 2>&1 && pgrep -x gnome-shell >/dev/null 2>&1; then
            run_as_user gnome-extensions disable "dash-to-dock@micxgx.gmail.com" 2>/dev/null || true
            run_as_user gnome-extensions enable "dash-to-panel@jderose9.github.com" \
                || echo "WARNING: Could not enable dash-to-panel extension."
        else
            echo "INFO: gnome-shell not running; dash-to-panel will be enabled on next login."
        fi

        SCHEMA_PANEL="org.gnome.shell.extensions.dash-to-panel"
        LOCAL_SCHEMA="$REAL_HOME/.local/share/gnome-shell/extensions/dash-to-panel@jderose9.github.com/schemas/"
        # Use an array to safely handle paths with spaces and avoid word splitting
        SCHEMA_ARGS=()
        [ -d "$LOCAL_SCHEMA" ] && SCHEMA_ARGS=(--schemadir "$LOCAL_SCHEMA")

        # gsettings requires a D-Bus session; skip silently if not in a GUI session
        if [ -n "${DBUS_SESSION_BUS_ADDRESS:-}" ] || [ -n "${DISPLAY:-}" ] || [ -n "${WAYLAND_DISPLAY:-}" ]; then
            run_as_user gsettings "${SCHEMA_ARGS[@]}" set $SCHEMA_PANEL panel-positions '{"0":"BOTTOM"}' || true
            run_as_user gsettings "${SCHEMA_ARGS[@]}" set $SCHEMA_PANEL panel-sizes '{"0":36}' || true
            run_as_user gsettings "${SCHEMA_ARGS[@]}" set $SCHEMA_PANEL appicon-margin 8 || true
            run_as_user gsettings "${SCHEMA_ARGS[@]}" set $SCHEMA_PANEL show-activities-button false || true

            run_as_user gsettings set org.gnome.Terminal.Legacy.Settings theme-variant 'dark' || true
            run_as_user gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close" || true
            _WALLPAPER_SRC="$(dirname "$0")/media/wallpapers/wukong1.jpg"
            _WALLPAPER_DEST="$REAL_HOME/Pictures/wukong1.jpg"
            run_as_user mkdir -p "$REAL_HOME/Pictures"
            if [ -f "$_WALLPAPER_SRC" ]; then
                cp "$_WALLPAPER_SRC" "$_WALLPAPER_DEST" || true
                chown "$REAL_USER:$REAL_USER" "$_WALLPAPER_DEST" 2>/dev/null || true
                run_as_user gsettings set org.gnome.desktop.background picture-uri "file://$_WALLPAPER_DEST" || true
                run_as_user gsettings set org.gnome.desktop.background picture-uri-dark "file://$_WALLPAPER_DEST" || true
                run_as_user gsettings set org.gnome.desktop.background picture-options 'zoom' || true
            else
                echo "INFO: media/wallpapers/wukong1.jpg not found. Skipping wallpaper."
                run_as_user gsettings set org.gnome.desktop.background picture-uri '' || true
                run_as_user gsettings set org.gnome.desktop.background picture-uri-dark '' || true
            fi
            run_as_user gsettings set org.gnome.desktop.background primary-color 'rgb(66, 81, 100)' || true
            run_as_user gsettings set org.gnome.desktop.notifications show-banners false || true
            run_as_user gsettings set org.gnome.desktop.session idle-delay 0 || true
            run_as_user gsettings set org.gnome.desktop.screensaver lock-enabled false || true
            run_as_user gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll true || true
            run_as_user gsettings set org.gnome.desktop.peripherals.mouse natural-scroll true || true
            run_as_user gsettings set org.gnome.mutter center-new-windows true || true
        else
            echo "INFO: No D-Bus/display session detected. gsettings will be applied on first login."
        fi
        sudo systemctl mask suspend.target || true

        rm -f "$REAL_HOME/Desktop/"*.desktop 2>/dev/null || true
    else
        echo "INFO: GNOME 40+ not detected (found: $GNOME_VERSION). Skipping GNOME configuration."
    fi


    # ###############################################################
    # PHASE 6: FINAL CLEANUP
    # ###############################################################
    echo "--- PHASE 6: Finalizing and Cleaning Up ---"
    echo "    [師傅] The tools are placed and their chi is good. Now the seeing begins. Miracles, Blade of Grass, carry a small surcharge."

    sudo apt update
    sudo apt upgrade -y
    sudo apt --fix-broken install -y

    # ---------------------------------------------------------------
    # Debloat: remove default GNOME applications useless for OSINT
    # Kept: evolution, totem, gnome-maps, simple-scan
    # ---------------------------------------------------------------
    echo "--> Removing unused GNOME applications..."
    _BLOAT=(
        aisleriot gnome-mahjongg gnome-mines gnome-sudoku quadrapassel
        iagno swell-foop tali hitori lightsoff gnome-robots
        five-or-more four-in-a-row gnome-tetravex
        gnome-music rhythmbox
        cheese
        gnome-weather gnome-clocks gnome-calendar gnome-contacts
        epiphany-browser
        shotwell
        gnome-software
    )
    sudo apt purge -y "${_BLOAT[@]}" 2>/dev/null || true

    sudo apt autoremove -y

    rm -f "$REAL_HOME/Downloads/google-earth-stable_current_amd64.deb" 2>/dev/null || true

    # Restore ownership of user directories in case root wrote to them
    if [ "$(id -u)" -eq 0 ] && [ "$REAL_USER" != "root" ]; then
        chown -R "$REAL_USER:$REAL_USER" \
            "$REAL_HOME/.local" \
            "$REAL_HOME/.config" \
            "$PROGRAMS_DIR" 2>/dev/null || true
    fi


    # ###############################################################
    # COMPLETION SUMMARY
    # ###############################################################
    echo ""
    echo "###############################################################"
    echo "# INSTALLATION COMPLETE                                       #"
    echo "###############################################################"
    echo "# User     : $REAL_USER"
    echo "# Programs : $PROGRAMS_DIR"
    echo "# Scripts  : $SCRIPTS_DIR"
    echo "# Log      : $LOG_FILE"
    echo "#"
    echo "# A system REBOOT is strongly recommended."
    echo "###############################################################"
    echo ""

    # --- Structured results report ---
    # NOTE: 'local' is invalid outside functions in bash — use plain assignments
    ok_count=${#_INSTALL_OK[@]}
    fail_count=${#_INSTALL_FAIL[@]}
    total=$(( ok_count + fail_count ))

    echo "┌─────────────────────────────────────────────────────────────┐"
    printf  "│  RESULTS: %d/%d components installed successfully           │\n" \
        "$ok_count" "$total"
    echo "├─────────────────────────────────────────────────────────────┤"

    if [ "$ok_count" -gt 0 ]; then
        echo "│  OK  ✓"
        for item in "${_INSTALL_OK[@]}"; do
            printf "│      %-54s│\n" "$item"
        done
    fi

    if [ "$fail_count" -gt 0 ]; then
        echo "├─────────────────────────────────────────────────────────────┤"
        echo "│  FAILED  ✗  (review log for details)"
        for item in "${_INSTALL_FAIL[@]}"; do
            printf "│      %-54s│\n" "$item"
        done
    else
        echo "│  No failures detected.                                      │"
    fi

    echo "└─────────────────────────────────────────────────────────────┘"
    echo ""
    echo "Full log: $LOG_FILE"
    echo ""

}

# Write machine-readable results file OUTSIDE the tee'd block to avoid
# double-redirect conflicts with 'exec > >(tee ...)'
RESULT_FILE="$LOG_DIR/install_results_$(date +%Y-%m-%d_%H-%M-%S).txt"
{
    echo "ok_count=$ok_count"
    echo "fail_count=$fail_count"
    echo "total=$total"
    echo ""
    echo "[ok]"
    for item in "${_INSTALL_OK[@]}";   do echo "$item"; done
    echo ""
    echo "[failed]"
    for item in "${_INSTALL_FAIL[@]}"; do echo "$item"; done
} > "$RESULT_FILE"
echo "Results file: $RESULT_FILE"

exit 0
