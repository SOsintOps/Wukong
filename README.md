# Wukong (悟空)

![Version](https://img.shields.io/badge/version-0.1.0-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![OS](https://img.shields.io/badge/OS-Debian%2013%20Trixie-red)
![Shell](https://img.shields.io/badge/shell-bash-yellow)
![Focus](https://img.shields.io/badge/focus-China%20OSINT-critical)

## Overview

**Wukong** is a China-focused OSINT spinoff of the [Speculator Project](https://github.com/SOsintOps/Speculator-Project). It provides a Bash installer that turns a clean Debian 13 "Trixie" virtual machine into a workstation purpose-built for investigating the Chinese-language internet and Chinese companies.

The name comes from **Sun Wukong (孙悟空)**, the Monkey King, whose *火眼金睛* — "fiery golden eyes" — see through any disguise or illusion. That is exactly what an analyst needs on Chinese sources, where the challenge is rarely finding text and almost always seeing through it: censored euphemisms, coded slang, and opaque corporate structures.

Wukong keeps the full general-purpose OSINT arsenal of Speculator and adds three China-specific layers:

1. **Language & culture layer** — full CJK font stack (Simplified + Traditional), the `fcitx5` Pinyin input method so you can *type* Chinese queries, Chinese locales, and offline dictionaries (CC-CEDICT, OpenCC Simplified↔Traditional conversion, `jieba`/`pypinyin`).
2. **Sinophone OSINT layer** — tools for the Chinese web (Baidu/Sogou dorking), social platforms (Weibo, Douyin, Xiaohongshu, Bilibili, WeChat 公众号), and cyberspace reconnaissance (FOFA, ZoomEye/Kunyu, Quake).
3. **Corporate due-diligence (KYC) layer** — ICP 备案 lookup, corporate-registry workflows (GSXT, TianYanCha, QCC, Cninfo) and automated enumeration with ENScan_GO.

> **Lineage:** Argos → Speculator → **Wukong**. Argos was the hundred-eyed giant; the Speculatores were Rome's scouts; Wukong is the eye that sees through deception on the Chinese net.

## System Requirements

- **Operating System:** Debian 13 "Trixie" (amd64)
- **Virtualisation:** VirtualBox recommended (Guest Additions installed manually first)
- **Disk:** 50 GB minimum recommended
- **RAM:** 4 GB minimum recommended
- **Permissions:** sudo required
- **Internet:** required for downloads
- **Note on Chinese sources:** many mainland platforms require a **+86 phone number**, a **mainland-China proxy/VPN**, and/or an **API key**. Wukong installs the tooling; you supply credentials at runtime. See [`documents/CHINA_TOOLKIT.md`](documents/CHINA_TOOLKIT.md).

## Installation

```bash
git clone https://github.com/SOsintOps/Wukong.git && cd Wukong && chmod +x wukong_install.sh && sudo ./wukong_install.sh
```

The `chmod +x` makes the script executable — needed if you downloaded the ZIP
(archives drop Unix permissions) or cloned without the executable bit.

Simulate without changing the system:

```bash
chmod +x wukong_install.sh && sudo ./wukong_install.sh --dry-run
```

After installation, reboot so the fonts, locales and `fcitx5` input method load cleanly.

## Documentation

Full documentation lives in [`documentation/`](documentation/README.md):

- [Project Overview](documentation/01-project-overview.md) — the three China layers and inherited architecture.
- [Source Material & Context](documentation/02-source-material.md) — the texts analysed (thesis, Cyber Detective channel, online research) and what is / isn't yet verified.
- [FAQ](documentation/04-faq.md) — OSINT, China OSINT, and this project.
- [Methodology & Legal](documentation/03-methodology-and-legal.md) — access prerequisites, the KYC workflow, and the legal/OPSEC context.
- [Tools index](documentation/tools/README.md) — **one page per China-specific tool** (install, access, usage, caveats).

The operational quick-reference (credentials, exact syntax, due-diligence steps) remains in [`documents/CHINA_TOOLKIT.md`](documents/CHINA_TOOLKIT.md).

## What gets added on top of Speculator

### Language & culture (all from official Debian repos)

- **Fonts:** `fonts-noto-cjk` (+extra) — which ships **both** Sans *and* Serif CJK — Arphic Kai/Ming (`fonts-arphic-*`), WQY fallback, `fonts-unifont` (last-resort glyphs for rare CJK Ext B/C/D hanzi, no tofu), colour emoji — renders Simplified **and** Traditional correctly.
- **Input method:** `fcitx5` + `fcitx5-chinese-addons` (Pinyin/Shuangpin) + tables + `fcitx5-rime` (Cangjie, Zhuyin/Bopomofo, Jyutping/Cantonese), pre-configured with a US-keyboard + Pinyin profile. Toggle with **Ctrl+Space**; extra Rime schemata are selectable in `fcitx5-configtool`.
- **Locales:** `zh_CN.UTF-8` and `zh_TW.UTF-8` enabled (system UI stays English/Italian).
- **Dictionaries & conversion:** GoldenDict-NG, StarDict, CC-CEDICT (offline), OpenCC, `python3-pypinyin`, `python3-jieba`.

### Sinophone OSINT tools

| Tool | Purpose | Notes |
|------|---------|-------|
| Kunyu / ZoomEye CLI | Cyberspace asset recon | ZoomEye API key |
| Fofax / GoFOFA / fofa-py | FOFA ("Chinese Shodan") queries | FOFA API key |
| Quake (360) | Cyberspace mapping — the third major CN engine | Quake API key |
| ShuiZe (水泽) | Automated recon from a domain | optional engine keys |
| MediaCrawler | Xiaohongshu/Douyin/Weibo/Bilibili/Kuaishou/Zhihu/Tieba | login (QR + real account) |
| XHS-Downloader | Xiaohongshu/RedNote (2nd tool) | cookie optional |
| Douyin_TikTok_Download_API | Douyin/TikTok/Kuaishou download (2nd tool) | cookie |
| weibo-crawler / weiboSpider / snscrape | Weibo scraping (3 tools) | cookie/account |
| you-get / BBDown | Bilibili/Youku/Douyin media download | — |
| we-mp-rss | WeChat 公众号 → RSS/PDF | WeChat account |
| PyDork | Baidu-inclusive dorking | — |

### Corporate due diligence (KYC)

| Tool / source | Purpose |
|---------------|---------|
| ENScan_GO | Subsidiaries, ICP 备案, apps, mini-programs, 公众号 from Aiqicha/TianYanCha |
| ICP_Query | Local ICP filing lookup API (domain → registered company) |
| GSXT / 信用中国 | Official state registry & credit blacklist (web, free, Chinese-only) |
| TianYanCha / QCC / Aiqicha | Commercial KYC aggregators (freemium; IP-blocked outside CN) |
| Cninfo | Official filings for listed companies |

Full credential setup, exact command syntax and the step-by-step due-diligence workflow are in [`documents/CHINA_TOOLKIT.md`](documents/CHINA_TOOLKIT.md).

### Network / egress layer

Generic VPN clients (WireGuard, OpenVPN), `proxychains-ng` for per-command SOCKS routing, and circumvention engines (`shadowsocks-libev`, Xray-core, mihomo). Wukong installs the clients; the mainland-China endpoint and configs are supplied by the analyst at runtime, never committed. These make the workstation *appear* inside China — an environment/network posture, distinct from account-identity impersonation, which stays out of scope.

## Architecture

Wukong inherits Speculator's **hub-and-spoke** design:

- `scripts/user.sh` — hub for person-tracking (email, username, fullname, phone, hash)
- Spokes — one script per investigation type: `domain.sh`, `instagram.sh`, `video.sh`, … plus the new **`china.sh`** (Sinophone OSINT) and **`kyc.sh`** (Chinese due diligence)
- `config/tools.conf` — pipe-delimited manifest; adding a tool is a one-line entry
- `scripts/lib/common.sh` — shared library (tool execution, Zenity UI, session logging, evidence output)

Evidence is written to `~/Downloads/evidence/{target}/`. Tools install to `~/.local/share/wukong/programs/`.

## Legal & ethical note

Wukong is for **authorised** open-source research, journalism, and corporate due diligence. Accessing Chinese platforms often intersects with real-name registration law; **impersonation or identity fraud to obtain access is out of scope for OSINT** and may be illegal in your jurisdiction. Know your mandate before you touch a target — see the OPSEC guidance in `documents/CHINA_TOOLKIT.md`.

## Credits

- Built on the [Speculator Project](https://github.com/SOsintOps/Speculator-Project) by SOsintOps.
- China methodology draws on the thesis *"Analisi e Prospettive dell'OSINT in Cina"* (A. Rossetti, Ca' Foscari) and on published work by Bellingcat, OSINT Combine, GIJN, All Source China and Project OSINT.
- Developed with a "vibe coding" workflow assisted by various large language models (LLMs), with human review and validation. See the [FAQ](documentation/04-faq.md#how-was-this-project-built).

## License

MIT — see [LICENSE](LICENSE).

## Disclaimer

Provided "as-is", without warranty, for educational and authorised research purposes. Use responsibly and at your own risk.
