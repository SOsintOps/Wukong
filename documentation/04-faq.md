# Frequently Asked Questions (FAQ)

Common questions about OSINT in general, about investigating China specifically, about analysis and reporting, and about this project.

## Table of Contents

* [What is OSINT?](#what-is-osint)
* [Is OSINT legal?](#is-osint-legal)
* [Passive vs. active — what's the difference?](#passive-vs-active--whats-the-difference)
* [Do I need a special environment?](#do-i-need-a-special-environment)
* [How is Firefox hardened, and can I change it?](#how-is-firefox-hardened-and-can-i-change-it)
* [How do I keep findings credible?](#how-do-i-keep-findings-credible)
* [Why is investigating China "a different craft"?](#why-is-investigating-china-a-different-craft)
* [Do I need to read/type Chinese?](#do-i-need-to-readtype-chinese)
* [Do I need a +86 phone number or a China-based proxy?](#do-i-need-a-86-phone-number-or-a-china-based-proxy)
* [How does the Great Firewall affect collection?](#how-does-the-great-firewall-affect-collection)
* [Can I use a VPN or take my work devices to China?](#can-i-use-a-vpn-or-take-my-work-devices-to-china)
* [Can I do reverse image search on Chinese engines?](#can-i-do-reverse-image-search-on-chinese-engines)
* [How do I investigate a Chinese company?](#how-do-i-investigate-a-chinese-company)
* [What changed with China's real-name / Cyberspace ID rules?](#what-changed-with-chinas-real-name--cyberspace-id-rules)
* [Is scraping Chinese platforms allowed?](#is-scraping-chinese-platforms-allowed)
* [Can Wukong help with Chinese-language Telegram channels?](#can-wukong-help-with-chinese-language-telegram-channels)
* [Can I trust a machine translation?](#can-i-trust-a-machine-translation)
* [How should a report on a Chinese target be written?](#how-should-a-report-on-a-chinese-target-be-written)
* [Are there report templates for Wukong?](#are-there-report-templates-for-wukong)
* [Who is Wukong for?](#who-is-wukong-for)
* [Is Wukong itself a Chinese tool?](#is-wukong-itself-a-chinese-tool)
* [How was this project built?](#how-was-this-project-built)
* [Are there related SOsintOps projects?](#are-there-related-sosintops-projects)
* [Does Wukong guarantee every tool works out of the box?](#does-wukong-guarantee-every-tool-works-out-of-the-box)

---

## General OSINT

### What is OSINT?

**Open-Source Intelligence** is the practice of collecting and analysing information that is **publicly available** — websites, social media, public registries, images, videos, archives — and turning it into structured, verifiable findings. The emphasis is on *public* and *lawful* sources: no hacking, no unauthorised access.

### Is OSINT legal?

Collecting genuinely public information is legal in most jurisdictions, but the **method** matters. Accessing data behind a login you're not entitled to, bypassing technical protections, scraping in violation of a platform's terms, or processing personal data without a lawful basis can all cross legal lines. OSINT is for **authorised** research, journalism, due diligence, and security work. Know your mandate and your local law before you start.

### Passive vs. active — what's the difference?

- **Passive** collection observes without interacting with the target's infrastructure in a way they'd notice (reading public pages, archives, records).
- **Active** collection touches the target directly (port scans, vulnerability probes, sending messages). Active techniques are **out of scope** for pure OSINT and may be illegal without authorisation. Wukong is configured to stay passive by default (for example, its recon tools are pinned to information-gathering, not vulnerability scanning).

### Do I need a special environment?

Yes — a **dedicated, isolated VM** keeps your investigation separate from your personal identity and avoids contaminating evidence. That is exactly what this project builds. Combine it with sensible OPSEC (a clean browser profile, a proxy or VPN where appropriate, no logging into personal accounts).

### How is Firefox hardened, and can I change it?

The installer deploys an enterprise policy (`config/policies.json`) to `/usr/lib/firefox-esr/distribution/policies.json`; Firefox ESR reads it at every start and `about:policies` shows what is active. The policy disables telemetry, Studies, Pocket, Firefox Accounts, form history and the password manager; sets Enhanced Tracking Protection to strict and locks it (trackers, cryptominers, fingerprinters, email trackers and suspected fingerprinting); locks the fingerprinting protection (`privacy.fingerprintingProtection`); disables WebRTC, geolocation, camera and microphone, the battery API, DNS prefetching and link prefetching; turns off Google Safe Browsing (every visited address would otherwise be checked against Google); blocks the camera, microphone, location and notification permissions and autoplay; and clears cache, cookies, history and sessions on shutdown. The 18 extensions and the OSINT bookmarks come from the same file. Locked settings cannot be changed in the Settings page or in `about:config`; the Exploratores start page is not locked. Two settings are deliberately absent because Firefox does not let a policy set them: `privacy.resistFingerprinting` (enable it yourself in `about:config` if you want it; it forces the UTC time zone and a fixed window size, which Chinese platforms with device checks notice) and `beacon.enabled` (uBlock Origin and strict tracking protection block the tracker beacons). To change a locked setting, edit the deployed file and restart Firefox. Brave has its own policy, `/etc/brave/policies/managed/osint.json`, which only force-installs its three extensions; `brave://policy` shows it.

### How do I keep findings credible?

Preserve sources (screenshots, archived copies, hashes), record timestamps, note how each fact was obtained, and corroborate across independent sources. A finding you can't reproduce or attribute is not intelligence — it's a rumour. Grade every item with the 4 x 4 system of the [UNODC *Criminal Intelligence: Manual for Analysts*](https://www.unodc.org/documents/organized-crime/Law-Enforcement/Criminal_Intelligence_for_Analysts.pdf) (source A, B, C or X; information 1 to 4); the [Intelligence Field Notes](field-notes/README.md) explain how, and [05 — Analysis & Reporting](05-analysis-and-reporting.md#evaluating-chinese-sources) how it applies to Chinese registers, state media and platforms.

---

## China OSINT

### Why is investigating China "a different craft"?

Because the Chinese internet is a **parallel ecosystem** with its own platforms, its own search engines, its own language, and its own legal fabric:

- **Different platforms:** WeChat instead of WhatsApp, Weibo instead of X, Baidu instead of Google, Douyin/Xiaohongshu/Bilibili instead of the Western feeds.
- **Language & culture:** sources are in Chinese, often using euphemisms, coded slang, and script variants (Simplified vs. Traditional).
- **Barriers:** censorship, geo-blocking, and real-name registration change what is reachable and how.

Mainstream OSINT manuals barely cover any of this — which is the gap Wukong exists to fill.

### Do I need to read/type Chinese?

To do it well, yes — at least enough to build queries. Machine translation pasted into Baidu returns poor results. Wukong installs a full language layer (Pinyin input, Simplified/Traditional conversion, segmentation, dictionaries) precisely so you can work in Chinese even if you're not fluent. See [tools/language-layer.md](tools/language-layer.md).

### Do I need a +86 phone number or a China-based proxy?

Often, yes — but only for certain sources:

- **Cyberspace search engines** (FOFA, ZoomEye, Quake) need an **API key**, not a phone, and work from any IP.
- **Social scrapers** and **corporate aggregators** (TianYanCha, QCC) usually need a **logged-in account** (which needs a +86 number) and frequently a **mainland-China residential proxy** to avoid blocks and bans.
- The **official registry GSXT is free and public**, but Chinese-only with heavy CAPTCHA.

See [03 — Methodology & Legal](03-methodology-and-legal.md#access-prerequisites-read-first).

### How does the Great Firewall affect collection?

In both directions. From outside, many mainland sites are slow, geo-blocked or show less to a foreign IP; from inside, Google, YouTube, X and Facebook are blocked, so a source in China sees a different internet from yours. Public archives also fail more often: a Wayback Machine capture of a Chinese page can come back empty or behind a login wall, and WeChat links found through Sogou search are temporary. Save a local copy with a SHA-256 hash at the moment of capture, add a public copy (archive.today, Wayback) where it works, and check what was actually saved. Absence of a result says little on the Chinese internet. Details in [05 — Analysis & Reporting](05-analysis-and-reporting.md#the-great-firewall-and-collection).

### Can I use a VPN or take my work devices to China?

This is not legal advice; check your organisation's travel-security policy and your government's travel advice before you go. China's [Cybersecurity Law](https://digichina.stanford.edu/work/translation-cybersecurity-law-of-the-peoples-republic-of-china-effective-june-1-2017/) requires network services such as VPNs to be licensed by the government, and the UK Foreign Office reminds travellers of this in its [China travel advice](https://www.gov.uk/foreign-travel-advice/china/safety-and-security); an unlicensed VPN is therefore outside the rules, whatever the practice. Since 1 July 2024 Ministry of State Security procedures allow officers to inspect phones and laptops in connection with security cases ([RFA](https://www.rfa.org/english/news/china/security-police-check-devices-05082024130107.html)); how often this reaches ordinary travellers is disputed. The [Counter-Espionage Law](https://www.chinalawtranslate.com/en/counter-espionage-law-2023/) covers documents and data related to national security. The prudent course for an analyst is a clean travel device with no case material, no saved sessions to work accounts and nothing on it you could not explain; do not carry Wukong case folders, and treat the device as compromised on return.

### Can I do reverse image search on Chinese engines?

Yes, but manually. Baidu Images and Sogou (`pic.sogou.com`, "以图搜图") support image search, and Yandex is strong on faces/Asia — but there is **no reliable open-source CLI** for them, so you drive them in the browser.

### How do I investigate a Chinese company?

Anchor on the exact legal name or the 18-char Unified Social Credit Code (USCC), verify on **GSXT** (ground truth), enrich with aggregators + `ENScan_GO`, then resolve ownership chains (the hard part — Chinese registries show shareholders but not a natural-person ultimate beneficial owner). Read the capital in 万元 and separate subscribed from paid-in capital; the legal representative is not the owner; check the US and Chinese restricted lists. Full workflow in [03 — Methodology & Legal](03-methodology-and-legal.md), traps and lists in [05 — Analysis & Reporting](05-analysis-and-reporting.md#corporate-data-traps). Tools: [enscan-go.md](tools/enscan-go.md), [icp-query.md](tools/icp-query.md). For a UK parent or subsidiary, [Aethelburg](https://github.com/SOsintOps/Aethelburg-project) does the same work on Companies House data.

### What changed with China's real-name / Cyberspace ID rules?

China's **National Cyberspace ID** has been available since **2025-07-15**. It is voluntary for now ([Caixin Global](https://www.caixinglobal.com/2024-08-26/new-digital-id-system-is-optional-not-mandatory-ministry-researcher-says-102230008.html)), but it tightens the link between online accounts and verified real-world identity. Practically, this raises the OPSEC stakes: impersonation to gain access **leaves OSINT territory and may be illegal**. Stay on public data and know your mandate.

### Is scraping Chinese platforms allowed?

Many Chinese platforms actively block scrapers and prohibit it in their terms. Stick to public data, keep collection minimal, and treat platform terms and local law as real constraints — not obstacles to route around. Personal data about people in China also falls under the [Personal Information Protection Law](https://digichina.stanford.edu/work/translation-personal-information-protection-law-of-the-peoples-republic-of-china-effective-nov-1-2021/).

### Can Wukong help with Chinese-language Telegram channels?

Wukong installs no Telegram tool of its own, but two SOsintOps forks fit the job. [TelEgrapherX](https://github.com/SOsintOps/TelEgrapherX), a fork of Telegram Explorer, collects and analyses groups and channels. [TGchat-analytics](https://github.com/SOsintOps/TGchat-analytics), a fork of chat-analytics, builds statistical reports from Telegram Desktop exports and segments Chinese words, so word statistics make sense for text without spaces. For usernames found in those channels, Maigret Web under **Frameworks** runs the SOsintOps [maigret](https://github.com/SOsintOps/maigret) fork with its web interface.

---

## Analysis and Reporting

### Can I trust a machine translation?

To orient yourself, yes; to conclude, no. Go back to the original characters on every passage a finding rests on, watch for euphemisms that a translator renders literally, and keep the original next to your translation in the report. See [05 — Analysis & Reporting](05-analysis-and-reporting.md#translation-is-a-processing-step).

### How should a report on a Chinese target be written?

As any intelligence report — bottom line first, facts apart from judgements, every source graded, likelihood expressed with one [ICD 203](https://www.dni.gov/files/documents/ICD/ICD-203.pdf) row — with quotations in both languages, names in characters and pinyin at first mention, the state actor named precisely, and the language and access limits stated in the method section. See [05 — Analysis & Reporting](05-analysis-and-reporting.md#the-report) and the common [Report Writing](field-notes/report-writing.md) guide. For the craft of the prose, [awesome-intelligence-writing](https://github.com/SOsintOps/awesome-intelligence-writing) collects manuals and guides on intelligence writing; to stress-test a key judgement before release, [Il Conclave](https://github.com/SOsintOps/il-conclave) (in Italian) runs ACH and a premortem on it as an AI procedure.

### Are there report templates for Wukong?

Wukong ships no templates of its own: use the ones in Speculator's [templates folder](https://github.com/SOsintOps/Speculator-Project/tree/main/templates) (case cover sheet, full and executive reports, a plain Markdown report, subject profile, event assessment, threat notice, research log), which follow the common method. The `.docx` ones open in ONLYOFFICE Desktop Editors, which Wukong installs from its official APT repository. [05 — Analysis & Reporting](05-analysis-and-reporting.md) adds the China-specific rules to apply inside them: quotations in both languages with the translator named, names in characters and pinyin, the Chinese legal name and USCC for companies, dates converted to UTC, the firewall and language limits in the method section, and resident ID numbers and people inside China kept out of anything that travels.

---

## About this project

### Who is Wukong for?

Analysts, journalists, and due-diligence/compliance professionals who need to investigate the Chinese-language internet or Chinese companies and want a ready-made, China-aware environment instead of assembling one by hand.

### Is Wukong itself a Chinese tool?

No. Wukong is an **installer** that sets up a Debian 13 workstation and installs a mix of tools — some made in China (the cyberspace engines, ENScan_GO, MediaCrawler) and many international. It ships no data and phones nothing home; you supply any credentials at runtime.

### How was this project built?

Wukong was developed with a **"vibe coding"** workflow — iterative, conversational development assisted by **various large language models (LLMs)** for scaffolding, research synthesis, and documentation, with human review and validation of the tooling and command syntax. The methodology and source research come from prior human work on OSINT in China (see [02 — Source Material & Context](02-source-material.md)). The way of working with LLM collaborators is written up in [Codex Machinae](https://github.com/SOsintOps/codex-machinae).

### Are there related SOsintOps projects?

Yes:

- [Speculator](https://github.com/SOsintOps/Speculator-Project) is the Debian workstation Wukong forks; Wukong does not install its report templates, but they can be used for Wukong cases (see [Are there report templates for Wukong?](#are-there-report-templates-for-wukong)).
- [Argos](https://github.com/SOsintOps/Argos) is the same idea on Ubuntu Budgie 24.04 or 26.04 LTS.
- [Quaesitor](https://github.com/SOsintOps/quaesitor) is the case graph under **Frameworks**, which keeps a name in characters and its pinyin as one node.
- [Exploratores](https://github.com/SOsintOps/Exploratores) is the browser toolkit; China is on its country-sources roadmap.
- [Aethelburg](https://github.com/SOsintOps/Aethelburg-project) does for UK companies what the KYC layer does for Chinese ones.
- [Elementary CTI](https://github.com/SOsintOps/elementary-CTI) tracks ransomware actors, some of them Chinese-speaking.
- [TelEgrapherX](https://github.com/SOsintOps/TelEgrapherX), [TGchat-analytics](https://github.com/SOsintOps/TGchat-analytics) and [maigret](https://github.com/SOsintOps/maigret) are the SOsintOps forks for Telegram and usernames.
- [Il Conclave](https://github.com/SOsintOps/il-conclave) and [Codex Machinae](https://github.com/SOsintOps/codex-machinae) cover analytic procedures and building tools with LLMs.
- The [Intelligence Field Notes](https://github.com/SOsintOps/intelligence-field-notes) hold the method all of them share.

### Does Wukong guarantee every tool works out of the box?

No. The China toolkit's command templates are validated against each tool's **documented** syntax, but many tools require credentials (API keys, cookies) and some are fragile or unmaintained. Treat "installed" as "ready to configure and test", not "guaranteed to run". See [02 — Source Material & Context](02-source-material.md#what-is-and-isnt-verified).
