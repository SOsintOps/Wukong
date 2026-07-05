# Kunyu 坤舆

**Category:** china (standalone) · **Install:** pipx · **Command:** `kunyu` · **Access:** ZoomEye API key
**Source:** <https://github.com/knownsec/Kunyu>

## What it is

An asset-reconnaissance tool built on **ZoomEye** (a cyberspace search engine in
the same family as FOFA/Shodan). Kunyu, by Knownsec, maps an organisation's
internet-facing surface — hosts, certificates, subdomains, icons — through an
interactive console. It is one of the better-maintained Chinese recon tools.

## Access required

A **ZoomEye API key**. Initialise it once, then use the console.

## Usage in Wukong

**Standalone** (interactive console — not suited to the one-shot manifest flow).

```bash
kunyu init          # set the ZoomEye key (first run only)
kunyu console       # interactive session
```

Inside the console you pivot by icon hash, certificate, subdomain, and org. Good
first move when you have a Chinese target domain and want its wider footprint.

## Caveats

- ZoomEye's free quota is limited; heavy recon needs a paid tier.
- Interactive by design — for scripted/batch ZoomEye access use the
  [ZoomEye CLI](zoomeye.md) instead.

## See also

[ZoomEye CLI](zoomeye.md) · FOFA family: [Fofax](fofax.md), [GoFOFA](gofofa.md).
