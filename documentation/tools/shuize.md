# ShuiZe 水泽

**Category:** china (in manifest) · **Install:** git clone + venv · **Access:** optional FOFA/Shodan/Quake keys
**Source:** <https://github.com/0x727/ShuiZe_0x727>

## What it is

An automated **asset-collection** tool: give it a single root domain and it
gathers the wider footprint — subdomains, related certs, emails, C-segments, and
cyberspace-engine hits (FOFA/Shodan/Quake) — in one pass. An iconic Chinese recon
tool, useful for quickly scoping a Chinese target's infrastructure.

## Access required

Works without keys, but **optional FOFA/Shodan/Quake API keys** enrich results
significantly.

## Usage in Wukong

Launched from the **`china.sh`** spoke. Manifest id `shuize`.

```
command_template:  python3 ShuiZe.py -d {target} --justInfoGather 1
```

```bash
python3 ShuiZe.py -d example.com --justInfoGather 1      # single domain, passive
python3 ShuiZe.py --domainFile domains.txt               # batch
```

Flags: `-d` (single domain), `--domainFile` (batch), `-c` (C-segment),
`--fofaTitle` (FOFA title search), `--justInfoGather 1` (info only).

## Validation status

✅ **Hardened in the 2026-07-05 session.** `-d` was already correct; the session
added **`--justInfoGather 1`** so ShuiZe does **passive information-gathering
only** and does not run its active vulnerability detection — appropriate for an
OSINT (observation, not intrusion) posture. Locked by `tests/test_wukong.sh`.

## Caveats

- ⚠️ **Unmaintained since 2022.** On Debian 13 (Python 3.13) it likely needs a
  dedicated **Python 3.11/3.12 venv** to run. This is the top known runtime risk
  in the toolkit.
- Without `--justInfoGather 1`, ShuiZe attempts active vuln scanning. Keep the
  flag; only remove it if you have explicit authorisation to probe the target.
