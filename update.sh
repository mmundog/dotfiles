#!/usr/bin/env zsh

set -e

DOTFILES_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

echo "🔄 Updating dotfiles..."

echo "📦 Updating Homebrew packages..."
brew update
brew upgrade

echo "📝 Syncing Brewfile with installed packages and extensions..."
brew bundle dump --file="$DOTFILES_DIR/Brewfile" --force

echo "🩺 Running verification..."
bash "$DOTFILES_DIR/doctor.sh"

echo "✅ Done. Don't forget to commit the changes:"
echo "   git add . && git commit -m 'chore: update packages and extensions' && git push"
