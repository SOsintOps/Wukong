# ENScan_GO

**Category:** kyc (in manifest) · **Install:** git clone + `go build` → `enscan` · **Access:** platform cookies
**Source:** <https://github.com/wgpsec/ENScan_GO>

## What it is

The **cornerstone of Wukong's KYC layer**. Given a Chinese company name, ENScan_GO
(by wgpsec) enumerates in one shot: **subsidiaries and holdings, ICP 备案 filings,
apps, mini-programs (小程序), and WeChat official accounts (公众号)** — aggregating
Aiqicha / TianYanCha / Kuaicha behind a single command. It collapses hours of
manual cross-registry lookup into one query, and has an **MCP mode** for
AI-agent orchestration.

## Access required

**Platform cookies** (Aiqicha/TianYanCha) in its YAML config — because those
aggregators are account-gated. HTTP-only cookies can't be read via
`document.cookie`; grab them from the browser dev-tools network tab. Configure
with `enscan -v`.

## Usage in Wukong

Launched from the **`kyc.sh`** spoke. Manifest id `enscan`.

```
command_template:  enscan -n {target} -o {outdir}
```

```bash
enscan -n "小米科技有限责任公司"                 # default: ICP/Weibo/WeChat/apps
enscan -n "小米" -type tyc                       # a specific data source
enscan -n "小米" -field icp,app                  # only certain fields
enscan -n "小米" -invest 51 --deep 2             # recurse subsidiaries ≥51% stake
enscan --mcp                                     # MCP mode for AI orchestration
```

Flags: `-n` (company name), `-o` (output dir), `-f` (batch file), `-type`
(source: aqc/tyc/kc/rb/all), `-field`, `-invest` + `--deep` (subsidiary recursion).

## Validation status

✅ **Adjusted in the 2026-07-05 session.** `-n` was correct; the session added
**`-o {outdir}`** so output lands in the evidence session directory. Locked by
`tests/test_wukong.sh`. Not yet run live (needs cookies configured).

## Caveats

- **No cookies, no data.** The most common failure is an unconfigured or expired
  cookie in the YAML.
- Enter the **exact Chinese legal name** for best results (from GSXT / an anchor
  step — see the [KYC workflow](../03-methodology-and-legal.md)).

## See also

[ICP_Query](icp-query.md) (domain → company, the anchoring step) · the full
[due-diligence workflow](../03-methodology-and-legal.md).
