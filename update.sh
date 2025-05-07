#!/bin/bash

# Bestimme den Ordner, in dem das Skript liegt
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Pfad zum updater-Ordner im selben Verzeichnis
REPO_DIR="$SCRIPT_DIR"

# URL des Git-Repositories
REMOTE_URL="https://github.com/diggerwf/Updater.git"

# Prüfen, ob der updater-Ordner bereits ein Git-Repository ist
if [ -d "$REPO_DIR/.git" ]; then
    echo "Repository gefunden. Aktualisiere..."
    cd "$REPO_DIR" || exit
    git fetch origin

    LOCAL=$(git rev-parse @)
    REMOTE=$(git rev-parse origin/main)
    BASE=$(git merge-base @ origin/main)

    if [ "$LOCAL" = "$REMOTE" ]; then
        echo "Das Repository ist bereits aktuell."
    elif [ "$LOCAL" = "$BASE" ]; then
        echo "Updates verfügbar. Führe git pull aus..."
        git pull origin main && echo "Update erfolgreich!"
    else
        echo "Lokale Änderungen oder Divergenz erkannt. Bitte prüfen."
    fi
else
    # Falls der Ordner nicht existiert, klone das Repository hierhin
    echo "Repository nicht gefunden. Klone es..."
    git clone "$REMOTE_URL" "$REPO_DIR"
fi
