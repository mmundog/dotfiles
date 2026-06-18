# Dotfiles

Configuración personal para macOS (Apple Silicon).

## Incluye

- Homebrew + paquetes (Brewfile)
- Configuración de zsh (.zshrc, .zprofile)
- Configuración de Git (.gitconfig)
- Extensiones y settings de VS Code
- Fuentes (JetBrains Mono Nerd Font)

## Restaurar entorno en una Mac nueva

### 1. Instalar Homebrew
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 2. Verificar Git
```bash
git --version
```

### 3. Clonar repositorio
```bash
git clone https://github.com/mmundog/dotfiles.git ~/dotfiles
```

### 4. Correr bootstrap
```bash
bash ~/dotfiles/bootstrap.sh
```

Usamos `bash` en lugar de `~/dotfiles/bootstrap.sh` directamente porque en una Mac nueva el archivo puede no tener permisos de ejecución todavía — el propio script se encarga de arreglarlo para futuras ejecuciones.

### 5. Recargar shell
```bash
source ~/.zshrc
```

A partir de aquí puedes usar `reload` en lugar de `source ~/.zshrc`.

### 6. Autenticarse en GitHub
```bash
gh auth login
```
Elegir:
- GitHub.com
- HTTPS
- Login with a web browser

Esto guarda el token en el Keychain de macOS — Git nunca volverá a pedir contraseña.

## Actualizar dotfiles

Cuando cambies paquetes, extensiones o configuraciones:

```bash
~/dotfiles/update.sh
git add .
git commit -m "Update"
git push
```

## Estructura
dotfiles/

├── bootstrap.sh

├── update.sh

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