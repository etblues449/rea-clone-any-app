# REA on Termux with Claude Code

Run REA on an Android phone (Termux) and drive it from Claude Code running in
the same Termux session.

## Install

In Termux:

```bash
bash scripts/termux/install.sh
```

Or, without a repo checkout:

```bash
pkg install -y nodejs-lts git
npm install -g rea-agents@latest
rea setup --client claude_code --skill-client claude_code --yes
```

Restart Claude Code afterward so it loads the REA MCP server.

## What works on Android

| Target | Works on Termux | Notes |
| --- | --- | --- |
| JavaScript / Electron apps | Yes | Node.js only. Extract ASAR or the app folder first. |
| .NET assemblies | Yes | Static, no engine. |
| SQLite databases, WASM, EVM bytecode, Flutter, Go binaries | Yes | Static parsing. |
| APK (Android) | Yes with `openjdk-21` | Uses JADX. |
| Websites (browser analysis) | Partly | Needs `chromium`; the Termux launch path is special-cased in code and verified only in an emulator. |
| Packet captures | Only if `tshark` is installed | Linux-verified upstream; Termux is unverified. |
| Native binaries (Hopper, Ghidra, IDA) | No | Hopper and IDA are desktop-only. Ghidra is not practical on Android. |

## Use it

Ask Claude Code in Termux, for example:

```text
Use REA to analyze /data/data/com.termux/files/home/apps/example-electron/app.asar
and explain how its search feature works, with the evidence.
```

Run `rea doctor --json` any time to check which targets are ready.

## Notes

- Termux's Node.js is Android-linked. If `npm install -g rea-agents` fails on
  a native module, the repo's own Termux build (`npm run build:termux`) is the
  fallback, from a source checkout.
- The repo's Termux verification lane is an Android emulator, not a physical
  phone. Results on your device are unverified until you run `rea doctor`.
- Remove the phone's REA registration with `rea uninstall`.
