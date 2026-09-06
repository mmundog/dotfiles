# Dotfiles

Personal development environment configuration for macOS and Linux.

The repository is designed to keep shell, Git, VS Code, and development tools consistent across machines while keeping GitHub as the source of truth.

## Supported platforms

* macOS
* Debian / Ubuntu
* Fedora

## What's included

* Shell configuration with Zsh
* Git configuration and global Git ignore rules
* Homebrew packages and applications on macOS
* APT packages on Debian / Ubuntu
* DNF packages on Fedora
* `fnm` for Node.js version management
* Visual Studio Code
* VS Code settings and extensions
* JetBrains Mono Nerd Font
* Platform detection and environment verification

## Repository structure

```text
dotfiles/
├── bootstrap.sh
├── update.sh
├── doctor.sh
├── Brewfile
├── git/
│   ├── .gitconfig
│   └── .gitignore_global
├── packages/
│   ├── debian.sh
│   └── fedora.sh
├── scripts/
│   ├── install-fnm.sh
│   ├── install-vscode.sh
│   └── platform.sh
├── vscode/
│   ├── extensions
│   └── settings.json
└── zsh/
    ├── .zshrc
    └── .zprofile
```

## Bootstrap a new machine

Clone the repository:

```bash
git clone https://github.com/mmundog/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

Run the bootstrap script:

```bash
bash bootstrap.sh
```

`bootstrap.sh` detects the operating system and installs the appropriate packages and tools.

### macOS

Homebrew is installed automatically if it is not already available.

The `Brewfile` installs the required formulae, applications, and fonts.

### Debian / Ubuntu

The bootstrap process uses `apt` to install the required packages and configures the official repositories needed for tools such as `eza`, GitHub CLI, and Visual Studio Code.

### Fedora

The bootstrap process uses `dnf` to install the required packages and configures Visual Studio Code.

After installation, the bootstrap script:

* Configures Zsh
* Sets Zsh as the default shell on Linux
* Configures Git
* Configures VS Code
* Installs VS Code extensions
* Installs `fnm` on Linux
* Runs `doctor.sh` to verify the environment

## Verify the environment

Run:

```bash
bash doctor.sh
```

Or, from Zsh:

```bash
doctor
```

The doctor checks the tools and configuration managed by this repository, including:

* Platform detection
* Git and GitHub CLI
* `fnm`
* Zsh and the default shell
* Configuration symlinks
* Homebrew packages and applications on macOS
* VS Code extensions

A successful check ends with:

```text
✅ Everything is in order.
```

## Updating the environment

When the repository changes on another machine:

```bash
cd ~/dotfiles
git pull
```

Because the configuration files are symlinked directly to the repository, changes to files such as `.zshrc`, `.zprofile`, `.gitconfig`, and VS Code settings are immediately available.

If packages or tools were added to the repository, run:

```bash
bash bootstrap.sh
```

The bootstrap process is designed to be safe to run more than once.

## Updating the Brewfile

The `Brewfile` is specific to macOS.

When installing or removing Homebrew packages, applications, or fonts, synchronize the Brewfile with:

```bash
brew bundle dump --file="$HOME/dotfiles/Brewfile" --force
```

VS Code extensions are managed separately in:

```text
vscode/extensions
```

Each line represents one extension identifier.

## Updating dotfiles

The `update.sh` script updates Homebrew, synchronizes the macOS `Brewfile`, and runs the verification script.

Run:

```bash
bash update.sh
```

After reviewing the changes:

```bash
git status
git diff
```

Commit and push the changes:

```bash
git add <files>
git commit -m "type: short description"
git push
```

## Commit convention

This repository uses Conventional Commits.

| Type       | Use for                                |
| ---------- | -------------------------------------- |
| `feat`     | New functionality                      |
| `fix`      | Bug fixes                              |
| `chore`    | Maintenance                            |
| `docs`     | Documentation only                     |
| `refactor` | Code changes without changing behavior |

Examples:

```text
feat: add Fedora package support
fix: correct VS Code configuration path
chore: add ripgrep to Brewfile
docs: update installation instructions
refactor: make bootstrap location-independent
```

Keeping commits focused makes the history easier to understand and individual changes easier to revert.

## Design principles

### GitHub is the source of truth

The repository contains the configuration that should be reproduced across machines.

Local changes should eventually be committed and pushed so other machines can pull them.

### Platform-specific configuration stays separate

macOS uses Homebrew, while Linux distributions use their native package managers.

This keeps platform-specific installation logic isolated instead of forcing everything into one script.

### Configuration files use symlinks

Configuration files are linked directly from the repository into the user's home directory.

For example:

```text
~/.zshrc
    ↓
~/dotfiles/zsh/.zshrc
```

This means changes made in the repository are immediately reflected in the active configuration.

### Scripts are location-independent

The automation scripts determine the location of the repository at runtime instead of assuming it is always located at `~/dotfiles`.

The default installation path remains `~/dotfiles` for simplicity, but the scripts do not depend on that path.

## Current hardware

Primary development machine:

* Mac Mini M4
* Apple Silicon

The repository is intended to remain portable to future macOS and Linux machines.
