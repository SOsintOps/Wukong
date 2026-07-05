# GoFOFA

**Category:** china (standalone) · **Install:** go · **Binary:** `gofofa` · **Access:** FOFA API key
**Source:** <https://github.com/FofaInfo/GoFOFA>

## What it is

FOFA's **official** Go CLI and toolkit. Compared to [Fofax](fofax.md) (a
community client), GoFOFA is maintained by FofaInfo and is stronger for **batch
pipelines** and transformations: cert → domain, icon-hash search, and chaining
queries in scripts.

## Access required

A **FOFA API key** in the GoFOFA config. Same account model as Fofax.

## Usage in Wukong

**Standalone** (not in the GUI manifest — its batch/pipeline nature suits direct
CLI use). Run from PATH:

```bash
gofofa 'domain="example.com"'
gofofa --help                     # subcommands: search, dump, pipeline, ...
```

Typical uses: pull all assets for a set of certs, resolve icon hashes to hosts,
or feed FOFA output into another tool.

## Caveats

- Overlaps with Fofax; pick one per task. GoFOFA is the better choice when you
  need reproducible batch queries or the official feature set.
- Quota-limited like all FOFA access.

## See also

[Fofax](fofax.md) · [FOFA SDK](fofa-sdk.md) · [Kunyu](kunyu.md) / [ZoomEye](zoomeye.md) (the ZoomEye-based alternative).
