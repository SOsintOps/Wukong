# 05 — Analysis & Reporting on Chinese Sources

How to evaluate what Wukong finds and how to write it up, when the sources are Chinese. The common method of the SOsintOps tools (analytic standards, source evaluation, estimative language, report writing) is in the [Intelligence Field Notes](https://github.com/SOsintOps/intelligence-field-notes): personal notes, shared for convenience and with no claim to be exhaustive. A copy for offline reading is in [`field-notes/`](field-notes/README.md). This page covers only what changes on the Chinese-language internet. The collection method and the legal context are in [03 — Methodology & Legal](03-methodology-and-legal.md).

---

## The common method, briefly

- **Grade every item** with the UNODC 4 x 4 system: the source A, B, C or X, the information 1 to 4, written together as `B2`. See [Source Evaluation](field-notes/source-evaluation.md).
- **Say how sure you are** with one ICD 203 likelihood row (almost no chance … almost certain) for events and a confidence level for your judgements, never both in one sentence. See [Estimative Language](field-notes/estimative-language.md).
- **Put the answer first** and keep facts, assumptions and judgements apart. See [Report Writing](field-notes/report-writing.md).

---

## Translation is a processing step

Everything on a Chinese target passes through translation, and a translation is an act of analysis, not a neutral copy.

1. **Translate to orient yourself, not to conclude.** Machine translation tells you what a text is about.
2. **Go back to the original** on every passage a finding rests on, and read the actual characters.
3. **Distrust words that look too ordinary** in a sensitive context: communities talk around censorship with homophones, numbers, images and innocent-looking terms. A translator renders the cover word literally and you miss the point.
4. **Keep the original next to the translation** in your notes and in the report, and record who or what translated it (your own reading, a native speaker, which machine tool).
5. **Build a glossary** of the slang and euphemisms of each platform as you meet them; it is the most reusable product of a China case.

A judgement that depends on how one word is read inherits the uncertainty of that reading. Say so.

---

## Evaluating Chinese sources

The 4 x 4 system applies unchanged; what changes is who the sources are and how they fail.

| Source | How to treat it |
| :--- | :--- |
| **Official registers**: GSXT (national enterprise credit information), Credit China, Cninfo filings | Usually an `A` source for the existence and content of the record. What a company declared about itself (capital, scope, address) is the company's claim, recorded by the state; a record can be old or incomplete. GSXT is the legal ground truth of the [KYC workflow](03-methodology-and-legal.md#layer-3--corporate-due-diligence). |
| **Commercial aggregators**: TianYanCha, QCC, Aiqicha | Copies of the registers plus their own inferences (related parties, risk labels). Check every relevant fact against GSXT; grade the inferred links as the aggregator's analysis, not as registry data. |
| **State and Party media**: Xinhua, People's Daily, CGTN, Global Times | Reliable evidence of the **official position**, and of what the state wants known. Unreliable on facts the state contests. Grade accordingly: an official statement is first-hand for "the ministry said X", not for "X is true". |
| **Social platforms**: Weibo, Douyin, WeChat, Xiaohongshu, Zhihu, Bilibili | Account holders are the source, and most accounts are tied to a real name you cannot see. Content is deleted by censors and by authors, often within hours: capture at once. Expect coordinated amplification and bought engagement. |
| **Leaks**: for example the 2024 i-Soon documents | First assess authenticity (internal consistency, metadata, corroboration with known facts), then grade the content. A genuine leak can still contain boasts and errors. |
| **Overseas Chinese-language media** | Often the only independent reporting; they have their own editorial lines. Grade each outlet on its record, not on its language. |

Two cautions specific to China:
- **Absence of evidence is weak evidence.** The firewall, censorship and deletion mean that not finding something on Chinese platforms says little about whether it happened.
- **Independence is hard to establish.** Many outlets and accounts repeat the same official line or the same original post. Trace each item to its origin before counting it as corroboration.

---

## Names, places and dates

- **Give the characters at first mention**, then pinyin without tone marks: 张伟 (Zhang Wei). Family name first, as in Chinese; do not reorder.
- **Note the script and the romanisation** when they matter: Simplified (mainland) or Traditional (Hong Kong, Macau, Taiwan); Hong Kong names in Cantonese romanisation and Taiwanese names in Wade-Giles or their own spelling. The same person can appear under several spellings; record them all as aliases.
- **Companies:** the registered Chinese legal name and the 18-character Unified Social Credit Code (USCC) identify a company. An English name is usually chosen by the company and not registered; never use it alone.
- **Places:** give the administrative level (province, prefecture-level city, county, district) as well as the name; many place names repeat across provinces.
- **Dates and times:** China uses one time zone, China Standard Time (UTC+8), with no daylight saving. Convert to UTC in the report and keep the local time in brackets when it matters.

---

## Writing about the Chinese state

- **Name the actor precisely.** A ministry, a provincial bureau, a Party organ, a state-owned enterprise, a private company with Party members on the board and a contractor working for a security agency are different things. "China did X" is almost never what the evidence shows.
- **State-owned, state-linked, state-directed:** say which, and how you know (registry shareholding, government contract, official statement).
- **Attribution of cyber or influence operations** follows the same discipline as elsewhere: competing hypotheses, deception considered, confidence stated. A Chinese-language string in code or a UTC+8 timestamp is an indicator, not an attribution.

---

## The report

The structure is the one in [Report Writing](field-notes/report-writing.md), with these additions:
- **Quote in both languages.** The original text in characters, then your translation, with a note of who translated it. Key judgements resting on a single translated phrase say so.
- **Method and limitations** state the language limits (machine translation, dialect, coded language), the access limits (no +86 account, no in-country proxy, deleted content) and the legal posture (passive collection, no impersonation).
- **Protect people inside China.** Names of private individuals who are not the subject, and anything that could identify a source in the country, stay out of a report that travels beyond the case team. The consequences for them are not those of a European data-protection breach.
- **Handling marking** on every report (for example `TLP:AMBER`), set before writing, not after.

---

## Legal limits for the analyst

Three Chinese laws frame what is collected about people and organisations in China, and how it may be handled: the **Personal Information Protection Law** (in force since 1 November 2021), the **Data Security Law** (1 September 2021) and the revised **Counter-Espionage Law** (1 July 2023), which widened what counts as espionage to include documents, data and materials related to national security. An analyst outside China is not thereby subject to Chinese jurisdiction, but anyone who travels there, works with partners there or collects through people there must weigh them, together with the law of their own country and their mandate. The real-name regime and the National Cyberspace ID are covered in [03 — Methodology & Legal](03-methodology-and-legal.md#legal--opsec).

---

## Further reading

- **[Intelligence Field Notes](https://github.com/SOsintOps/intelligence-field-notes)** - The common method and the general [Reading List](field-notes/reading-list.md).
- **"Analisi e Prospettive dell'OSINT in Cina: dalla ricerca delle fonti all'applicazione reale"** (*Analysis and Prospects of OSINT in China: from source research to real-world application*) by Alessandro Rossetti (Ca' Foscari University of Venice, 2025; unpublished thesis, in Italian and Chinese) - The method behind Wukong: the sinophone internet and its barriers, platforms, source validation, 人肉搜索 versus doxing, BLUF writing, case studies.
- **"Xiaohongshu (RedNote): an open source guide"** (Bellingcat, 2026) - How a Chinese platform works and develops its own vocabulary. [bellingcat.com](https://www.bellingcat.com/resources/2026/04/20/xiaohongshu-rednote-open-source-guide/)
- **"OSINT: The Chinese Internet"** (OSINT Combine) - Platforms, search and euphemisms. [osintcombine.com](https://www.osintcombine.com/post/osint-the-chinese-internet)
- **"Information Disorder: Toward an interdisciplinary framework for research and policy making"** by Claire Wardle and Hossein Derakhshan (Council of Europe, 2017) - Mis-, dis- and mal-information. [PDF](https://rm.coe.int/information-disorder-toward-an-interdisciplinary-framework-for-researc/168076277c)
- **"China: New Internet ID System a threat to online expression"** (ARTICLE 19, 2025) - The National Cyberspace ID and what it changes. [article19.org](https://www.article19.org/resources/china-new-internet-id-system-a-threat-to-online-expression/)
- **"OSINT news roundup: China and OPSEC"** (Authentic8) - Operational security for China research. [authentic8.com](https://authentic8.com/blog/osint-news-roundup-china-opsec/)
- **[CC-CEDICT on MDBG](https://www.mdbg.net/chinese/dictionary)** - The online form of the dictionary Wukong installs offline.
