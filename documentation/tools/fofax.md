# Fofax

**Category:** china (in manifest) · **Install:** go · **Binary:** `fofax` · **Access:** FOFA API key
**Source:** <https://github.com/xiecat/fofax>

## What it is

A fast command-line client for **FOFA**, China's equivalent of Shodan — a search
engine over internet-exposed hosts and services. `fofax` runs FOFA queries and
returns matching assets (IPs, domains, certs, titles), with 40+ query operators.

## Access required

A **FOFA API key**, configured in `~/.config/fofax/fofax.yaml`. Free tiers are
quota-limited; deeper access typically needs a verified Chinese FOFA account.
Works from any IP (no proxy needed).

## Usage in Wukong

Launched from the **`china.sh`** spoke. Manifest id `fofax`.

```
command_template:  fofax -q {target} > {outfile}
```

The `{target}` you enter must be a **FOFA query expression**, not a bare word:

```bash
fofax -q 'domain="example.com"'
fofax -q 'app="APACHE-Solr"' -fs 5          # limit to 5 results
echo 'domain="baidu.com"' | fofax -fto       # fetch page titles
```

Key flags: `-q` (query), `-fs` (result count), `-fto` (titles), `-ffi` (full
URLs), `-e` (exclude honeypots), `-ec` (exclude Chinese assets).

## Validation status

✅ Template validated against documented syntax (`-q` = query; stdout redirect
works via the engine's `> {outfile}` handling). Not yet executed on a live run —
needs a valid API key.

## Caveats

- Results are only as good as the FOFA query. Wrap `{target}` in FOFA syntax
  (`domain=`, `ip=`, `cert=`, `app=`, …).
- Quota is consumed per query; watch free-tier limits.

## See also

[GoFOFA](gofofa.md) · [FOFA SDK](fofa-sdk.md) — other FOFA clients installed by Wukong.
