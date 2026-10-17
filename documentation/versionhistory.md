# Version History

Changelog of the releases of Wukong, the China-focused OSINT workstation of SOsintOps.

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
