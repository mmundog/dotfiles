#!/usr/bin/env bash

set -e

echo "📦 Installing packages with apt..."

sudo apt update

sudo apt install -y \
  git \
  python3 \
  ripgrep \
  tree \
  curl \
  zsh
