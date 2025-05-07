#!/bin/bash

# GitHub-Repository-URL und Branch definieren
REPO_URL="https://github.com/diggerwf/Updater.git"
BRANCH="main"

# Pfad zum Repository (aktueller Ordner)
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$REPO_DIR" || exit

# Dateien
UPDATE_SCRIPT="$REPO_DIR/update.sh"
TEMP_UPDATE_SCRIPT="$REPO_DIR/update.sh.2"

# Funktionen
get_current_hash() {
    git rev-parse HEAD 2>/dev/null
}

get_remote_hash() {
    git ls-remote "$REPO_URL" "$BRANCH" | awk '{print $1}'
}

if [ -d "$REPO_DIR/.git" ]; then
    echo "Repository gefunden. Prüfe auf Updates..."
    cd "$REPO_DIR" || exit

    git reset --hard
    git fetch origin

    LOCAL_HASH=$(get_current_hash)
    REMOTE_HASH=$(get_remote_hash)

    if [ "$LOCAL_HASH" != "$REMOTE_HASH" ]; then
        echo "Update für update.sh erkannt."
        cp "$UPDATE_SCRIPT" "$TEMP_UPDATE_SCRIPT"
        git pull origin "$BRANCH"
        chmod +x "$UPDATE_SCRIPT"
        bash "$UPDATE_SCRIPT"
        rm -f "$TEMP_UPDATE_SCRIPT"
        exit 0
    else
        echo "Das Repository ist bereits aktuell."
    fi
else
    echo "Repository nicht gefunden. Klone es..."
    git clone "$REPO_URL" "$REPO_DIR"
fi

chmod +x "$UPDATE_SCRIPT"

echo "Update abgeschlossen oder kein Update erforderlich."
