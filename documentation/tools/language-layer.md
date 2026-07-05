# Language & culture layer

**Category:** language · **Install:** apt (Phase 1) + one pipx package · **Access:** none

The precondition for every other tool. Without the ability to type, render, and
normalise Chinese text, the rest of Wukong is unusable. Installed in **Phase 1**
of `wukong_install.sh`, before any OSINT tool.

---

## Components

### fcitx5 — input method (typing Chinese)

Type Chinese with a Pinyin engine. Toggle on/off with **`Ctrl+Space`**.

```bash
fcitx5-configtool     # add/configure engines (Pinyin is preconfigured)
fcitx5-diagnose       # troubleshoot if typing doesn't work
```

On GNOME/Wayland, fcitx5 works through the GTK/Qt IM modules; the required
environment variables are set in `/etc/environment` by the installer.

### CJK fonts + locales — rendering Chinese

Simplified (SC) and Traditional (TC) fonts are installed so Chinese renders
correctly. The `zh_CN` and `zh_TW` locales are generated **non-interactively for
rendering only** — the system UI stays English/Italian.

### opencc — Simplified ↔ Traditional conversion

```bash
opencc -c s2t.json -i in.txt -o out.txt     # Simplified → Traditional
opencc -c t2s.json -i in.txt -o out.txt     # Traditional → Simplified
```

Essential because the same entity may be written in either script depending on
the source (mainland vs. Hong Kong/Taiwan).

### jieba — word segmentation (Python)

Chinese has no spaces between words; segmentation is needed before analysis.

```bash
python3 -c "import jieba; print('/'.join(jieba.cut('调查中国企业信息')))"
```

### pypinyin — romanisation (Python)

```bash
python3 -c "from pypinyin import pinyin; print(pinyin('悟空'))"
```

Useful for transliterating names and matching across sources.

### hanzidentifier — Simplified/Traditional detection

The only piece not in the Debian repo — installed via **pipx**. Tells you which
script a string is written in, so you know whether to convert.

### Offline dictionary

```bash
dict -d cc-cedict 你好          # CLI lookup
# or GoldenDict-NG (GUI) for richer lookups
```

---

## How it's used

Build a **query in Chinese** before searching: official term + colloquial
variants + likely coded form. Pasting a machine translation into Baidu returns
poor results — this layer is what lets you do it properly.

## Caveats

- fcitx5 on Wayland occasionally needs a logout/login after first install for the
  IM env vars to take effect. `fcitx5-diagnose` is the first stop if typing fails.
- `jieba` / `pypinyin` / `opencc` come from the Debian repo. If you prefer newer
  versions, an optional `~/.venvs/zh-tools` venv can host them.

## Not yet verified

The CJK layer has not been exercised in a live GNOME session (dev host is
Windows). fcitx5 toggle, font rendering, and the Python imports need a real
Debian 13 run to confirm.
