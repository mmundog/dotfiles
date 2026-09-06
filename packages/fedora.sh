#!/usr/bin/env bash

set -e

echo "📦 Installing packages with dnf..."

sudo dnf install -y \
  git \
  python3 \
  ripgrep \
  tree \
  curl \
  unzip \
  zsh \
  gh \
  eza
