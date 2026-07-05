# ZoomEye CLI

**Category:** china (standalone) · **Install:** pipx · **Command:** `zoomeye` · **Access:** ZoomEye API key
**Source:** ZoomEye official CLI/SDK (knownsec)

## What it is

The **official** command-line client and SDK for **ZoomEye**, a cyberspace search
engine indexing internet-exposed hosts, services, and devices. It is the scriptable
counterpart to [Kunyu](kunyu.md)'s interactive console.

## Access required

A **ZoomEye API key**. Initialise once with `zoomeye init`.

## Usage in Wukong

**Standalone.** Query from the terminal or import the SDK in Python:

```bash
zoomeye init                       # store the API key (first run)
zoomeye search 'app:"nginx"'       # run a query
```

Use it for reproducible, scriptable ZoomEye collection — e.g. enumerating hosts
for a target org and feeding them downstream.

## Caveats

- Free quota is limited; results depend on the query grammar (differs from FOFA's).
- For exploratory pivoting prefer [Kunyu](kunyu.md); for scripting use this.

## See also

[Kunyu](kunyu.md) · FOFA family: [Fofax](fofax.md), [GoFOFA](gofofa.md), [FOFA SDK](fofa-sdk.md).
