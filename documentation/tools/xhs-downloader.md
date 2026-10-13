# XHS-Downloader

**Category:** china (standalone) · **Install:** git clone + venv · **Access:** cookie optional
**Source:** <https://github.com/JoeanAmier/XHS-Downloader>

## What it is

A dedicated extractor and downloader for **Xiaohongshu (小红书 / RedNote)**: post
data, images and videos. It is Wukong's **second** Xiaohongshu tool, kept because
RedNote's anti-scraping is aggressive and a single tool breaks often.

## Access required

None to start; a **cookie** from a logged-in session is optional and improves the
quality of the results.

## Usage in Wukong

**Standalone** — run it from its folder and venv:

```bash
cd ~/.local/share/wukong/programs/XHS-Downloader
python main.py          # interactive TUI
python main.py api      # local API mode
python main.py mcp      # MCP server mode
```

## Caveats

- **Fragile by nature** — RedNote changes its front-end and signatures; keep the
  tool updated.
- Stay on public data and keep collection minimal — see
  [03 — Methodology & Legal](../03-methodology-and-legal.md#legal--opsec).

## See also

[MediaCrawler](mediacrawler.md) — the primary multi-platform tool, also covering Xiaohongshu.
