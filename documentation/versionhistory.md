# Version History

Changelog of the releases of Wukong, the China-focused OSINT workstation of SOsintOps.

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
