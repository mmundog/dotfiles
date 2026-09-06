#!/usr/bin/env bash

set -e

if command -v code >/dev/null 2>&1; then
  echo "✓ Visual Studio Code is already installed"
  exit 0
fi

echo "📦 Installing Visual Studio Code..."

case "$DOTFILES_DISTRO" in
  ubuntu|debian)
    sudo apt update
    sudo apt install -y wget gpg apt-transport-https

    wget -qO- https://packages.microsoft.com/keys/microsoft.asc \
      | gpg --dearmor \
      | sudo tee /usr/share/keyrings/microsoft.gpg >/dev/null

    echo "deb [arch=amd64,arm64,armhf signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/code stable main" \
      | sudo tee /etc/apt/sources.list.d/vscode.list >/dev/null

    sudo apt update
    sudo apt install -y code
    ;;

  fedora)
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

    sudo tee /etc/yum.repos.d/vscode.repo > /dev/null <<'EOF'
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
autorefresh=1
type=rpm-md
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF

    sudo dnf install -y code
    ;;

  *)
    echo "⚠️ Unsupported Linux distribution: $DOTFILES_DISTRO"
    exit 1
    ;;
esac

echo "✓ Visual Studio Code installed"
