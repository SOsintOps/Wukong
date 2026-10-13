# Douyin_TikTok_Download_API

**Category:** china (standalone) · **Install:** git clone + venv · **Access:** cookie
**Source:** <https://github.com/Evil0ctal/Douyin_TikTok_Download_API>

## What it is

A downloader and scraper for **Douyin, TikTok, Kuaishou and Bilibili** short video,
which runs as a local **FastAPI** service. It is Wukong's **second** short-video
tool, next to [you-get](you-get.md) and [MediaCrawler](mediacrawler.md), for when
one of them breaks.

## Access required

A **cookie** from a logged-in session (and, if needed, a proxy), set in the tool's
configuration.

## Usage in Wukong

**Standalone** — run it from its folder and venv:

```bash
cd ~/.local/share/wukong/programs/Douyin_TikTok_Download_API
python start.py         # starts the local API; interactive docs at /docs
```

It can also be used as a library (`douyin-tiktok-scraper`).

## Caveats

- **Fragile by nature** — platforms change their signatures; expect breakage and
  keep the tool updated.
- Stay on public data and keep collection minimal — see
  [03 — Methodology & Legal](../03-methodology-and-legal.md#legal--opsec).

## See also

[you-get](you-get.md) · [BBDown](bbdown.md) · [MediaCrawler](mediacrawler.md).
