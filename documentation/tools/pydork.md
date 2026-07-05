# PyDork

**Category:** china (in manifest) · **Install:** pipx · **Command:** `pydork` · **Access:** none
**Source:** <https://github.com/blacknon/pydork>

## What it is

A dorking / search-scraping tool that lists text and image results across
**Google, Bing, DuckDuckGo, Baidu, and Yahoo Japan**. For Wukong it earns its
place because of the **Baidu** engine — the dominant search engine in China
(over 80% of Chinese search traffic).

## Access required

None. It scrapes public search results (subject to the usual anti-scraping
friction — a proxy helps for volume).

## Usage in Wukong

Launched from the **`china.sh`** spoke. Manifest id `pydork-baidu`.

```
command_template:  pydork search -t baidu -- {target} > {outfile}
```

Direct use:

```bash
pydork search -t baidu -- 'site:gov.cn 数据泄露'
pydork search -n 20 -t baidu -- '调查关键词'          # 20 results
pydork search -s -t baidu bing -- 'keyword'          # multi-engine (Selenium)
```

The engine is selected with **`-t`**; the query comes **after `--`** (so leading
dashes in the query aren't parsed as flags).

## Validation status

✅ **Fixed in the 2026-07-05 session.** The original template used a positional
engine (`pydork search baidu {target}`), which is not valid syntax. Corrected to
`pydork search -t baidu -- {target}` and locked by `tests/test_wukong.sh`. Not
yet executed on a live run.

## Caveats

- Search scraping breaks when engines change their markup; expect occasional
  maintenance. Selenium mode (`-s`) is more robust but slower.
