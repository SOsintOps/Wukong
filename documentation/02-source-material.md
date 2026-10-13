# 02 — Source Material & Context

This page records **what Wukong is built on** — the texts that were analysed to
shape its scope — and **what work has actually been done and verified**, so that
nobody mistakes "installed" for "proven to run".

---

## The analysed texts

The source material is not part of this repository: the thesis is unpublished and
the Telegram export and research notes are working files. Three bodies of material
were analysed.

### 1. Primary source — the thesis

*"Analisi e Prospettive dell'OSINT in Cina — Dalla ricerca delle fonti
all'applicazione reale"* (*Analysis and Prospects of OSINT in China: from source
research to real-world application*) — Alessandro Rossetti, academic year 2024/2025,
Ca' Foscari University of Venice, Oriental Languages and Literatures. 116 pages,
in Italian and Chinese (中文); unpublished. Nine chapters:

| Ch. | Topic |
|-----|-------|
| 1 | Introduction — context, motivation, seven objectives |
| 2 | The sinophone internet — technologies and barriers (incl. the Geedge-MESA leak) |
| 3 | Chinese platform ecosystem — search engines, social & instant messaging |
| 4 | Intelligence & OSINT fundamentals — cycle, ethics/legality, **OPSEC**, tooling (VM, VPN, SIM) |
| 5 | Research & analysis strategies — source validation, **人肉搜索 renrou sousuo vs doxing**, link analysis, social listening, GEOINT, BLUF writing |
| 6 | Operational tools & techniques — Python scripts, online services, repositories, databases |
| 7 | Case studies — iSoon, anti-fraud, PLA, corporate KYC, fentanyl, cyber influence, Geedge-MESA |
| 8 | The potential of modern LLMs — monitoring automation, contextual translation, source evaluation |
| 9 | Conclusions & prospects |

The thesis is the methodological backbone: the three-layer design of Wukong
(language, sinophone OSINT, KYC) maps directly onto its chapters 2–3 (barriers &
platforms), 4–6 (method & tooling), and 7 (the corporate/KYC case studies). Its
chapters 4 and 5 on intelligence fundamentals, source validation and BLUF writing
are the basis of [05 — Analysis & Reporting](05-analysis-and-reporting.md), which
applies the common [Intelligence Field Notes](https://github.com/SOsintOps/intelligence-field-notes)
to Chinese sources.

### 2. Secondary source — the Cyber Detective channel

Analysis of the Cyber Detective channel (3,470 messages, 2021→2026), of which
68 were China-relevant. Each curated link was checked one-by-one on 2026-06-17;
only one was dead. This surfaced the concrete tool inventory (fofa, you-get,
snscrape, Baidu/Sogou reverse image, MediaCrawler, ENScan_GO, …) that Wukong installs.

### 3. Online research (June–July 2026)

Fresh web research validated the tool inventory against the live state of the art
and added the legal context. Key confirmations:

- **ENScan_GO** (wgpsec) was actively maintained in July 2026, with an MCP mode
  for AI orchestration. **Update, October 2026:** the `wgpsec/ENScan_GO`
  repository no longer exists (GitHub returns 404), so the installer step that
  clones it fails; a replacement source is still to be chosen.
- **MediaCrawler** ([NanmiCoder](https://github.com/NanmiCoder/MediaCrawler)) is
  the reference multi-platform social crawler, now with a WebUI.
- **KYC:** GSXT is the free official ground-truth; TianYanCha / QCC are ~95%
  equivalent commercial aggregators, both gated behind a +86 number.
- **Legal:** China's **National Cyberspace ID** took effect **2025-07-15**,
  tightening real-name identity — a material OPSEC consideration (see
  [03 — Methodology & Legal](03-methodology-and-legal.md#legal--opsec)).
- **Differentiation confirmed:** no pre-built OSINT VM is dedicated to China —
  Wukong is the first.

---

## What was done to the toolkit (validation session, 2026-07-05)

The China/KYC tool inventory was scaffolded, then its command templates were
**validated against each tool's real, documented CLI syntax**. Findings:

| Tool | Before | Verdict | After |
|------|--------|---------|-------|
| `fofax` | `fofax -q {target}` | ✅ correct | unchanged |
| `you-get` | `--info` / `-o` | ✅ correct | unchanged |
| `snscrape` | `--jsonl weibo-user {target}` | ✅ correct | unchanged |
| **`pydork`** | `search baidu {target}` | ❌ **bug** (positional engine) | `search -t baidu -- {target}` |
| `ShuiZe` | `-d {target}` | ⚠️ ran active vuln-scan | `-d {target} --justInfoGather 1` (passive) |
| `ENScan_GO` | `-n {target}` | ⚠️ output not captured | `-n {target} -o {outdir}` |

Before touching templates, the execution engine in `common.sh` was inspected to
confirm that `> {outfile}` redirection actually works (it is detected by regex
before the command is split into an argv array — so it does).

A static regression harness was added: **`tests/test_wukong.sh`** (51 checks,
all passing). It validates the manifest, field integrity, spoke wiring, and locks
the three template fixes so a future regression fails the test. It runs anywhere
(no Zenity, network, or installed tools required):

```bash
bash tests/test_wukong.sh
```

---

## <a name="what-is-and-isnt-verified"></a>What is — and isn't — verified

This distinction matters for anyone relying on Wukong.

**Verified (on the development host, any OS):**

- All scripts pass `bash -n` (syntax).
- `tests/test_wukong.sh` passes 51/51 (manifest + wiring + template regression).
- Command templates match each tool's **documented** syntax.

**NOT yet verified (requires a live Debian 13 VM):**

- The installer has never been run end-to-end — only syntax-checked and dry-run.
- No China tool has been **executed**. "Templates match documentation" is not
  "the command produced output in your environment".
- Known risk: **ShuiZe** (last updated 2022) likely needs a Python 3.11/3.12
  venv on Trixie's Python 3.13.
- The CJK layer (fcitx5 toggle, font rendering, `opencc`/`jieba`/`pypinyin`
  imports) has not been checked in a live GNOME session.
