#!/bin/bash

SETTINGS_FILE="${HOME}/.local/share/code-server/User/settings.json"
mkdir -p "$(dirname "$SETTINGS_FILE")"
cat > "$SETTINGS_FILE" << 'EOF'
{
    "workbench.colorTheme": "JupyterLab Light Theme",
    "workbench.iconTheme": "material-icon-theme",
    "files.trimTrailingWhitespace": true,
    "files.insertFinalNewline": true,
    "notebook.output.fontSize": 13,
    "notebook.output.scrolling": true,
    "editor.fontFamily": "JetBrains Mono",
    "editor.fontSize": 13,
    "workbench.startupEditor": "none",
    "workbench.secondarySidebar.enabled": false,
    "chat.editor.showChat": false,
    "chat.experimental.showOnStartup": false,
    "workbench.panel.chat.enabled": false,
    "welcomePage.walkthroughs.openOnInstall": false,
    "editor.gettingStartedPreferences.experimental.showOnStartup": "off",
    "terminal.integrated.cwd": "/home/onyxia/work/ai-patents-and-innovation",
    "files.exclude": {
        "**/__pycache__": true,
        "**/.env": true,
        "**/.lnk": true,
        "**/.vscode": true,
        "**/*.lnk": true,
        "**/requirements.txt": true,
        "**/.cache": true,
        "**/squashfs-root": true
    }
}
EOF

# Install system dependencies and fonts

sudo rm -f /etc/apt/sources.list.d/*ubuntugis*

sudo apt clean

sudo apt update -y

sudo apt install -y ghostscript libreoffice xvfb fontconfig fonts-liberation2 texlive-latex-extra texlive-pictures

sudo tlmgr install tikz-3dplot

# Copy Arial Narrow fonts if available

mkdir -p "$HOME/.local/share/fonts"

find "/home/onyxia/work/ai-patents-and-innovation/fonts" -maxdepth 1 -type f \

    \( -iname 'arial-narrow*.ttf' -o -iname 'arialnarrow*.ttf' -o -iname 'arial narrow*.ttf' \

    -o -iname 'ArialNarrow*.ttf' -o -iname 'Arial Narrow*.ttf' \) \

    -print0 | xargs -0 -r -I{} cp -f "{}" "$HOME/.local/share/fonts/"

fc-cache -f -v

# Install Material Icon Theme extension

wget --retry-on-http-error=429 https://github.com/jmtr1/OECD-onyxia-workspace/raw/refs/heads/main/pkief.material-icon-theme-5.27.0.vsix -O material-icon-theme.vsix

code-server --install-extension "$(pwd)/material-icon-theme.vsix"

wget --retry-on-http-error=429 https://github.com/jmtr1/OECD-onyxia-workspace/raw/refs/heads/main/jupyterlab-light-theme.vsix -O jupyterlab-light-theme.vsix

code-server --install-extension "$(pwd)/jupyterlab-light-theme.vsix"

code-server --install-extension mathematic.vscode-pdf

# Install Python packages (commented for now) NEW!

uv pip install --system torch dask transformers ipywidgets boto3 openai dotenv optuna lightgbm wandb igraph openpyxl nbconvert botocore==1.40.18 s3fs matplotlib-venn

rm -rf inkscape.appimage material-icon-theme.vsix jupyterlab-light-theme.vsix

mkdir -p "/home/onyxia/work/ai-patents-and-innovation/output/figures"