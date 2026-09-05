#!/usr/bin/env zsh
# Verifica que TODO lo que el repositorio instala/configura esté presente

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
  check "brew está instalado" "command -v brew"
  check "brew está en el PATH" "which brew"
fi

# ─── GIT / GITHUB ───
echo ""
echo "🔧 Git"
check "git está instalado" "command -v git"
check "gh (GitHub CLI) está instalado" "command -v gh"
check "gh está autenticado" "gh auth status"

# ─── SYMLINKS ───
echo ""
echo "🔗 Symlinks"
check ".zshrc está enlazado" "[ -L ~/.zshrc ]"
check ".zprofile está enlazado" "[ -L ~/.zprofile ]"
check ".gitconfig está enlazado" "[ -L ~/.gitconfig ]"
check ".gitignore_global está enlazado" "[ -L ~/.gitignore_global ]"
if [[ "$DOTFILES_OS" == "macos" ]]; then
  check "VS Code settings.json está enlazado" "[ -L ~/Library/Application\ Support/Code/User/settings.json ]"
elif [[ "$DOTFILES_OS" == "linux" ]]; then
  check "VS Code settings.json está enlazado" "[ -L ~/.config/Code/User/settings.json ]"
fi

# ─── PAQUETES BREW (formulae) ───
if [[ "$DOTFILES_OS" == "macos" ]]; then
  echo ""
  echo "📦 Paquetes Homebrew (formulae)"
  brew_formulae=$(grep '^brew ' ~/dotfiles/Brewfile | sed -E 's/brew "(.*)"/\1/')
  while IFS= read -r formula; do
    [ -z "$formula" ] && continue

    if brew list --formula | grep -Eq "^${formula}(@[0-9]+(\.[0-9]+)*)?$"; then
      echo "  $PASS $formula instalado"
    else
      echo "  $FAIL $formula instalado"
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
    check "$cask instalado" "brew list --cask | grep -qx '$cask'"
  done <<< "$brew_casks"
fi

# ─── EXTENSIONES VS CODE ───
echo ""
echo "🔌 Extensiones de VS Code"
if command -v code >/dev/null 2>&1; then
  installed_extensions=$(code --list-extensions)
  vscode_extensions=$(grep '^vscode ' ~/dotfiles/Brewfile | sed -E 's/vscode "(.*)"/\1/')
  while IFS= read -r ext; do
    [ -z "$ext" ] && continue
    if echo "$installed_extensions" | grep -qix "$ext"; then
      echo "  $PASS $ext"
    else
      echo "  $FAIL $ext"
      doctor_status=1
    fi
  done <<< "$vscode_extensions"
else
  echo "  $FAIL code no está disponible, no se pueden verificar extensiones"
  doctor_status=1
fi

# ─── RESUMEN ───
echo ""
if [ $doctor_status -eq 0 ]; then
  echo "✅ Todo en orden."
else
  echo "⚠️  Hay elementos que requieren atención (ver ❌ arriba)."
fi

exit $doctor_status