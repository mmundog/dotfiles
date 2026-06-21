#!/usr/bin/env zsh

set -e

echo "🔄 Updating dotfiles..."

echo "📦 Updating Homebrew packages..."
brew update
brew upgrade

echo "📝 Syncing Brewfile with installed packages and extensions..."
brew bundle dump --file=~/dotfiles/Brewfile --force

echo "🩺 Running verification..."
bash ~/dotfiles/doctor.sh

echo "✅ Done. Don't forget to commit the changes:"
echo "   git add . && git commit -m 'chore: update packages and extensions' && git push"
