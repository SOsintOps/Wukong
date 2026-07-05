# you-get

**Category:** china (in manifest) · **Install:** pipx · **Command:** `you-get` · **Access:** none
**Source:** <https://github.com/soimort/you-get>

## What it is

A widely-used media downloader (56k+ stars) that handles **Chinese video/streaming
platforms** most Western tools ignore: **Bilibili, Youku, Douyin, Weibo, iQIYI**,
alongside YouTube/etc. For China OSINT it is the reliable way to pull and preserve
a video before it disappears.

## Access required

None for public media. Some content may require cookies (region/login-gated).

## Usage in Wukong

Launched from the **`china.sh`** spoke. Two manifest entries:

```
youget      (info):      you-get --info {target} > {outfile}
youget-dl   (download):  you-get -o {outdir} {target}
```

Workflow — inspect first, then download:

```bash
you-get --info 'https://www.bilibili.com/video/BVxxxx'   # list formats/streams
you-get -o ./evidence 'https://www.bilibili.com/video/BVxxxx'
```

## Validation status

✅ Template matches documented syntax (`--info`, `-o`). Standard, well-known tool.

## Caveats

- For Bilibili specifically (4K, embedded subtitles), [BBDown](bbdown.md) is often
  the stronger choice.
- Platform front-end changes can break individual extractors; keep it updated.

## See also

[BBDown](bbdown.md) (Bilibili-specialised) · [MediaCrawler](mediacrawler.md)
(metadata/comments rather than the media file).
