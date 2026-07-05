# 04 — FAQ

Common questions about OSINT in general, about investigating China specifically,
and about this project.

---

## General OSINT

### What is OSINT?

**Open-Source Intelligence** is the practice of collecting and analysing
information that is **publicly available** — websites, social media, public
registries, images, videos, archives — and turning it into structured, verifiable
findings. The emphasis is on *public* and *lawful* sources: no hacking, no
unauthorised access.

### Is OSINT legal?

Collecting genuinely public information is legal in most jurisdictions, but the
**method** matters. Accessing data behind a login you're not entitled to,
bypassing technical protections, scraping in violation of a platform's terms, or
processing personal data without a lawful basis can all cross legal lines. OSINT
is for **authorised** research, journalism, due diligence, and security work.
Know your mandate and your local law before you start.

### Passive vs. active — what's the difference?

- **Passive** collection observes without interacting with the target's
  infrastructure in a way they'd notice (reading public pages, archives, records).
- **Active** collection touches the target directly (port scans, vulnerability
  probes, sending messages). Active techniques are **out of scope** for pure OSINT
  and may be illegal without authorisation. Wukong is configured to stay passive
  by default (for example, its recon tools are pinned to information-gathering,
  not vulnerability scanning).

### Do I need a special environment?

Yes — a **dedicated, isolated VM** keeps your investigation separate from your
personal identity and avoids contaminating evidence. That is exactly what this
project builds. Combine it with sensible OPSEC (a clean browser profile, a proxy
or VPN where appropriate, no logging into personal accounts).

### How do I keep findings credible?

Preserve sources (screenshots, archived copies, hashes), record timestamps, note
how each fact was obtained, and corroborate across independent sources. A finding
you can't reproduce or attribute is not intelligence — it's a rumour.

---

## China OSINT

### Why is investigating China "a different craft"?

Because the Chinese internet is a **parallel ecosystem** with its own platforms,
its own search engines, its own language, and its own legal fabric:

- **Different platforms:** WeChat instead of WhatsApp, Weibo instead of X, Baidu
  instead of Google, Douyin/Xiaohongshu/Bilibili instead of the Western feeds.
- **Language & culture:** sources are in Chinese, often using euphemisms, coded
  slang, and script variants (Simplified vs. Traditional).
- **Barriers:** censorship, geo-blocking, and real-name registration change what
  is reachable and how.

Mainstream OSINT manuals barely cover any of this — which is the gap Wukong exists
to fill.

### Do I need to read/type Chinese?

To do it well, yes — at least enough to build queries. Machine translation pasted
into Baidu returns poor results. Wukong installs a full language layer (Pinyin
input, Simplified/Traditional conversion, segmentation, dictionaries) precisely so
you can work in Chinese even if you're not fluent. See
[tools/language-layer.md](tools/language-layer.md).

### Do I need a +86 phone number or a China-based proxy?

Often, yes — but only for certain sources:

- **Cyberspace search engines** (FOFA, ZoomEye) need an **API key**, not a phone,
  and work from any IP.
- **Social scrapers** and **corporate aggregators** (TianYanCha, QCC) usually
  need a **logged-in account** (which needs a +86 number) and frequently a
  **mainland-China residential proxy** to avoid blocks and bans.
- The **official registry GSXT is free and public**, but Chinese-only with heavy
  CAPTCHA.

See [03 — Methodology & Legal](03-methodology-and-legal.md#access-prerequisites-read-first).

### Can I do reverse image search on Chinese engines?

Yes, but manually. Baidu Images and Sogou (`pic.sogou.com`, "以图搜图") support
image search, and Yandex is strong on faces/Asia — but there is **no reliable
open-source CLI** for them, so you drive them in the browser.

### How do I investigate a Chinese company?

Anchor on the exact legal name or the 18-char Unified Social Credit Code (USCC),
verify on **GSXT** (ground truth), enrich with aggregators + `ENScan_GO`, then
resolve ownership chains (the hard part — Chinese registries show shareholders but
not a natural-person ultimate beneficial owner). Full workflow in
[03 — Methodology & Legal](03-methodology-and-legal.md). Tools:
[enscan-go.md](tools/enscan-go.md), [icp-query.md](tools/icp-query.md).

### What changed with China's real-name / Cyberspace ID rules?

China's **National Cyberspace ID** took effect on **2025-07-15**, tightening the
link between online accounts and verified real-world identity. Practically, this
raises the OPSEC stakes: impersonation to gain access **leaves OSINT territory and
may be illegal**. Stay on public data and know your mandate.

### Is scraping Chinese platforms allowed?

Many Chinese platforms actively block scrapers and prohibit it in their terms.
Stick to public data, keep collection minimal, and treat platform terms and local
law as real constraints — not obstacles to route around.

---

## About this project

### Who is Wukong for?

Analysts, journalists, and due-diligence/compliance professionals who need to
investigate the Chinese-language internet or Chinese companies and want a
ready-made, China-aware environment instead of assembling one by hand.

### Is Wukong itself a Chinese tool?

No. Wukong is an **installer** that sets up a Debian 13 workstation and installs a
mix of tools — some made in China (the cyberspace engines, ENScan_GO, MediaCrawler)
and many international. It ships no data and phones nothing home; you supply any
credentials at runtime.

### How was this project built?

Wukong was developed with a **"vibe coding"** workflow — iterative, conversational
development assisted by **various large language models (LLMs)** for scaffolding,
research synthesis, and documentation, with human review and validation of the
tooling and command syntax. The methodology and source research come from prior
human work on OSINT in China (see [02 — Source Material & Context](02-source-material.md)).

### Does Wukong guarantee every tool works out of the box?

No. The China toolkit's command templates are validated against each tool's
**documented** syntax, but many tools require credentials (API keys, cookies) and
some are fragile or unmaintained. Treat "installed" as "ready to configure and
test", not "guaranteed to run". See
[02 — Source Material & Context](02-source-material.md#what-is-and-isnt-verified).
