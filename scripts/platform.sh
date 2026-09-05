#!/usr/bin/env zsh

case "$(uname -s)" in
  Darwin)
    export DOTFILES_OS="macos"
    ;;
  Linux)
    export DOTFILES_OS="linux"
    ;;
  *)
    echo "❌ Sistema operativo no soportado: $(uname -s)"
    return 1
    ;;
esac

