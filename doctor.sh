#!/usr/bin/env zsh

# Verify that everything installed/configured by the repository is present

# Detect operating system
source ~/dotfiles/scripts/platform.sh

echo "🖥️ Platform: $DOTFILES_OS"

echo "🩺 Running dotfiles doctor..."
echo ""

PASS="✅"
FAIL="❌"
doctor_status=0

check() {
  local label=$1
  local condition=$2
  if eval "$condition" >/dev/null 2>&1; then
    echo "  $PASS $label"
  else
    echo "  $FAIL $label"
    doctor_status=1
  fi
}

# ─── HOMEBREW CORE ───
if [[ "$DOTFILES_OS" == "macos" ]]; then
  echo "🍺 Homebrew"
  check "brew is installed" "command -v brew"
  check "brew is in PATH" "which brew"
fi

# ─── GIT / GITHUB ───
echo ""
echo "🔧 Git"
check "git is installed" "command -v git"
check "gh (GitHub CLI) is installed" "command -v gh"
check "gh is authenticated" "gh auth status"

# ─── SYMLINKS ───
echo ""
echo "🔗 Symlinks"
check ".zshrc is linked" "[ -L ~/.zshrc ]"
check ".zprofile is linked" "[ -L ~/.zprofile ]"
check ".gitconfig is linked" "[ -L ~/.gitconfig ]"
check ".gitignore_global is linked" "[ -L ~/.gitignore_global ]"

if [[ "$DOTFILES_OS" == "macos" ]]; then
  check "VS Code settings.json is linked" "[ -L ~/Library/Application\ Support/Code/User/settings.json ]"
elif [[ "$DOTFILES_OS" == "linux" ]]; then
  check "VS Code settings.json is linked" "[ -L ~/.config/Code/User/settings.json ]"
fi

# ─── BREW FORMULAE ───
if [[ "$DOTFILES_OS" == "macos" ]]; then
  echo ""
  echo "📦 Homebrew formulae"

  brew_formulae=$(grep '^brew ' ~/dotfiles/Brewfile | sed -E 's/brew "(.*)"/\1/')

  while IFS= read -r formula; do
    [ -z "$formula" ] && continue

    if brew list --formula | grep -Eq "^${formula}(@[0-9]+(\.[0-9]+)*)?$"; then
      echo "  $PASS $formula installed"
    else
      echo "  $FAIL $formula installed"
      doctor_status=1
    fi
  done <<< "$brew_formulae"
fi

# ─── CASKS ───
if [[ "$DOTFILES_OS" == "macos" ]]; then
  echo ""
  echo "🖥️ Apps (casks)"

  brew_casks=$(grep '^cask ' ~/dotfiles/Brewfile | sed -E 's/cask "(.*)"/\1/')

  while IFS= read -r cask; do
    [ -z "$cask" ] && continue
    check "$cask installed" "brew list --cask | grep -qx '$cask'"
  done <<< "$brew_casks"
fi

# ─── VSCODE EXTENSIONS ───
echo ""
echo "🔌 VS Code extensions"

if command -v code >/dev/null 2>&1; then
  installed_extensions=$(code --list-extensions)

  while IFS= read -r extension; do
    [ -z "$extension" ] && continue

    if echo "$installed_extensions" | grep -qix "$extension"; then
      echo "  $PASS $extension"
    else
      echo "  $FAIL $extension"
      doctor_status=1
    fi
  done < ~/dotfiles/vscode/extensions
else
  echo "  $FAIL code is not available, cannot verify extensions"
  doctor_status=1
fi

# ─── SUMMARY ───
echo ""
if [ $doctor_status -eq 0 ]; then
  echo "✅ Everything is in order."
else
  echo "⚠️  Some items require attention (see ❌ above)."
fi

exit $doctor_status
