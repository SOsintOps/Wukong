# FOFA SDK (fofa-py)

**Category:** china (standalone) · **Install:** pipx · **Command:** `fofa` · **Access:** FOFA API key
**Source:** FOFA official Python SDK/CLI

## What it is

The official **Python SDK and CLI** for FOFA. Where [Fofax](fofax.md) and
[GoFOFA](gofofa.md) are for the terminal, `fofa-py` is what you reach for when you
want to **script** FOFA queries inside your own Python analysis code.

## Access required

A **FOFA API key** (email + key), configured per the SDK's docs or passed at call
time. Same account/quota model as the other FOFA clients.

## Usage in Wukong

**Standalone.** Available as a CLI (`fofa`) and as an importable module:

```python
import fofa
client = fofa.Client(email="...", key="...")
for host in client.search('domain="example.com"', size=100):
    print(host)
```

Use it when building a repeatable collection script or integrating FOFA results
into a larger pipeline (e.g. enrich a KYC target's domains).

## Caveats

- Three FOFA clients ship with Wukong (fofax, gofofa, fofa-py) — this is
  intentional (terminal / batch / scripting) but you only need the one that fits
  your workflow.
- Quota-limited.

## See also

[Fofax](fofax.md) · [GoFOFA](gofofa.md)
