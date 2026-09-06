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
  wget \
  gpg \
  unzip \
  zsh \
  gh

echo "📦 Installing eza..."

sudo mkdir -p /etc/apt/keyrings

wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc \
  | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg

echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" \
  | sudo tee /etc/apt/sources.list.d/gierens.list >/dev/null

sudo chmod 644 /etc/apt/keyrings/gierens.gpg
sudo chmod 644 /etc/apt/sources.list.d/gierens.list

sudo apt update
sudo apt install -y eza
