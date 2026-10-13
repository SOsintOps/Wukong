# 05 — Analysis & Reporting on Chinese Sources

How to evaluate what Wukong finds and how to write it up, when the sources are Chinese. The common method of the SOsintOps tools (analytic standards, source evaluation, estimative language, report writing) is in the [Intelligence Field Notes](https://github.com/SOsintOps/intelligence-field-notes): personal notes, shared for convenience and with no claim to be exhaustive. A copy for offline reading is in [`field-notes/`](field-notes/README.md). This page covers only what changes on the Chinese-language internet. The collection method, the registries and the legal context are in [03 — Methodology & Legal](03-methodology-and-legal.md).

---

## The common method, briefly

- **Grade every item** with the 4 x 4 system of the [UNODC *Criminal Intelligence: Manual for Analysts*](https://www.unodc.org/documents/organized-crime/Law-Enforcement/Criminal_Intelligence_for_Analysts.pdf): the source A, B, C or X, the information 1 to 4, written together as `B2`. See [Source Evaluation](field-notes/source-evaluation.md).
- **Say how sure you are** with one [ICD 203](https://www.dni.gov/files/documents/ICD/ICD-203.pdf) likelihood row (almost no chance … almost certain) for events and a confidence level for your judgements, never both in one sentence. See [Estimative Language](field-notes/estimative-language.md).
- **Put the answer first** and keep facts, assumptions and judgements apart. See [Report Writing](field-notes/report-writing.md).

---

## Translation is a processing step

Everything on a Chinese target passes through translation, and a translation is an act of analysis, not a neutral copy.

1. **Translate to orient yourself, not to conclude.** Machine translation tells you what a text is about.
2. **Go back to the original** on every passage a finding rests on, and read the actual characters.
3. **Distrust words that look too ordinary** in a sensitive context: communities talk around censorship with homophones, numbers, images and innocent-looking terms. A translator renders the cover word literally and you miss the point.
4. **Keep the original next to the translation** in your notes and in the report, and record who or what translated it (your own reading, a native speaker, which machine tool).
5. **Build a glossary** of the slang and euphemisms of each platform as you meet them; it is the most reusable product of a China case. The [Grass-Mud Horse Lexicon](https://chinadigitaltimes.net/space/About_the_Grass-Mud_Horse_Lexicon) of China Digital Times is a good starting point for the political vocabulary.

A judgement that depends on how one word is read inherits the uncertainty of that reading. Say so.

---

## Evaluating Chinese sources

The 4 x 4 system applies unchanged; what changes is who the sources are and how they fail.

| Source | How to treat it |
| :--- | :--- |
| **Official registers**: GSXT (national enterprise credit information), Credit China, Cninfo filings | Usually an `A` source for the existence and content of the record. What a company declared about itself (capital, scope, address) is the company's claim, recorded by the state; a record can be old or incomplete. GSXT is the legal ground truth of the [KYC workflow](03-methodology-and-legal.md#layer-3--corporate-due-diligence). |
| **Court and enforcement records**: China Judgements Online, the enforcement disclosure site | What is published is genuine; what is missing is not evidence. Millions of judgements were removed from China Judgements Online from 2021 and administrative cases almost entirely ([ChinaFile](https://www.chinafile.com/reporting-opinion/viewpoint/verdicts-chinas-courts-used-be-accessible-online-now-theyre-disappearing)). A clean search proves nothing. The sites are listed in the [registries reference](03-methodology-and-legal.md#registries-reference). |
| **Commercial aggregators**: TianYanCha, QCC, Aiqicha | Copies of the registers plus their own inferences (related parties, risk labels). Check every relevant fact against GSXT; grade the inferred links as the aggregator's analysis, not as registry data. |
| **State and Party media**: Xinhua, People's Daily, CGTN, Global Times | Reliable evidence of the **official position**, and of what the state wants known. Unreliable on facts the state contests. Grade accordingly: an official statement is first-hand for "the ministry said X", not for "X is true". |
| **Commercial-looking media** | Look at the owner, not the design. The Paper (澎湃新闻) reads like a commercial site and belongs to the state-owned Shanghai United Media Group ([State Media Monitor](https://statemediamonitor.com/2024/09/shanghai-united-media-group-sumg/)). Caixin (财新) is commercial and known for investigative reporting, but it publishes inside the same censorship limits and has had articles removed. Neither is independent in the Western sense; grade each on its own record. |
| **User-edited reference and Q&A**: Baidu Baike (百度百科), Zhihu (知乎) | Anyone can edit or answer, and entries are shaped by censorship. Use them for leads and terminology, never as the source of a finding; trace the claim to its origin. |
| **Social platforms**: Weibo, Douyin, WeChat, Xiaohongshu, Zhihu, Bilibili | Account holders are the source, and most accounts are tied to a real name you cannot see. Content is deleted by censors and by authors, often within hours: capture at once. Expect coordinated amplification and bought engagement. |
| **Diplomats and coordinated networks abroad** | "Wolf-warrior" diplomatic accounts on X are first-hand for the official line, nothing more. Networks of fake or hijacked accounts, such as Spamouflage, push the same messages across dozens of platforms; volume is not corroboration ([Graphika, *Spamouflage Breakout*](https://graphika.com/reports/spamouflage-breakout); [Meta, Q2 2023 Adversarial Threat Report](https://transparency.meta.com/reports/integrity-reports-q2-2023/)). |
| **Censorship trackers**: China Digital Times, [GreatFire](https://en.greatfire.org/), [Citizen Lab](https://citizenlab.ca/2020/05/we-chat-they-watch/) | Sources about deletion and blocking: what was removed, when, and which words are filtered. Useful to explain a gap in your collection; grade them as you would any research outlet. |
| **Chinese companies and partners as sources** | Under Article 7 of the [National Intelligence Law](https://www.chinalawtranslate.com/en/national-intelligence-law-of-the-p-r-c-2017/) all organisations and citizens must "support, assist, and cooperate with national intelligence efforts". How far this is enforced is debated ([China Law Translate](https://www.chinalawtranslate.com/en/what-the-national-intelligence-law-says-and-why-it-doesnt-matter/)), but it belongs in the assessment of any Chinese company, contact or data provider whose reporting you rely on, and of where your queries end up. |
| **Leaks**: for example the 2024 i-Soon documents | First assess authenticity (internal consistency, metadata, corroboration with known facts), then grade the content. A genuine leak can still contain boasts and errors. |
| **Overseas Chinese-language media** | Often the only independent reporting; they have their own editorial lines. Grade each outlet on its record, not on its language. |

Two cautions specific to China:
- **Absence of evidence is weak evidence.** The firewall, censorship and deletion mean that not finding something on Chinese platforms says little about whether it happened.
- **Independence is hard to establish.** Many outlets and accounts repeat the same official line or the same original post. Trace each item to its origin before counting it as corroboration.

---

## The Great Firewall and collection

The firewall filters in both directions, and it changes what a capture can prove.

- **From outside**, many mainland sites are slow, geo-blocked or show less to a foreign IP, and the corporate aggregators refuse it ([access prerequisites](03-methodology-and-legal.md#access-prerequisites-read-first)). **From inside**, Google, YouTube, X and Facebook are blocked; a source in China sees a different internet from yours. GreatFire's [Analyzer](https://en.greatfire.org/analyzer) shows whether a site is blocked in China.
- **Public archives can fail.** A Wayback Machine capture of a Chinese page can come back empty, behind a login wall or without the JavaScript-rendered text. Check what was actually saved before you cite it.
- **WeChat links are fragile.** Article links returned by Sogou's WeChat search are temporary and stop working; authors and censors delete articles, which then show a deletion notice. Save the content at once, and record the stable `mp.weixin.qq.com/s/...` form of the link when you have it.
- **Archive in two ways**: a public copy where it works ([archive.today](https://archive.ph/), the [Wayback Machine](https://web.archive.org/)), and always a local capture (full page, screenshot, WARC or PDF) with a SHA-256 hash recorded at capture, as in [OSINT Methodology](field-notes/osint-methodology.md#collection-discipline) and [Source Evaluation](field-notes/source-evaluation.md#provenance-and-preservation).
- **Capture from inside China only within legal limits**: an in-country proxy changes what you can see, not what you are allowed to do. Never ask a person in China to collect for you without weighing the risk to them (see the laws below).

---

## Corporate data traps

Chinese company records are precise, and easy to misread.

- **Magnitudes.** Registered capital is usually shown in **万元** (units of 10,000 yuan): `注册资本 500万元` is 5 million RMB, not 500. **亿** is 100 million. Check the currency too: foreign-invested companies may register in USD or HKD.
- **Subscribed is not paid.** **认缴** (subscribed) capital is a promise; **实缴** (paid-in) is what was actually contributed. A large subscribed capital with no paid-in capital says little about resources. Since the revised Company Law took effect on 1 July 2024, shareholders of a limited liability company must pay subscribed capital in full within five years of incorporation; companies formed earlier have a transition period, to 30 June 2032 for limited liability companies ([Jones Day](https://www.jonesday.com/en/insights/2024/07/chinas-revised-company-law-introduces-significant-changes)). A capital reduction notice on GSXT can be a sign of a shell adjusting to the rule.
- **The legal representative is not the owner.** The **法定代表人** signs for the company and carries legal liability; nominees are common. Ownership is in the shareholder list, and control often sits one or more layers up ([UBO resolution](03-methodology-and-legal.md#layer-3--corporate-due-diligence)).
- **Names in English are not legal names**: see [Names, places and dates](#names-places-and-dates).

### Restricted and sanctions lists

Check every company and person of interest, and every parent, against the lists that matter for China. Matching is by name and address, so search the Chinese name, every English variant and the aliases.

| List | Who keeps it | Where |
| :--- | :--- | :--- |
| **Entity List** (export controls) | US Department of Commerce, BIS | [bis.gov/entity-list](https://www.bis.gov/entity-list) |
| **UFLPA Entity List** (forced labour, Xinjiang) | US Department of Homeland Security | [dhs.gov/uflpa-entity-list](https://www.dhs.gov/uflpa-entity-list) |
| **Section 1260H list** ("Chinese military companies") | US Department of Defense, published in the Federal Register | [2026 notice](https://www.federalregister.gov/documents/2026/06/10/2026-11571/notice-of-availability-of-designation-of-chinese-military-companies) |
| **SDN List** (sanctions) | US Treasury, OFAC | [Sanctions List Search](https://sanctionssearch.ofac.treas.gov/) |
| **Unreliable Entity List** (China's counter-list of foreign entities) | Ministry of Commerce (MOFCOM) | announcements on the [Bureau of Industry Security, Import and Export Control](https://aqygzj.mofcom.gov.cn/) site (Chinese) |

Domestic blacklists (Credit China, the enforcement disclosure site) are in [03 — Methodology & Legal](03-methodology-and-legal.md#registries-reference). A listing is a fact about the list, recorded by its keeper; the reason given for it is the keeper's assessment, and the 1260H list in particular changes every year.

---

## Names, places and dates

- **Give the characters at first mention**, then pinyin without tone marks: 张伟 (Zhang Wei). Family name first, as in Chinese; do not reorder.
- **Expect reordering abroad.** The same person may sign "Wei Zhang" on a Western CV or company filing. Compound surnames such as 欧阳 (Ouyang) or 司马 (Sima) are two characters; do not split them into a surname and a given name.
- **Hong Kong and Taiwan** add English given names (陳大文 / Peter Chan Tai-man), Cantonese or Wade-Giles romanisations and hyphenated given names. Record every form as an alias.
- **One pinyin, many people.** "Zhang Wei" stands for many different character combinations (张伟, 张薇, 章巍…) and a very large number of people. Never match people on pinyin alone; match on characters plus another identifier.
- **Chinese Commercial Code** ([Chinese telegraph code](https://en.wikipedia.org/wiki/Chinese_telegraph_code)): a four-digit number per character, still printed on Hong Kong identity cards and asked for in US visa forms. When a document gives the codes, they fix the characters behind a romanised name.
- **Note the script and the romanisation** when they matter: Simplified (mainland) or Traditional (Hong Kong, Macau, Taiwan); Hong Kong names in Cantonese romanisation and Taiwanese names in Wade-Giles or their own spelling.
- **Companies:** the registered Chinese legal name and the 18-character Unified Social Credit Code (USCC) identify a company. An English name is usually chosen by the company and not registered; never use it alone.
- **Places:** give the administrative level (province, prefecture-level city, county, district) as well as the name; many place names repeat across provinces.
- **Dates and times:** China uses one time zone, China Standard Time (UTC+8), with no daylight saving. Convert to UTC in the report and keep the local time in brackets when it matters. **Taiwan** dates official documents in the [Minguo calendar](https://en.wikipedia.org/wiki/Minguo_calendar): add 1911 to the year (民國113年 is 2024).

---

## Writing about the Chinese state

- **Name the actor precisely.** A ministry, a provincial bureau, a Party organ, a state-owned enterprise, a private company with Party members on the board and a contractor working for a security agency are different things. "China did X" is almost never what the evidence shows.
- **State-owned, state-linked, state-directed:** say which, and how you know (registry shareholding, government contract, official statement).
- **Attribution of cyber or influence operations** follows the same discipline as elsewhere: competing hypotheses, deception considered, confidence stated. A Chinese-language string in code or a UTC+8 timestamp is an indicator, not an attribution.

---

## The report

The structure is the one in [Report Writing](field-notes/report-writing.md), with these additions:
- **Quote in both languages.** The original text in characters, then your translation, with a note of who translated it. Key judgements resting on a single translated phrase say so.
- **Method and limitations** state the language limits (machine translation, dialect, coded language), the access limits (no +86 account, no in-country proxy, deleted content, firewall) and the legal posture (passive collection, no impersonation).
- **Protect people inside China.** Names of private individuals who are not the subject, and anything that could identify a source in the country, stay out of a report that travels beyond the case team. The consequences for them are not those of a European data-protection breach.
- **Treat resident ID numbers as sensitive data.** The 18-digit number of a mainland [Resident Identity Card](https://en.wikipedia.org/wiki/Resident_Identity_Card) encodes the place of registration, the date of birth and the sex (odd or even sequence digit), with a check digit. Leaked numbers circulate widely; quote one only when the case needs it, and redact it in anything that travels.
- **Handling marking** on every report (for example `TLP:AMBER`), set before writing, not after.

---

## OSINT is not 人肉搜索

**人肉搜索** ("human-flesh search") is crowd-sourced exposure: netizens pool what they find about a person, publish it and often push harassment offline ([background](https://en.wikipedia.org/wiki/Human_flesh_search_engine)). Some of its techniques look like OSINT; its purpose and its method do not. Responsible collection has a mandate and a question, stays proportionate to it, does not publish personal data for its own sake, protects bystanders and keeps the product inside the people entitled to it. The [legal and ethical limits](field-notes/osint-methodology.md#legal-and-ethical-limits) of the common method apply unchanged.

---

## Legal limits for the analyst

The laws that matter to an analyst, briefly. This is orientation, not legal advice.

- **Personal data and data:** the [Personal Information Protection Law](https://digichina.stanford.edu/work/translation-personal-information-protection-law-of-the-peoples-republic-of-china-effective-nov-1-2021/) (in force since 1 November 2021) and the [Data Security Law](https://digichina.stanford.edu/work/translation-data-security-law-of-the-peoples-republic-of-china/) (1 September 2021) frame what is collected about people and organisations in China and how it may leave the country.
- **Networks and real names:** the [Cybersecurity Law](https://digichina.stanford.edu/work/translation-cybersecurity-law-of-the-peoples-republic-of-china-effective-june-1-2017/) (2017), amended in October 2025 with effect from 1 January 2026 ([CSET translation of the amended text](https://cset.georgetown.edu/publication/china-cybersecurity-law-2025/)), carries the real-name rules and requires licences for network services such as VPNs.
- **Espionage and secrets:** the revised [Counter-Espionage Law](https://www.chinalawtranslate.com/en/counter-espionage-law-2023/) (1 July 2023) widened espionage to documents, data and materials related to national security. The revised [Law on Guarding State Secrets](https://www.chinalawtranslate.com/en/secrets-law-2024/) (1 May 2024) adds **work secrets** (Article 64): information that is not a state secret but whose leak "would cause certain adverse effects". Internal documents of agencies and state companies can fall here even when unclassified.
- **Intelligence:** the [National Intelligence Law](https://www.chinalawtranslate.com/en/national-intelligence-law-of-the-p-r-c-2017/) (2017), Article 7: the duty of organisations and citizens to cooperate, discussed under [Evaluating Chinese sources](#evaluating-chinese-sources).
- **Hong Kong:** the [National Security Law](https://www.elegislation.gov.hk/hk/A406) (30 June 2020) and the [Safeguarding National Security Ordinance](https://www.nsed.gov.hk/assets/pdf/Pamphlet_en.pdf) (Article 23 legislation, in force since 23 March 2024), which adds offences on state secrets, espionage and external interference. Both claim reach beyond Hong Kong. People in Hong Kong who talk to you, and Hong Kong sources you cite, can be exposed by the contact itself: weigh this before approaching anyone and before naming anyone.

An analyst outside China is not thereby subject to Chinese jurisdiction, but anyone who travels there, works with partners there or collects through people there must weigh these laws, together with the law of their own country and their mandate. The real-name regime and the National Cyberspace ID are covered in [03 — Methodology & Legal](03-methodology-and-legal.md#legal--opsec); travel and devices in the [FAQ](04-faq.md#can-i-use-a-vpn-or-take-my-work-devices-to-china).

---

## Further Reading

- **[Intelligence Field Notes](https://github.com/SOsintOps/intelligence-field-notes)** - The common method and the general [Reading List](field-notes/reading-list.md).
- **"Analisi e Prospettive dell'OSINT in Cina: dalla ricerca delle fonti all'applicazione reale"** (*Analysis and Prospects of OSINT in China: from source research to real-world application*) by Alessandro Rossetti (Ca' Foscari University of Venice, 2025; unpublished thesis, in Italian and Chinese) - The method behind Wukong: the sinophone internet and its barriers, platforms, source validation, 人肉搜索 versus doxing, BLUF writing, case studies.
- **"Xiaohongshu (RedNote): an open source guide"** by Chu Yang (Bellingcat, 2026) - How a Chinese platform works and develops its own vocabulary. [bellingcat.com](https://www.bellingcat.com/resources/2026/04/20/xiaohongshu-rednote-open-source-guide/)
- **"OSINT: The Chinese Internet"** by Emerald Sage (OSINT Combine) - Platforms, search and euphemisms. [osintcombine.com](https://www.osintcombine.com/post/osint-the-chinese-internet)
- **"Information Disorder: Toward an interdisciplinary framework for research and policy making"** by Claire Wardle and Hossein Derakhshan (Council of Europe, 2017) - Mis-, dis- and mal-information. [PDF](https://rm.coe.int/information-disorder-toward-an-interdisciplinary-framework-for-researc/168076277c)
- **"China: New Internet ID System a threat to online expression"** by ARTICLE 19 (2025) - The National Cyberspace ID and what it changes. [article19.org](https://www.article19.org/resources/china-new-internet-id-system-a-threat-to-online-expression/)
- **"OSINT news roundup: China and OPSEC"** by Abel Vandegrift (Authentic8) - Operational security for China research. [authentic8.com](https://authentic8.com/blog/osint-news-roundup-china-opsec/)
- **"What the National Intelligence Law Says, and Why It Doesn't Matter"** by Jeremy Daum (China Law Translate) - A close reading of Article 7. [chinalawtranslate.com](https://www.chinalawtranslate.com/en/what-the-national-intelligence-law-says-and-why-it-doesnt-matter/)
- **"Spamouflage Breakout"** by Graphika (2021) - The pro-China network that posts across platforms. [graphika.com](https://graphika.com/reports/spamouflage-breakout)
- **[Grass-Mud Horse Lexicon](https://chinadigitaltimes.net/space/About_the_Grass-Mud_Horse_Lexicon)** by China Digital Times - The coded vocabulary netizens use against censorship.
- **[CC-CEDICT on MDBG](https://www.mdbg.net/chinese/dictionary)** - The online form of the dictionary Wukong installs offline.
