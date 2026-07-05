# Wukong (悟空) — Documentation

Documentation for **Wukong**, a China-focused OSINT workstation built as a
standalone fork of the [Speculator Project](https://github.com/SOsintOps/Speculator).
Wukong turns a clean Debian 13 "Trixie" VM into an environment for investigating
the Chinese-language internet and performing Chinese corporate due diligence.

> The Monkey King 孙悟空 is said to possess 火眼金睛 — "fiery golden eyes" that see
> through any disguise. That is the ambition of this project: to see clearly into a
> web that is built, by design, to be opaque to outsiders.

---

## How to read this documentation

Start with the general pages, then dive into individual tools as needed.

### General

| Page | What it covers |
|------|----------------|
| [01 — Project Overview](01-project-overview.md) | What Wukong is, its lineage, the three China layers, and the inherited architecture. |
| [02 — Source Material & Context](02-source-material.md) | The texts that were analysed (thesis, Telegram export, online research) and the validation work done on the toolkit. |
| [03 — Methodology & Legal](03-methodology-and-legal.md) | The three-layer method, access prerequisites (API keys, cookies, +86), the corporate due-diligence workflow, and the legal/OPSEC context (Cyberspace ID). |
| [04 — FAQ](04-faq.md) | Common questions on OSINT, China OSINT, and this project. |

### Tools

The [tools index](tools/README.md) lists every China-specific tool Wukong installs,
with one page per tool: what it is, what access it needs, how it is wired into
Wukong, and its caveats.

---

## Scope of these tool pages

The tool pages document the **China-specific** additions — the part that makes
Wukong distinct. Wukong also inherits Speculator's full general-purpose OSINT
arsenal (email, username, phone, hash, domain, social, video, archives, image,
frameworks); those tools are covered by
[Speculator's own documentation](https://github.com/SOsintOps/Speculator) and are
summarised in the [project overview](01-project-overview.md#inherited-arsenal).

---

## A note on honesty

Several tool pages carry a **caveat** section. This is deliberate. Chinese OSINT
tooling is often fragile (platforms change their front-ends), unmaintained (some
tools have not been updated since 2022), or gated behind credentials (an API key,
a logged-in cookie, a +86 phone number). Where a command template has been
validated against a tool's documented syntax but **not yet executed on a live
Debian 13 run**, it is marked as such. Do not read "installed" as "verified to
run in your environment" — see [02 — Source Material & Context](02-source-material.md#what-is-and-isnt-verified).
