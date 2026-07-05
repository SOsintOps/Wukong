# MediaCrawler ⭐

**Category:** china (standalone) · **Install:** git clone + venv · **Access:** logged-in cookie / QR login
**Source:** <https://github.com/NanmiCoder/MediaCrawler>

## What it is

The **flagship social scraper** of the Chinese OSINT toolkit, and the single most
important tool in the sinophone layer. A Playwright-based crawler covering the
platforms that matter for China SOCMINT:

**Xiaohongshu (小红书 / RedNote) · Douyin · Kuaishou · Bilibili · Weibo · Tieba · Zhihu.**

It preserves a login session and drives the real front-end, so it collects public
posts, comments, and profiles without reverse-engineering each platform's JS
encryption. Recent versions ship a **FastAPI WebUI**. This is the primary tool for
**Xiaohongshu**, which Bellingcat and others have flagged as a rich, under-explored
open-source goldmine.

## Access required

A **logged-in account cookie** (or QR login at start). Registering the account
usually needs a **+86 phone**; a **mainland-China residential proxy** reduces bans.
Configuration is file-driven.

## Usage in Wukong

**Standalone** (config-driven with interactive login — not a one-shot manifest
command). Run from its venv:

```bash
cd ~/.local/share/wukong/programs/MediaCrawler
# edit the config (platform, keywords, login mode), then:
python3 main.py --platform xhs --type search
# or launch the WebUI in recent versions
```

## Caveats

- **Fragile by nature** — platforms change front-ends; expect breakage and keep
  it updated.
- Respect the project's stated purpose (research/learning). Stay on public data;
  scraping at volume against account limits gets accounts banned and may cross
  legal lines — see [03 — Methodology & Legal](../03-methodology-and-legal.md#legal--opsec).

## See also

Weibo-specific: [weibospider](weibospider.md), [weibo-crawler](weibo-crawler.md),
[snscrape](snscrape.md). WeChat: [we-mp-rss](we-mp-rss.md).
