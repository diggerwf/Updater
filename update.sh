#!/bin/bash

# Bestimme das Verzeichnis, in dem das Skript liegt
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

REPO_DIR="$SCRIPT_DIR/updater"
REMOTE_URL="https://github.com/diggerwf/Updater.git"

if [ ! -d "$REPO_DIR" ]; then
    echo "Repository nicht gefunden. Klone es..."
    git clone "$REMOTE_URL" "$REPO_DIR"
else
    cd "$REPO_DIR" || exit
    if [ -d ".git" ]; then
        echo "Repository gefunden. Aktualisiere..."
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
        echo "Das Verzeichnis ist kein Git-Repository. Klone neu..."
        rm -rf "$REPO_DIR"
        git clone "$REMOTE_URL" "$REPO_DIR"
    fi
fi
