# ICP_Query

**Category:** kyc (standalone) · **Install:** git clone + venv (local microservice) · **Access:** none
**Source:** <https://github.com/HG-ha/ICP_Query>

## What it is

A self-hosted async API that queries China's official **ICP 备案** registry
(`beian.miit.gov.cn`). Every website legally served in mainland China must carry
an ICP filing tied to a registered entity. ICP_Query resolves a **domain, app, or
mini-program → the registered company**. In the KYC workflow it is the
**anchoring step**: when all you have is a Chinese website, this is how you find
who is legally behind it.

## Access required

None beyond running the service locally (no account/cookie). It talks to the
public MIIT registry.

## Usage in Wukong

**Standalone** — run it as a **local microservice**, then query over HTTP:

```bash
cd ~/.local/share/wukong/programs/ICP_Query
python3 main.py                       # start the local API service
# then query it, e.g.:
curl 'http://127.0.0.1:16181/query/web?search=example.com'
```

(Check the project's README for the exact port and endpoint paths.)

## Where it fits

1. Have only a domain? → **ICP_Query** gives the registrant company.
2. Take that exact Chinese name into **GSXT** (ground truth) and
   [ENScan_GO](enscan-go.md) (enrichment).

See the full [due-diligence workflow](../03-methodology-and-legal.md).

## Caveats

- The MIIT registry uses CAPTCHA/anti-bot; the service handles this but can be
  rate-limited or break if MIIT changes its front-end.
- Runs as a persistent local service, not a one-shot command — hence standalone,
  not in the GUI manifest.

## See also

[ENScan_GO](enscan-go.md) · [Methodology & Legal](../03-methodology-and-legal.md)
