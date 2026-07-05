# snscrape (Weibo module)

**Category:** china (in manifest) · **Install:** pipx · **Command:** `snscrape` · **Access:** cookie (fragile)
**Source:** <https://github.com/JustAnotherArchivist/snscrape>

## What it is

A general social-network scraper with modules for many platforms. Wukong uses its
**Weibo** module (`weibo-user`) as a lightweight way to pull a Weibo user's posts
as JSON Lines, without standing up a full crawler.

## Access required

Public data works with no auth, but the Weibo endpoints are HTML-based and often
need a cookie and break when Weibo changes its front-end. Treat it as best-effort.

## Usage in Wukong

Launched from the **`china.sh`** spoke. Manifest id `snscrape-weibo`.

```
command_template:  snscrape --jsonl weibo-user {target} > {outfile}
```

Direct use:

```bash
snscrape --jsonl weibo-user 1234567890               # by numeric user ID
snscrape --jsonl weibo-user --name someusername      # by handle
snscrape --max-results 100 weibo-user 1234567890     # cap results
```

`--jsonl` is a **global** flag and goes **before** the module name. The manifest
`{target}` is a numeric **user ID**; add `--name` for a handle.

## Validation status

✅ Template validated (module `weibo-user`, `--jsonl` global). Not yet run live.

## Caveats

- The Weibo module is **fragile and lightly maintained** — HTML endpoints break.
  For serious Weibo collection prefer [weibo-crawler](weibo-crawler.md) or
  [MediaCrawler](mediacrawler.md); keep snscrape for quick, low-friction pulls.
