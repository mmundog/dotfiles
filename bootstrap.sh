#!/usr/bin/env zsh

set -e

# Make scripts executable
chmod +x ~/dotfiles/bootstrap.sh
chmod +x ~/dotfiles/update.sh

echo "🚀 Starting dotfiles setup..."

# Helper function
link() {
  local src=$1
  local dst=$2
  if [ -L "$dst" ]; then
    echo "  ✓ Already linked: $dst"
  else
    ln -sf "$src" "$dst"
    echo "  → Linked: $dst"
  fi
}

# Install Homebrew if missing
if ! command -v brew >/dev/null 2>&1; then
  echo "🍺 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "📦 Installing packages..."
brew bundle --file=~/dotfiles/Brewfile

echo "⚙️ Applying zsh config..."
link ~/dotfiles/zsh/.zshrc ~/.zshrc
link ~/dotfiles/zsh/.zprofile ~/.zprofile

echo "🔧 Applying Git config..."
link ~/dotfiles/git/.gitconfig ~/.gitconfig
link ~/dotfiles/git/.gitignore_global ~/.gitignore_global

echo "💻 Setting VS Code config..."
mkdir -p ~/Library/Application\ Support/Code/User
link ~/dotfiles/vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json

echo "🩺 Running verification..."
bash ~/dotfiles/doctor.sh

echo "✅ Done."
