# BBDown

**Category:** china (standalone) · **Install:** dotnet global tool · **Command:** `BBDown` · **Access:** none (cookie for members-only)
**Source:** <https://github.com/nilaoda/BBDown>

## What it is

A specialised **Bilibili** downloader. Bilibili is one of China's largest
video/community platforms; BBDown pulls video at up to 4K, with **embedded
subtitles, danmaku (弹幕), and multi-part series** handled cleanly — things a
generic downloader often mangles.

## Access required

None for public videos. Members-only / high-resolution content may need a
logged-in cookie. Requires the **.NET runtime** (`dotnet`) — the installer skips
BBDown gracefully if dotnet is absent.

## Usage in Wukong

**Standalone.**

```bash
BBDown 'BV1xx411c7XD'                      # by BV id
BBDown 'https://www.bilibili.com/video/BVxxxx'
BBDown --help                              # subtitle/quality/danmaku options
```

## Caveats

- Depends on `dotnet` being installed (`dotnet-sdk` from the Debian repo). If the
  install log shows `dotnet:BBDown` failed, install dotnet and re-run that step.
- Bilibili-only. For Youku/Douyin/Weibo use [you-get](you-get.md).

## See also

[you-get](you-get.md) · [MediaCrawler](mediacrawler.md) (Bilibili metadata/comments).
