# Dotfiles
Configuración personal para macOS (Apple Silicon).

## Incluye
- Homebrew + paquetes (Brewfile)
- Configuración de zsh (.zshrc, .zprofile)
- Configuración de Git (.gitconfig)
- Extensiones y settings de VS Code
- Fuentes (JetBrains Mono Nerd Font)

## Qué se actualiza automático vs manual

### Automático (via `update.sh`)
- `.zshrc`, `.zprofile` — configuración del shell
- `.gitconfig` — configuración de Git
- `vscode/settings.json` — settings de VS Code

### Manual (requiere acción antes de commitear)
- **`Brewfile`** — no se autosincroniza. Cada que instales o desinstales algo con Homebrew o una extensión de VS Code, regenerarlo con:
```bash
  brew bundle dump --force
```
- **`vscode/extensions.txt`** — si lo usas como respaldo adicional, actualizarlo con:
```bash
  code --list-extensions > ~/dotfiles/vscode/extensions.txt
```

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
brew bundle dump --force   # si cambiaste algo en Homebrew o extensiones de VS Code
~/dotfiles/update.sh
git add .
git commit -m "tipo: descripción breve"
git push
```

### Tipos de commit
| Tipo | Cuándo usarlo |
|------|--------------|
| `feat` | Algo nuevo que no existía |
| `fix` | Corrección de algo roto |
| `chore` | Mantenimiento sin impacto funcional |
| `docs` | Solo documentación |

Ejemplos:
- `chore: add ripgrep to Brewfile`
- `fix: correct settings.json type errors`
- `docs: document manual vs automatic update workflow`

Esta convención se llama **Conventional Commits** y permite navegar el historial de un vistazo sin necesidad de abrir cada commit.

### Ejemplo de commit por archivo
```bash
git add Brewfile
git commit -m "chore: add ripgrep to Brewfile"

git add vscode/settings.json
git commit -m "fix: correct settings.json type errors"

git add README.md
git commit -m "docs: document manual vs automatic update workflow"

git push
```

Commitear por archivo en lugar de `git add .` permite revertir cambios puntuales sin afectar el resto.

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
