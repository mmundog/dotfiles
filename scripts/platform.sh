#!/usr/bin/env bash

case "$(uname -s)" in
  Darwin)
    export DOTFILES_OS="macos"
    export DOTFILES_DISTRO="macos"
    ;;
  Linux)
    export DOTFILES_OS="linux"

    if [[ -f /etc/os-release ]]; then
      source /etc/os-release

      case "$ID" in
        ubuntu|debian)
          export DOTFILES_DISTRO="$ID"
          ;;
        fedora)
          export DOTFILES_DISTRO="fedora"
          ;;
        *)
          export DOTFILES_DISTRO="unknown"
          ;;
      esac
    else
      export DOTFILES_DISTRO="unknown"
    fi
    ;;
  *)
    echo "Unsupported operating system: $(uname -s)"
    return 1
    ;;
esac
