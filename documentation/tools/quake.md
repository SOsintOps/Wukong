# Quake (360)

**Category:** china (in manifest) · **Install:** release binary · **Binary:** `quake` · **Access:** Quake API key
**Source:** <https://github.com/360quake/quake_rs>

## What it is

The command-line client for **Quake** (360 网络空间测绘), the cyberspace search
engine of Qihoo 360 and the third major Chinese engine alongside FOFA and ZoomEye.
It searches internet-exposed hosts and services (IPs, ports, banners, certificates,
domains). Wukong installs `quake_rs`, the maintained Rust CLI.

## Access required

A **Quake API key**, from the personal centre (个人中心) of your account at
[quake.360.net](https://quake.360.net/). Set it once with `quake init <apikey>`.
Free tiers are quota-limited. Works from any IP (no proxy needed).

## Usage in Wukong

Launched from the **`china.sh`** spoke. Manifest id `quake`.

```
command_template:  quake search {target} > {outfile}
```

```bash
quake init <apikey>
quake search '<query>'
quake --help        # check the flags on first run
```

The installer downloads the x86_64 release binary into `~/.local/bin/quake`; on
other architectures the step is skipped.

## Validation status

⚠️ Provisional. The template follows the documented `search` subcommand but has not
been executed on a live run — it needs a valid API key.

## Caveats

- The `{target}` must be a **Quake query expression**, not a bare word.
- Quota is consumed per query; watch free-tier limits.
- Qihoo 360 is on the US Department of Defense 1260H list; weigh what your queries
  reveal about your case before using a Chinese engine (see
  [05 — Analysis & Reporting](../05-analysis-and-reporting.md#restricted-and-sanctions-lists)).

## See also

[Fofax](fofax.md) · [Kunyu](kunyu.md) · [ZoomEye CLI](zoomeye.md) — the other cyberspace engines installed by Wukong.
