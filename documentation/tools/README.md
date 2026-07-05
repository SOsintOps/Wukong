# Tools — Index

One page per China-specific tool Wukong installs. Each page follows the same
shape: **what it is · access required · how it's wired into Wukong · caveats · source.**

For the general OSINT arsenal inherited from Speculator, see the
[project overview](../01-project-overview.md#inherited-arsenal).

---

## Legend

- **In manifest** — launchable from the Zenity GUI via a spoke (`china.sh` / `kyc.sh`).
  Its `command_template` was validated in the 2026-07-05 session.
- **Standalone** — installed but config-driven or interactive; run it directly from
  `~/.local/share/wukong/programs/<tool>/`. Not in the GUI manifest.

---

## Language & culture layer

| Tool | Role | Page |
|------|------|------|
| fcitx5, opencc, jieba, pypinyin, hanzidentifier | Type / convert / analyse Chinese text | [language-layer.md](language-layer.md) |

## Cyberspace engines ("Chinese Shodan" family)

| Tool | Engine | Access | Status | Page |
|------|--------|--------|--------|------|
| Fofax | FOFA | API key | In manifest | [fofax.md](fofax.md) |
| GoFOFA | FOFA | API key | Standalone | [gofofa.md](gofofa.md) |
| FOFA SDK | FOFA | API key | Standalone | [fofa-sdk.md](fofa-sdk.md) |
| Kunyu | ZoomEye | API key | Standalone | [kunyu.md](kunyu.md) |
| ZoomEye CLI | ZoomEye | API key | Standalone | [zoomeye.md](zoomeye.md) |

## Search & media

| Tool | Target | Access | Status | Page |
|------|--------|--------|--------|------|
| PyDork | Baidu dorking | none | In manifest | [pydork.md](pydork.md) |
| you-get | Bilibili/Youku/Douyin/Weibo media | none | In manifest | [you-get.md](you-get.md) |
| BBDown | Bilibili (4K, subs) | none | Standalone | [bbdown.md](bbdown.md) |

## Social scrapers

| Tool | Platforms | Access | Status | Page |
|------|-----------|--------|--------|------|
| MediaCrawler | XHS/Douyin/Kuaishou/Bilibili/Weibo/Tieba/Zhihu | cookie/QR login | Standalone | [mediacrawler.md](mediacrawler.md) |
| snscrape | Weibo (module) | cookie (fragile) | In manifest | [snscrape.md](snscrape.md) |
| weibospider | Weibo | cookie | Standalone | [weibospider.md](weibospider.md) |
| weibo-crawler | Weibo (+ media) | cookie | Standalone | [weibo-crawler.md](weibo-crawler.md) |
| we-mp-rss | WeChat 公众号 → RSS | WeChat account | Standalone | [we-mp-rss.md](we-mp-rss.md) |

## Domain / infrastructure recon

| Tool | Role | Access | Status | Page |
|------|------|--------|--------|------|
| ShuiZe 水泽 | Asset gathering from a root domain | optional keys | In manifest | [shuize.md](shuize.md) |

## Corporate due diligence (KYC)

| Tool | Role | Access | Status | Page |
|------|------|--------|--------|------|
| ENScan_GO | Company enumeration (subs/ICP/apps/公众号) | platform cookies | In manifest | [enscan-go.md](enscan-go.md) |
| ICP_Query | domain/app → registered company | none (self-hosted) | Standalone | [icp-query.md](icp-query.md) |
