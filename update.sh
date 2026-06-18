#!/usr/bin/env zsh

set -e

echo "🔄 Updating dotfiles..."

echo "📦 Updating Homebrew packages..."
brew update
brew upgrade
brew bundle --file=~/dotfiles/Brewfile

echo "🔌 Updating VS Code extensions list..."
code --list-extensions > ~/dotfiles/vscode/extensions.txt

echo "✅ Done. Don't forget to commit the changes:"
echo "   git add . && git commit -m 'Update packages and extensions' && git push"
