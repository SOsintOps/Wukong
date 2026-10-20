# Version History

Changelog of the releases of Wukong, the China-focused OSINT workstation of SOsintOps.

---

## 0.1.8 — 2026

- **Changed:** `config/tools.conf`: the three Consensus entries save every outcome (`-a`), not only the matches, so the HTML report also lists the blocked, rate-limited and inconclusive checks an analyst may want to retry through a proxy. In step with Speculator 0.12.4.
- **Fixed:** the launcher scripts in `scripts/` are now executable in the repository (mode 755), as in Speculator; the installer already set the bit when copying them, so only clones used in place were affected.
- **Docs:** `tests/test_wukong.sh` checks the three Consensus entries of the manifest and the pipx package in the installer.

---

## 0.1.7 — 2026

- **New:** [Consensus](https://github.com/OSINT-Experts-Society/Consensus-OSINT) (OSINT Experts Society, GPL-3.0-or-later), installed with pipx as `consensus-osint[modules,pdf]`: one username, email or phone search over the lookup catalogues of 19 projects (Maigret, Sherlock, WhatsMyName, Holehe, Socialscan, Ignorant, User Scanner and others), with the overlapping checks reconciled, a confidence score per result and HTML, JSON, CSV and PDF reports. It complements the single tools, which stay installed: the repository was created on 8 October 2026 and the project still has to earn its place as the first choice. The Person launcher offers it for usernames and emails (`--fast`, up to 300 checks) and for phone numbers (`config/tools.conf`, three entries, HTML report). No telemetry; the start-up version check against PyPI is disabled with `--no-update-check`, and updates follow `pipx upgrade-all` like the other pipx tools. Their own `install.sh` is not used: it downloads uv and a private Python runtime. Checked on Debian 13.7 (WSL): 232 MB, 40 checks in 13 seconds. In step with Speculator 0.12.3.

---

## 0.1.6 — 2026

- **Fixed:** `config/policies.json`: Firefox silently rejected seven of the sixteen entries of the `Preferences` policy (`privacy.resistFingerprinting`, `privacy.trackingprotection.enabled`, `privacy.trackingprotection.socialtracking.enabled`, `beacon.enabled`, `toolkit.telemetry.enabled`, `toolkit.telemetry.unified`, `datareporting.healthreport.uploadEnabled`), whose prefixes are not on the allow-list of that policy; `about:policies` marked the block "Not fully applied" and fingerprinting resistance had never been active. Tracking protection now comes from the `EnableTrackingProtection` policy (strict category, locked, with cryptomining, fingerprinting, email tracking and suspected fingerprinting), which also sets `browser.contentblocking.category`; `privacy.fingerprintingProtection` (and its private-browsing twin) replaces `privacy.resistFingerprinting`, which no policy can set; the telemetry entries go because `DisableTelemetry` already locks the upload; `beacon.enabled` goes because no policy can set it. In step with Speculator 0.12.2.
- **Docs:** FAQ "How is Firefox hardened, and can I change it?"; the README points to it. `tests/test_wukong.sh` checks `EnableTrackingProtection` and the absence of entries Firefox rejects.

---

## 0.1.5 — 2026

- **Changed:** Firefox ESR extension set (`config/policies.json`) revised against the add-on listings of 17 October 2026, in step with Speculator 0.12.1. Removed GPSDetect and Nimbus Screen Capture (last releases in 2020) and Exif Viewer (code unchanged for years, only re-signed in 2024). Added Exify (EXIF and GPS data), Sputnik, Wappalyzer, IP Address and Domain Information (DNSlytics), Hunter, User-Agent Switcher and Manager, SingleFile (saves the whole page as one HTML file), Web Archives (looks the page up on the Wayback Machine, archive.today, Ghostarchive and the search engine caches) and ArchiveBox (sends the page to the local ArchiveBox). 18 extensions in all; full-page screenshots use the one built into Firefox (Ctrl+Shift+S). Hunter needs an account and sends the visited domains to its service; Wappalyzer is closed source since 2023.
- **New:** Brave gets `config/brave-policies.json`, deployed to `/etc/brave/policies/managed/osint.json`, which force-installs Vortimo, Sputnik and EXIF Viewer Pro, available only on the Chrome Web Store. Checked by `tests/test_wukong.sh`.
- **Docs:** README gains a "Browsers" subsection listing Firefox ESR, Brave and Tor Browser with their extensions.

---

## 0.1.4 — 2026

- **New:** ONLYOFFICE Desktop Editors (`onlyoffice-desktopeditors`) installed from the official ONLYOFFICE APT repository, signed with its key in `/etc/apt/keyrings/onlyoffice.gpg`, so Speculator's `.docx` report templates open and fill with the layout fidelity of Word; tracked as `app:onlyoffice` in the installation summary and checked by `tests/test_wukong.sh`. README ("Reporting") and the FAQ on report templates name it.

---

## 0.1.3 — 2026

- **Docs:** [05 — Analysis & Reporting](05-analysis-and-reporting.md) is customised further for China: court records, commercial-looking state media, Baidu Baike and Zhihu, wolf-warrior and Spamouflage-style accounts and censorship trackers in the source table; the Great Firewall and archiving; corporate data traps (万元 and 亿, subscribed and paid-in capital with the 2024 Company Law five-year rule, the legal representative); the US and Chinese restricted lists; compound surnames, Western name order, Hong Kong and Taiwan names, pinyin ambiguity, the Chinese Commercial Code and the Minguo calendar; resident ID numbers; OSINT versus 人肉搜索; the laws linked to English translations, with the National Intelligence Law, the 2024 State Secrets Law ("work secrets") and the Hong Kong National Security Law and Article 23 Ordinance added. UNODC and ICD 203 are linked at first mention.
- **Docs:** [03 — Methodology & Legal](03-methodology-and-legal.md): China Judgements Online, the enforcement disclosure site, CNIPA, the government procurement portal, the Hong Kong Companies Registry, HKEXnews and Taiwan's company registry added to the registries reference.
- **Docs:** FAQ restructured with a table of contents; new questions on the Great Firewall, VPNs and devices when travelling to China, Chinese-language Telegram channels and report templates (Speculator's templates, with the China rules of 05).
- **Docs:** tool pages for [Quake](tools/quake.md), [XHS-Downloader](tools/xhs-downloader.md) and [Douyin_TikTok_Download_API](tools/douyin-tiktok-download-api.md), which were installed but missing from the tools index and the project overview.
- **Fixed:** `documents/CHINA_TOOLKIT.md` described the National Cyberspace ID as a tightening of real-name law; it is voluntary for now. Its curated lists and courses are now links. The claim that Wukong is the first China-focused OSINT VM is softened to "we know of no other".
- **Docs:** `field-notes/` updated to the Intelligence Field Notes 0.1.2.

---

## 0.1.2 — 2026

- **Fixed:** ENScan_GO installs again: its upstream repository (`wgpsec/ENScan_GO`) was deleted, and the installer now clones the archival mirror [usdagfhjkda/wgpsec-ENScan_GO](https://github.com/usdagfhjkda/wgpsec-ENScan_GO) (Apache-2.0, identical to upstream up to the author's last commit of 28 March 2026). The tool page names [zh0u9527/ENScan_GO](https://github.com/zh0u9527/ENScan_GO) as an active alternative.

---

## 0.1.1 — 2026

- **New:** [Quaesitor](https://github.com/SOsintOps/quaesitor) and [Flowsint](https://github.com/reconurge/flowsint) under **Frameworks**, as in Speculator 0.11.0: Quaesitor on port 5002 with Chinese OCR and ICU transliteration (a name in characters and its pinyin stay one node), Flowsint in Docker on port 5173.
- **Docs:** [05 — Analysis & Reporting](05-analysis-and-reporting.md): how the common method of the [Intelligence Field Notes](https://github.com/SOsintOps/intelligence-field-notes) applies to Chinese sources: translation as a processing step, evaluating registers, aggregators, state media, platforms and leaks with the UNODC 4 x 4 system, names and romanisation, writing about the Chinese state, the report in two languages, the legal limits. `field-notes/` carries an offline copy of the notes.
- **Docs:** FAQ: machine translation, reports on Chinese targets, related SOsintOps projects; the Chinese OSINT guides cited in the README and in `documents/CHINA_TOOLKIT.md` are linked.
- **Known issue:** the upstream repository of ENScan_GO (`wgpsec/ENScan_GO`) no longer exists, so its installer step fails; noted in [02 — Source Material](02-source-material.md) until a replacement source is chosen.
- **Fixed:** [02 — Source Material](02-source-material.md) pointed to a folder that is not public and carried Italian labels and the student number of the thesis; the thesis is now cited in English, as unpublished. The Speculator links point to the `Speculator-Project` repository.

---

## 0.1.0 — 2026

- **New:** First release. A standalone fork of the [Speculator Project](https://github.com/SOsintOps/Speculator-Project) that turns a Debian 13 "Trixie" virtual machine into a workstation for the Chinese-language internet, with three China layers: language and culture (CJK fonts, fcitx5 Pinyin and Rime input, Chinese locales, offline dictionaries), sinophone OSINT (`china.sh`: cyberspace engines, social crawlers, Baidu dorking, media downloaders) and corporate due diligence (`kyc.sh`: ICP lookup, ENScan_GO and the GSXT-first workflow), on top of Speculator's general-purpose arsenal.
- **New:** Quake (360) cyberspace engine, second-choice social tools for redundancy, a network and egress layer, and a static regression test (`tests/test_wukong.sh`).
