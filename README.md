# Dotfiles
Configuración personal para macOS (Apple Silicon).

## Incluye
- Homebrew + VS Code + paquetes (Brewfile)
- Configuración de zsh (.zshrc, .zprofile)
- Configuración de Git (.gitconfig, .gitignore_global)
- Settings y extensiones de VS Code
- Fuentes (JetBrains Mono Nerd Font)

## Qué se actualiza automático vs manual

### Automático (via `update.sh`)
- `.zshrc`, `.zprofile` — configuración del shell
- `.gitconfig` — configuración de Git
- `vscode/settings.json` — settings de VS Code

### Manual (requiere acción antes de commitear)
- **`Brewfile`** — no se autosincroniza. Cada que instales o desinstales algo con Homebrew o una extensión de VS Code, regenerarlo con:
```bash
brew bundle dump --file=~/dotfiles/Brewfile --force
```

## Restaurar entorno en una Mac nueva

### 1. Instalar Homebrew
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
Se instala en `/opt/homebrew` (Apple Silicon).

### 2. Verificar Git
```bash
git --version
```
macOS suele pedir instalar las Command Line Tools de Xcode en este paso si aún no están — acéptalo si aparece el prompt.

### 3. Instalar GitHub CLI
```bash
brew install gh
```
Necesario para autenticarte antes de clonar el repositorio (paso 5).

### 4. Autenticarse en GitHub
```bash
gh auth login
```
Elegir:
- GitHub.com
- HTTPS
- Login with a web browser

Esto guarda el token en el Keychain de macOS — Git nunca volverá a pedir contraseña, incluso al clonar el repositorio en el siguiente paso.

### 5. Clonar repositorio
```bash
git clone https://github.com/mmundog/dotfiles.git ~/dotfiles
```

### 6. Correr bootstrap
```bash
bash ~/dotfiles/bootstrap.sh
```
Usamos `bash` en lugar de `~/dotfiles/bootstrap.sh` directamente porque en una Mac nueva el archivo puede no tener permisos de ejecución todavía — el propio script se encarga de arreglarlo para futuras ejecuciones.

Este paso instala todos los paquetes del `Brewfile` (incluyendo `gh`, ya instalado en el paso 3, y **VS Code** con sus extensiones), aplica configuración de zsh, Git, y settings de VS Code, y termina corriendo `doctor.sh` automáticamente como verificación final.

### 7. Recargar shell
```bash
source ~/.zshrc
```
A partir de aquí puedes usar `reload` en lugar de `source ~/.zshrc`.

## Sincronizar cambios desde otra máquina
Si modificaste el repositorio desde GitHub directamente o desde otra Mac, trae los cambios así:

```bash
cd ~/dotfiles
git pull
```

Gracias a los symlinks, esto actualiza automáticamente `.zshrc`, `.zprofile`, `.gitconfig`, `.gitignore_global` y `vscode/settings.json` sin pasos adicionales — el symlink apunta directo al archivo del repo.

Si el cambio incluyó paquetes nuevos o extensiones de VS Code (`Brewfile`), aplica también:

```bash
brew bundle --file=~/dotfiles/Brewfile
```

## Verificar el entorno
`doctor.sh` revisa que todo lo que el repositorio instala y configura esté realmente presente: Homebrew, Git, GitHub CLI, symlinks, cada paquete del `Brewfile`, cada cask, y cada extensión de VS Code. Se ejecuta automáticamente al final de `bootstrap.sh`, pero también puedes correrlo manualmente en cualquier momento:

```bash
bash ~/dotfiles/doctor.sh
```
o, usando el alias incluido en `.zshrc`:
```bash
doctor
```

Como lee directamente del `Brewfile`, no requiere mantenimiento manual — cualquier paquete o extensión nueva que agregues ahí se verifica automáticamente la próxima vez que corras el doctor.

## Actualizar dotfiles
Cuando cambies paquetes, extensiones o configuraciones:
```bash
~/dotfiles/update.sh
git add .
git commit -m "tipo: descripción breve"
git push
```
`update.sh` actualiza Homebrew, sincroniza el `Brewfile` automáticamente, y corre `doctor.sh` al final.

### Tipos de commit
| Tipo    | Cuándo usarlo                       |
|---------|-------------------------------------|
| `feat`  | Algo nuevo que no existía           |
| `fix`   | Corrección de algo roto             |
| `chore` | Mantenimiento sin impacto funcional |
| `docs`  | Solo documentación                  |

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
```
dotfiles/
├── bootstrap.sh
├── update.sh
├── doctor.sh
├── Brewfile
├── git/
│   ├── .gitconfig
│   └── .gitignore_global
├── vscode/
│   └── settings.json
└── zsh/
    ├── .zshrc
    └── .zprofile
```

## Hardware
- Mac Mini M4 (Apple Silicon)
