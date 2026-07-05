# we-mp-rss

**Category:** china (standalone) · **Install:** git clone + venv · **Access:** WeChat account
**Source:** <https://github.com/rachelos/we-mp-rss>

## What it is

Turns **WeChat Official Accounts (微信公众号)** into RSS / Markdown / PDF feeds.
公众号 are where a huge amount of Chinese organisational, corporate, and
government communication is published — but WeChat is a walled garden with no
public web search. we-mp-rss is a practical way to **monitor and archive** a
公众号's articles over time.

## Access required

A **WeChat account** (to read 公众号 content). Configuration is file-driven.

## Usage in Wukong

**Standalone** (runs as a local service / scheduled fetcher). Run from its venv:

```bash
cd ~/.local/share/wukong/programs/we-mp-rss
# configure the target 公众号 and output format, then start the service
python3 main.py
```

Output (RSS/Markdown/PDF) can be folded into an evidence archive or a monitoring
feed for change detection.

## Caveats

- WeChat account required; 公众号 access is more restricted than open-web sources.
- WeChat actively resists automation — expect fragility and rate limits.

## See also

For monitoring changes over time, pair with the inherited **changedetection.io**
framework tool (see the [project overview](../01-project-overview.md#inherited-arsenal)).
