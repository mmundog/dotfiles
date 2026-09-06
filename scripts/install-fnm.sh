#!/usr/bin/env bash

set -e

FNM_DIR="$HOME/.local/share/fnm"

if [[ -x "$FNM_DIR/fnm" ]]; then
  echo "✓ fnm is already installed"
  exit 0
fi

echo "📦 Installing fnm..."

curl -fsSL https://fnm.vercel.app/install | bash -s -- \
  --install-dir "$FNM_DIR" \
  --skip-shell

echo "✓ fnm installed"
