# Wukong — China Toolkit Reference

Operational reference for the China-specific tooling installed by `wukong_install.sh`.
Verified against live sources in July 2026. Command templates marked *(provisional)*
must be validated on first real run — they depend on API keys / cookies anyway.

---

## 0. Access prerequisites (read first)

Three recurring access situations govern everything below:

| Situation | Tools | What you need |
|-----------|-------|---------------|
| **Cyberspace engines** | FOFA, Quake, ZoomEye/Kunyu | An **API key** (free tiers are quota-limited; full access often needs a verified Chinese account). Works from any IP. |
| **Social scrapers** | MediaCrawler, Weibo/Douyin/WeChat crawlers | A **logged-in account cookie**. Registering the account usually needs a **+86 phone**; avoiding bans often needs a **mainland-China residential proxy**. |
| **Corporate aggregators** | TianYanCha, QCC, Aiqicha | IP-blocked outside China since ~2022 → **CN proxy + +86 account**. The state registry **GSXT is public and free** but Chinese-only with heavy CAPTCHA. |

> **OPSEC / legal:** prepare the environment (isolated VM, proxy, throwaway identity **within legal limits**) *before* touching a target. Real-name registration law (tightened in July 2025 with the national Cyberspace ID) means impersonation to gain access leaves OSINT territory and may be illegal. Know your mandate first.

---

## 1. Language layer (installed, no credentials needed)

- **Type Chinese:** press **Ctrl+Space** to toggle `fcitx5` Pinyin. Configure engines with `fcitx5-configtool`; diagnose with `fcitx5-diagnose`. On GNOME/Wayland fcitx5 works through the GTK/Qt IM modules (env vars set in `/etc/environment`).
- **Simplified ↔ Traditional:** `opencc -c s2t.json -i in.txt -o out.txt` (and `t2s.json` for the reverse).
- **Offline dictionary:** `dict -d cc-cedict 你好`, or use GoldenDict-NG (GUI).
- **Pinyin / segmentation (Python):** `python3 -c "import pypinyin,jieba"` — both from the Debian repo.

Build a **query in Chinese** before searching: official term + colloquial variants + likely coded form. Pasting a machine translation into Baidu returns poor results.

---

## 2. Sinophone OSINT (`china.sh` spoke)

### Cyberspace engines (API key)

- **Kunyu** — `kunyu console` (interactive). Set the ZoomEye key first: `kunyu init`. Asset recon via ZoomEye (icon/cert/subdomain).
- **ZoomEye CLI** — `zoomeye search <query>` after `zoomeye init`.
- **Fofax** *(provisional)* — `fofax -q 'domain="example.com"'`. Manifest runs `fofax -q {target}`; wrap the target in FOFA syntax for best results. Configure key in `~/.config/fofax/fofax.yaml`.
- **GoFOFA** — `gofofa` official CLI (batch, cert→domain, icon-hash). Config holds the FOFA key.
- **fofa-py** — `fofa` Python SDK/CLI.

### Search & dorking (no key)

- **PyDork** *(provisional)* — dorking including the Baidu engine. Verify subcommand syntax on first run (`pydork --help`); manifest assumes `pydork search baidu <keyword>`.

### Social platforms

- **MediaCrawler** ⭐ (`~/.local/share/wukong/programs/MediaCrawler`) — best coverage: Xiaohongshu, Douyin, Kuaishou, Bilibili, Weibo, Tieba, Zhihu. Config-driven with QR login; run from its venv. Recent versions ship a FastAPI WebUI. **This is the primary Xiaohongshu/RedNote tool.**
- **weibo-crawler / weiboSpider** — Weibo posts/users; edit the config with your cookie, then run.
- **snscrape** *(provisional)* — `snscrape --jsonl weibo-user <user>`. Fragile (HTML endpoints break on front-end changes).
- **you-get** — `you-get --info <url>` then `you-get -o <dir> <url>`. Bilibili/Youku/Douyin/Weibo.
- **BBDown** — `BBDown <BV-id|url>` for Bilibili (subs, 4K). Requires `dotnet`.
- **we-mp-rss** — WeChat 公众号 → RSS/Markdown/PDF; needs a WeChat account.

### Reverse image — web only (no reliable CLI)

Baidu Images (`image.baidu.com`), Sogou (`pic.sogou.com`, "以图搜图"), Yandex (best for faces/Asia). Drive these via the browser; there is no dependable open-source CLI. `search4faces.com` covers VK/OK/TikTok/Clubhouse but **not** Chinese social.

---

## 3. Corporate due diligence (`kyc.sh` spoke)

### Tools installed

- **ENScan_GO** *(provisional)* — `enscan -n "公司中文全名"`. Enumerates subsidiaries, ICP 备案, apps, mini-programs, 公众号 from Aiqicha/TianYanCha/Kuaicha. **Needs platform cookies** in its YAML config (`enscan -v` to configure; HTTP-only cookies can't be read via `document.cookie`). Has an MCP mode (`--mcp`) for AI-agent orchestration.
- **ICP_Query** (`programs/ICP_Query`) — self-hosted async API for `beian.miit.gov.cn`: domain/app/mini-program/enterprise → registered company. Run as a local microservice.

### Registries & databases (mostly web)

| Source | URL | Free? | Access |
|--------|-----|-------|--------|
| **GSXT / NECIPS** (official) | gsxt.gov.cn | Free | Chinese-only, CAPTCHA; ground-truth legal data |
| **信用中国 Credit China** | creditchina.gov.cn | Free | Blacklists, sanctions |
| **Cninfo** (listed cos.) | cninfo.com.cn | Free | Official filings/financials |
| **TianYanCha** | tianyancha.com | Freemium + paid API | CN proxy + +86 account |
| **QCC (Qichacha)** | qcc.com | Freemium + paid API | CN proxy + +86; intl. arm qcckyc.com |
| **Aiqicha** (Baidu) | aiqicha.baidu.com | Freemium | Baidu account; ENScan source |
| Sayari / Datenna | sayari.com / datenna.com | Paid | Strong on UBO / cross-border China chains |

### Due-diligence workflow (how the sources chain)

1. **Anchor identity** — start from the **USCC** (18-char Unified Social Credit Code) or the exact **Chinese legal name**. Only a domain? Run **ICP lookup** to get the registrant, then search that.
2. **Ground truth** — verify on **GSXT**: status, USCC, legal representative, capital, business scope, shareholders.
3. **Enrichment** — **TianYanCha/QCC/Aiqicha** (+ **ENScan_GO** automation) for cross-holdings, litigation, patents, change history, subsidiary map, ICP/apps/公众号.
4. **UBO resolution (the hard part)** — Chinese registries show shareholders but **not** a natural-person UBO. Climb through intermediate holdings (often in other provinces or offshore HK/BVI/Cayman) using the parent jurisdiction's registry + **OpenCorporates/Sayari**. Watch for VIE structures and state-linked entities designed for opacity.
5. **Risk/sanctions** — **信用中国** for blacklists; **Datenna/Sayari** for state links and restricted-party ties.
6. **Cross-check** — Kanzhun (management/staff), ICP domain pivoting (`1in9e/icp-domains`), apps/公众号 via ENScan.

Rule: no single database is authoritative on everything. GSXT = legal ground-truth; aggregators = relational richness; Sayari/Datenna = cross-border chain.

---

## 4. Source map (from the OSINT-in-China research)

- **Curated lists:** `paulpogoda/OSINT-Tools-China`, `OSINT-for-countries/OSINT_in_China`, `paulpogoda/OSINT-for-countries-V2.0`, `start.me/p/7kLY9R/osint-chine`, `cybdetective.com/osintmap`, `osint.place/china`.
- **Guides:** Bellingcat *Challenges of OS Research on China* & *Xiaohongshu/RedNote*; OSINT Combine *The Chinese Internet*; GIJN *Investigating Chinese Companies*; All Source China; Project OSINT.
- **Courses:** OSINT Combine Redbook, EPCyber (china-osint.com), i-intelligence, SANS SEC587.

---

## 5. Known gaps / maintenance notes

- **Command templates** for `china`/`kyc` in `config/tools.conf` are provisional — validate against each tool's `--help` on first run.
- **Reverse image on Chinese engines** and **dedicated Sogou CLIs** have no reliable open-source tooling → browser only.
- **ShuiZe** is unmaintained since 2022; may need a Python 3.11/3.12 venv on Trixie's 3.13.
- **Social scrapers are fragile** — expect breakage when platforms change their front-end.
