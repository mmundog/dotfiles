#!/usr/bin/env bash

set -e

DOTFILES_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# Detect operating system
source "$DOTFILES_DIR/scripts/platform.sh"

echo "🖥️ Platform: $DOTFILES_OS"

# Make scripts executable
chmod +x "$DOTFILES_DIR/bootstrap.sh"
chmod +x "$DOTFILES_DIR/update.sh"

echo "🚀 Starting dotfiles setup..."

# Helper function
link() {
  local src=$1
  local dst=$2

  if [[ -L "$dst" ]]; then
    if [[ "$(readlink "$dst")" == "$src" ]]; then
      echo "  ✓ Already linked: $dst"
    else
      echo "  ↻ Updating link: $dst"
      ln -sf "$src" "$dst"
    fi
  elif [[ -e "$dst" ]]; then
    echo "  ⚠️ Existing file, skipping: $dst"
  else
    ln -s "$src" "$dst"
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
  brew bundle --file="$DOTFILES_DIR/Brewfile"

elif [[ "$DOTFILES_OS" == "linux" ]]; then
  case "$DOTFILES_DISTRO" in
    ubuntu|debian)
      bash "$DOTFILES_DIR/packages/debian.sh"
      ;;
    fedora)
      bash "$DOTFILES_DIR/packages/fedora.sh"
      ;;
    *)
      echo "⚠️ Unsupported Linux distribution: $DOTFILES_DISTRO"
      exit 1
      ;;
  esac
fi

# Install fnm on Linux
if [[ "$DOTFILES_OS" == "linux" ]]; then
  bash "$DOTFILES_DIR/scripts/install-fnm.sh"
fi

# Install Visual Studio Code on Linux
if [[ "$DOTFILES_OS" == "linux" ]]; then
  bash "$DOTFILES_DIR/scripts/install-vscode.sh"
fi

# Set zsh as the default shell on Linux
if [[ "$DOTFILES_OS" == "linux" ]]; then
  current_shell=$(getent passwd "$USER" | cut -d: -f7)
  zsh_path=$(command -v zsh)

  if [[ "$current_shell" != "$zsh_path" ]]; then
    echo "🐚 Setting zsh as the default shell..."
    chsh -s "$zsh_path"
  else
    echo "✓ zsh is already the default shell"
  fi
fi

echo "⚙️ Applying zsh config..."
link "$DOTFILES_DIR/zsh/.zshrc" ~/.zshrc
link "$DOTFILES_DIR/zsh/.zprofile" ~/.zprofile

echo "🔧 Applying Git config..."
link "$DOTFILES_DIR/git/.gitconfig" ~/.gitconfig
link "$DOTFILES_DIR/git/.gitignore_global" ~/.gitignore_global

echo "💻 Setting VS Code config..."
if [[ "$DOTFILES_OS" == "macos" ]]; then
  mkdir -p ~/Library/Application\ Support/Code/User
  link "$DOTFILES_DIR/vscode/settings.json" ~/Library/Application\ Support/Code/User/settings.json
elif [[ "$DOTFILES_OS" == "linux" ]]; then
  mkdir -p ~/.config/Code/User
  link "$DOTFILES_DIR/vscode/settings.json" ~/.config/Code/User/settings.json
fi

echo "🔌 Installing VS Code extensions..."

if command -v code >/dev/null 2>&1; then
  while IFS= read -r extension; do
    [ -z "$extension" ] && continue
    code --install-extension "$extension" --force
  done < "$DOTFILES_DIR/vscode/extensions"
else
  echo "⚠️ VS Code is not available, skipping extensions."
fi

echo "🩺 Running verification..."
bash "$DOTFILES_DIR/doctor.sh"

echo "✅ Done."
