#!/usr/bin/env zsh

set -e

echo "🚀 Starting dotfiles setup..."

# Install Homebrew if missing
if ! command -v brew >/dev/null 2>&1; then
  echo "📦 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "📦 Installing packages..."
brew bundle --file=~/dotfiles/Brewfile

echo "🔧 Applying zsh config..."
cp ~/dotfiles/zsh/.zshrc ~/.zshrc
cp ~/dotfiles/zsh/.zprofile ~/.zprofile

echo "⚙️ Applying Git config..."
cp ~/dotfiles/git/.gitconfig ~/.gitconfig

echo "💻 Setting VS Code config..."
mkdir -p ~/Library/Application\ Support/Code/User
cp ~/dotfiles/vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json

echo "✅ Done."
