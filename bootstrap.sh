#!/usr/bin/env zsh

set -e

# Detect operating system
source ~/dotfiles/scripts/platform.sh

echo "🖥️ Platform: $DOTFILES_OS"

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

# Install platform-specific packages
if [[ "$DOTFILES_OS" == "macos" ]]; then
  if ! command -v brew >/dev/null 2>&1; then
    echo "🍺 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  echo "📦 Installing packages with Homebrew..."
  brew bundle --file=~/dotfiles/Brewfile

elif [[ "$DOTFILES_OS" == "linux" ]]; then
  case "$DOTFILES_DISTRO" in
    ubuntu|debian)
      bash ~/dotfiles/packages/debian.sh
      ;;
    fedora)
      bash ~/dotfiles/packages/fedora.sh
      ;;
    *)
      echo "⚠️ Unsupported Linux distribution: $DOTFILES_DISTRO"
      exit 1
      ;;
  esac
fi

# Install fnm on Linux
if [[ "$DOTFILES_OS" == "linux" ]]; then
  bash ~/dotfiles/scripts/install-fnm.sh
fi

# Install Visual Studio Code on Linux
if [[ "$DOTFILES_OS" == "linux" ]]; then
  bash ~/dotfiles/scripts/install-vscode.sh
fi

echo "⚙️ Applying zsh config..."
link ~/dotfiles/zsh/.zshrc ~/.zshrc
link ~/dotfiles/zsh/.zprofile ~/.zprofile

echo "🔧 Applying Git config..."
link ~/dotfiles/git/.gitconfig ~/.gitconfig
link ~/dotfiles/git/.gitignore_global ~/.gitignore_global

echo "💻 Setting VS Code config..."

if [[ "$DOTFILES_OS" == "macos" ]]; then
  mkdir -p ~/Library/Application\ Support/Code/User
  link ~/dotfiles/vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
elif [[ "$DOTFILES_OS" == "linux" ]]; then
  mkdir -p ~/.config/Code/User
  link ~/dotfiles/vscode/settings.json ~/.config/Code/User/settings.json
fi

echo "🔌 Installing VS Code extensions..."

if command -v code >/dev/null 2>&1; then
  while IFS= read -r extension; do
    [ -z "$extension" ] && continue
    code --install-extension "$extension" --force
  done < ~/dotfiles/vscode/extensions
else
  echo "⚠️ VS Code is not available, skipping extensions."
fi

echo "🩺 Running verification..."
bash ~/dotfiles/doctor.sh

echo "✅ Done."
