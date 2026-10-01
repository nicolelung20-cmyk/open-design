#!/bin/bash
set -euo pipefail

# Only run in Claude Code on the web.
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

cd "$CLAUDE_PROJECT_DIR"

# package.json requires Node ~24 and pnpm >=10.33.2 <11.
if [ "$(node -p 'process.versions.node.split(".")[0]')" != "24" ]; then
  npm install -g n
  n 24
  # n installs to /usr/local/bin, which can sit behind another Node on PATH.
  export PATH="/usr/local/bin:$PATH"
  echo 'export PATH="/usr/local/bin:$PATH"' >> "$CLAUDE_ENV_FILE"
fi

# package.json pins pnpm via "packageManager"; Corepack selects that version.
corepack enable
pnpm install
