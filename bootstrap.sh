#!/usr/bin/env zsh

set -e

echo "🚀 Starting dotfiles setup..."

# Install Homebrew if missing
if ! command -v brew >/dev/null 2>&1; then
  echo "🍺 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "📦 Installing packages..."
brew bundle --file=~/dotfiles/Brewfile

echo "⚙️ Applying zsh config..."
ln -sf ~/dotfiles/zsh/.zshrc ~/.zshrc
ln -sf ~/dotfiles/zsh/.zprofile ~/.zprofile

echo "🔧 Applying Git config..."
ln -sf ~/dotfiles/git/.gitconfig ~/.gitconfig

echo "💻 Setting VS Code config..."
mkdir -p ~/Library/Application\ Support/Code/User
ln -sf ~/dotfiles/vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json

echo "🔌 Installing VS Code extensions..."
if command -v code >/dev/null 2>&1; then
  cat ~/dotfiles/vscode/extensions.txt | xargs -L 1 code --install-extension
fi

echo "✅ Done."
