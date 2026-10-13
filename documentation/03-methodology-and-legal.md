# 03 — Methodology & Legal

## Access prerequisites (read first)

More than half of "why a China tool didn't work" comes down to access, not the
command. Three recurring situations govern the whole toolkit:

| Situation | Tools | What you need |
|-----------|-------|---------------|
| **Cyberspace engines** | FOFA (`fofax`, `gofofa`), ZoomEye (`kunyu`, `zoomeye`) | An **API key**. Free tiers are quota-limited; full access often needs a verified Chinese account. Works from any IP. |
| **Social scrapers** | MediaCrawler, Weibo/Douyin/WeChat crawlers, `snscrape` | A **logged-in account cookie**. Registering the account usually needs a **+86 phone**; avoiding bans often needs a **mainland-China residential proxy**. |
| **Corporate aggregators** | TianYanCha, QCC, Aiqicha | IP-blocked outside China since ~2022 → **CN proxy + +86 account**. The state registry **GSXT is public and free** but Chinese-only with heavy CAPTCHA. |

Credentials are supplied by the analyst **at runtime, never committed to the
repo**. The installer only installs tooling.

---

## The three-layer method in practice

### Layer 1 — build the query in Chinese first

Do not paste a machine translation into Baidu; it returns poor results. Build the
query as: **official term + colloquial variants + likely coded form**. The
language layer exists for exactly this:

```bash
# Type Chinese: Ctrl+Space toggles fcitx5 Pinyin
opencc -c s2t.json -i in.txt -o out.txt      # Simplified → Traditional
python3 -c "import jieba; print('/'.join(jieba.cut('调查中国企业')))"
```

### Layer 2 — sinophone reconnaissance

Choose the tool by target type:

- **A domain / infrastructure** → FOFA/ZoomEye engines, `ShuiZe`.
- **A person / handle on social** → `MediaCrawler` (broadest coverage),
  platform-specific crawlers, `snscrape`.
- **Media (video/images)** → `you-get`, `BBDown`.
- **A keyword / topic** → `pydork` (Baidu dorking), then the search engines by hand.

Reverse image search on Chinese engines (Baidu Images, Sogou `pic.sogou.com`,
Yandex for faces) has **no reliable open-source CLI** — drive it in the browser.

### Layer 3 — corporate due diligence

The KYC workflow chains sources because **no single database is authoritative**:

1. **Anchor identity** — start from the **USCC** (18-char Unified Social Credit
   Code) or the exact **Chinese legal name**. Only have a domain? Run
   [ICP_Query](tools/icp-query.md) to get the registrant, then search that.
2. **Ground truth** — verify on **GSXT** (gsxt.gov.cn): status, USCC, legal
   representative, capital, business scope, shareholders.
3. **Enrichment** — TianYanCha / QCC / Aiqicha + [ENScan_GO](tools/enscan-go.md)
   automation for cross-holdings, litigation, patents, subsidiaries, ICP/apps/公众号.
4. **UBO resolution (the hard part)** — Chinese registries show shareholders but
   **not** a natural-person ultimate beneficial owner. Climb intermediate
   holdings (often offshore HK/BVI/Cayman) using the parent jurisdiction's
   registry + OpenCorporates/Sayari. Watch for VIE structures and state-linked
   entities designed for opacity.
5. **Risk / sanctions** — 信用中国 (creditchina.gov.cn) for blacklists;
   Datenna / Sayari for state links and restricted-party ties; the US and Chinese
   restricted lists in [05 — Analysis & Reporting](05-analysis-and-reporting.md#restricted-and-sanctions-lists).
   Read capital and legal-representative data with the
   [corporate data traps](05-analysis-and-reporting.md#corporate-data-traps) in mind.

Rule: **GSXT = legal ground-truth; aggregators = relational richness;
Sayari/Datenna = cross-border chain.**

### Registries reference

| Source | URL | Free? | Access |
|--------|-----|-------|--------|
| GSXT / NECIPS (official) | gsxt.gov.cn | Free | Chinese-only, CAPTCHA |
| 信用中国 Credit China | creditchina.gov.cn | Free | Blacklists, sanctions |
| Cninfo (listed cos.) | cninfo.com.cn | Free | Official filings/financials |
| TianYanCha | tianyancha.com | Freemium + paid API | CN proxy + +86 |
| QCC (Qichacha) | qcc.com | Freemium + paid API | CN proxy + +86 |
| Aiqicha (Baidu) | aiqicha.baidu.com | Freemium | Baidu account |
| Sayari / Datenna | sayari.com / datenna.com | Paid | Strong on UBO chains |
| 中国裁判文书网 China Judgements Online | [wenshu.court.gov.cn](https://wenshu.court.gov.cn/) | Free | Chinese; millions of judgements removed since 2021 — see [05](05-analysis-and-reporting.md#evaluating-chinese-sources) |
| 中国执行信息公开网 Enforcement disclosure | [zxgk.court.gov.cn](https://zxgk.court.gov.cn/) | Free | Judgement defaulters (失信被执行人), consumption bans; CAPTCHA |
| CNIPA (patents, trademarks) | [cnipa.gov.cn](https://www.cnipa.gov.cn/) | Free | Chinese; English portal at english.cnipa.gov.cn |
| 中国政府采购网 Government procurement | [ccgp.gov.cn](http://www.ccgp.gov.cn/) | Free | Tenders and awards: who sells to which state body |
| Hong Kong Companies Registry | [e-services.cr.gov.hk](https://www.e-services.cr.gov.hk/) | Index free, particulars paid | English/Chinese; e-Services Portal replaced the old ICRIS search in December 2023 |
| HKEXnews (HK-listed cos.) | [hkexnews.hk](https://www.hkexnews.hk/) | Free | Filings, prospectuses, shareholding disclosures |
| Taiwan 商工登記公示資料查詢 | [findbiz.nat.gov.tw](https://findbiz.nat.gov.tw/) | Free | Taiwan company and business registrations (Traditional Chinese) |

---

## <a name="legal--opsec"></a>Legal & OPSEC

This is not boilerplate. China's identity regime directly constrains OSINT method.

- **Real-name registration** (Cybersecurity Law) ties most platform accounts to a
  real identity, usually via a **+86 phone**. This is why account-gated scrapers
  need a genuine account, and why buying/borrowing one carries risk.
- **National Cyberspace ID** — effective **2025-07-15**. It links a citizen's
  national ID and a live facial scan to a tokenised credential. It is currently
  voluntary, but it tightens the identity fabric further and centralises
  verification. Practically: impersonation to gain access **leaves OSINT
  territory and may be illegal**.
- **Prepare before you touch a target.** Isolated VM, proxy, and any throwaway
  identity **within legal limits** — set up *before* the first request, not
  during. Know your mandate first.
- **Passive by default.** Wukong tools are configured for observation, not
  intrusion (e.g. `ShuiZe` is pinned to information-gathering only, with active
  vulnerability scanning disabled). Staying passive is both an ethical and a
  legal posture.

> The goal is to see clearly, not to be seen. Every credential you use and every
> request you make is a trace. Minimise both.
