#!/data/data/com.termux/files/usr/bin/bash
# Install REA into Termux and register it with Claude Code.
# Run inside Termux on the phone: bash scripts/termux/install.sh
# Static analysis (JavaScript/Electron, .NET, SQLite, WASM, EVM, packages) needs
# only Node.js. Native engines (Hopper, Ghidra, IDA) do not run on Android.
set -euo pipefail

if [[ "$(uname -o 2>/dev/null)" != "Android" ]]; then
  echo "This installer is for Termux on Android." >&2
  exit 1
fi

export DEBIAN_FRONTEND=noninteractive
pkg update -y
pkg upgrade -y
pkg install -y nodejs-lts git

# Optional, for APK analysis (JADX needs a JDK) and website browser analysis.
# Remove these two lines if you only need static JavaScript/.NET work.
pkg install -y openjdk-21 chromium || echo "Optional packages skipped; continuing." >&2

npm install -g rea-agents@latest
rea --version

# Registers REA's MCP server and workflow skill with Claude Code.
# Shows the planned changes first; --yes applies them to REA-owned entries only.
rea setup --client claude_code --skill-client claude_code --yes

# Read-only readiness check. Native engine lines are expected to be unavailable.
rea doctor --client claude_code --json || true

echo "Done. Restart Claude Code in Termux, then ask it to analyze a target path."
