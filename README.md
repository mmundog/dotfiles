# Dotfiles

Configuración personal para macOS (Apple Silicon).

## Incluye

- Homebrew + paquetes (Brewfile)
- Configuración de zsh (.zshrc, .zprofile)
- Configuración de Git (.gitconfig)
- Extensiones y settings de VS Code
- Fuentes (JetBrains Mono Nerd Font)

## Restaurar entorno en una Mac nueva

1. Instalar Homebrew:
```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

2. Clonar repositorio:
```bash
   git clone https://github.com/mmundog/dotfiles.git ~/dotfiles
```

3. Correr bootstrap:
```bash
   ~/dotfiles/bootstrap.sh
```

Eso es todo — el script instala paquetes, crea symlinks y configura VS Code automáticamente.

## Estructura
dotfiles/

├── bootstrap.sh

├── Brewfile

├── git/

│   └── .gitconfig

├── vscode/

│   ├── settings.json

│   └── extensions.txt

└── zsh/

├── .zshrc

└── .zprofile

## Hardware

- Mac Mini M4 (Apple Silicon)