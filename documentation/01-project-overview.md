# 01 — Project Overview

## What Wukong is

Wukong is a **Bash installer** that configures a clean Debian 13 "Trixie" amd64
virtual machine into a ready-to-use OSINT workstation specialised for **China**.
It is a standalone fork of the Speculator Project: it keeps Speculator's entire
general-purpose OSINT arsenal and adds three layers that Western OSINT distros do
not ship.

The motivating observation — drawn from the source material (see
[02 — Source Material](02-source-material.md)) — is that mainstream OSINT manuals
barely cover the Chinese internet. Bazzell's *OSINT Techniques* (11th ed.)
mentions "China" five times; other standard references treat it as a subject of
analysis, not as a distinct methodology. Yet investigating China requires a
different search stack, a different language competence, and a different legal
posture. No pre-built OSINT VM addresses this. Wukong is an attempt to fill that gap.

### Lineage

```
Argos  →  Speculator  →  Wukong
(base)    (general      (China-focused
           OSINT VM)     spinoff)
```

- **Repository:** `SOsintOps/Wukong` (English).
- **Target OS:** Debian 13 "Trixie" amd64 only.
- **Relationship to Speculator:** standalone fork, not an add-on or plugin.

---

## The three China layers

Wukong's value is entirely in these three additions. Everything else is inherited.

### 1. Language & culture layer

The precondition for everything else. Installed in **Phase 1** of the installer:

- **Input:** `fcitx5` with a Pinyin engine (toggle with `Ctrl+Space`) so the
  analyst can type Chinese queries directly.
- **Rendering:** Simplified (SC) and Traditional (TC) CJK fonts, plus `zh_CN` /
  `zh_TW` locales (enabled for rendering only — the UI stays English/Italian).
- **Conversion & analysis:** `opencc` (Simplified ↔ Traditional), `jieba`
  (word segmentation), `pypinyin` (romanisation), `hanzidentifier`
  (Simplified/Traditional detection), and offline dictionaries.

See [tools/language-layer.md](tools/language-layer.md).

### 2. Sinophone OSINT layer (`china.sh` spoke)

Reconnaissance across the Chinese web, social platforms, and cyberspace:

- **Cyberspace engines:** FOFA (`fofax`, `gofofa`, `fofa` SDK), ZoomEye
  (`zoomeye`, `kunyu`) — the "Chinese Shodan" family.
- **Search & media:** `pydork` (Baidu dorking), `you-get` (Bilibili / Youku /
  Douyin / Weibo media).
- **Social scrapers:** `MediaCrawler` (Xiaohongshu / Douyin / Kuaishou /
  Bilibili / Weibo / Tieba / Zhihu), `weibospider`, `weibo-crawler`, `snscrape`
  (Weibo module), `we-mp-rss` (WeChat 公众号), `BBDown` (Bilibili).
- **Domain recon:** `ShuiZe` (asset gathering from a root domain).

### 3. Corporate due-diligence / KYC layer (`kyc.sh` spoke)

Investigating Chinese companies and ownership chains:

- **`ENScan_GO`** — one-shot enumeration of a company's subsidiaries, ICP
  filings, apps, mini-programs, and WeChat official accounts.
- **`ICP_Query`** — a local microservice that resolves a domain / app to its
  registered company via `beian.miit.gov.cn`.
- Plus a documented workflow over the web registries (GSXT, TianYanCha, QCC,
  Aiqicha, Cninfo) that have no reliable CLI — see
  [03 — Methodology](03-methodology-and-legal.md).

---

## Architecture (inherited from Speculator)

Wukong does **not** redesign Speculator's architecture. It is hub-and-spoke and
manifest-driven, in pure Bash.

```
user.sh (hub — person tracking: email, username, fullname, phone, hash)
  │
  ├─ domain.sh      ├─ instagram.sh   ├─ reddit.sh     ├─ video.sh
  ├─ archives.sh    ├─ image.sh       ├─ frameworks.sh
  ├─ china.sh   ← NEW (sinophone OSINT)
  └─ kyc.sh     ← NEW (corporate due diligence)
```

- **Manifest:** `config/tools.conf` — one pipe-delimited line per tool. Adding a
  tool is a one-line change, not code. Categories now include `china` and `kyc`.
- **Shared library:** `scripts/lib/common.sh` — tool execution, Zenity UI,
  session logging, evidence output. The only Wukong-specific change is the
  install path (`~/.local/share/wukong/` instead of `speculator`).
- **Evidence output:** `~/Downloads/evidence/{target}/`.
- **Installer:** `wukong_install.sh` — forked from `speculator_install.sh`, with
  **Phase 1** carrying the CJK stack and **Phase 3.5** the Chinese toolkit.

Full field format of a manifest line:

```
name|id|category|check_type|check_value|command_template|output_ext|needs_venv|venv_name
```

---

## <a name="inherited-arsenal"></a>Inherited general OSINT arsenal

Beyond the China layers, Wukong ships Speculator's complete toolset, unchanged.
These are documented in the Speculator project; summarised here by category:

| Category | Examples |
|----------|----------|
| Email | Holehe, GHunt, H8Mail, Eyes, Mailcat, Profil3r, SocialScan |
| Username | Sherlock, Maigret, Blackbird, WhatsMyName, Enola, Stalkie, Naminter, Social-Analyzer, Aliens Eye |
| Phone | Ignorant, PhoneInfoga |
| Hash | NameThatHash, SearchThatHash |
| Domain / infra | Amass, Subfinder, Httpx, Nuclei, Sublist3r, theHarvester, Photon, Metagoofil, Fierce |
| Social | Instaloader, Toutatis, Osintgram, BDFR (Reddit) |
| Video | yt-dlp, Streamlink, Gallery-DL |
| Archives | Waybackpy, Waybackpack, Internetarchive, ArchiveBox |
| Image / metadata | Exiftool, Mat2, Xeuledoc, Carbon14, Mediainfo |
| Frameworks | Recon-NG, sn0int, changedetection.io, Maigret Web |

The point of Wukong is that these run **alongside** the China layer: an analyst
can pivot from a Chinese company (KYC) to its domains (`domain.sh`) to the people
behind them (`user.sh`) without leaving the environment.
