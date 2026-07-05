# weibo-crawler

**Category:** china (standalone) · **Install:** git clone + venv · **Access:** logged-in cookie
**Source:** <https://github.com/dataabc/weibo-crawler>

## What it is

A mature, well-known **Weibo** crawler (by dataabc) that collects a user's posts
**with media download** and structured export (CSV/JSON/SQLite/MySQL). Where
[snscrape](snscrape.md) gives a quick JSON pull, weibo-crawler is built for
**complete, archival collection** of one or many Weibo accounts, including images
and videos.

## Access required

A **logged-in Weibo cookie**, set in its config file. +86-registered account and
CN proxy recommended to avoid throttling.

## Usage in Wukong

**Standalone** (config-driven). Run from its directory:

```bash
cd ~/.local/share/wukong/programs/weibo-crawler
# edit config.json: user_id_list, cookie, download options, output format
python3 weibo.py
```

Best for building an evidence archive of specific Weibo accounts (posts + media +
metadata) rather than ad-hoc keyword searches.

## Caveats

- Requires editing a config file (user IDs, cookie, options) before each run.
- Media downloads can be large — mind disk in the evidence directory.

## See also

[weibospider](weibospider.md) · [snscrape](snscrape.md) · [MediaCrawler](mediacrawler.md)
