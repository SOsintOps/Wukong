# weibospider

**Category:** china (standalone) · **Install:** pipx · **Command:** `weibospider` · **Access:** logged-in cookie
**Source:** Weibo post/user scraper (pipx package `weibospider`)

## What it is

A dedicated **Weibo** scraper for posts and user timelines. Weibo (微博) is China's
largest microblog — the closest analogue to X/Twitter — and a core SOCMINT source.
weibospider focuses purely on Weibo, trading breadth for depth on that one platform.

## Access required

A **logged-in Weibo account cookie**. Registration typically needs a **+86 phone**;
a CN residential proxy reduces rate-limiting/bans.

## Usage in Wukong

**Standalone** (cookie/config-driven). Configure the cookie, then run per the
package's CLI/config:

```bash
weibospider --help        # inspect the available commands/flags
```

Use it when Weibo is your specific target and you want a focused, structured pull
rather than MediaCrawler's broad multi-platform approach.

## Caveats

- Cookie required — no cookie, no data.
- Like all Weibo scrapers, subject to front-end changes and anti-bot measures.
- Overlaps with [weibo-crawler](weibo-crawler.md) and [MediaCrawler](mediacrawler.md);
  pick per task.

## See also

[weibo-crawler](weibo-crawler.md) · [snscrape](snscrape.md) · [MediaCrawler](mediacrawler.md)
