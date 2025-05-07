#!/bin/bash

# Bestimme den Ordner, in dem das Skript liegt
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$SCRIPT_DIR"
REMOTE_URL="https://github.com/diggerwf/Updater.git"
UPDATE_SCRIPT="$REPO_DIR/update.sh"
TEMP_UPDATE_SCRIPT="$REPO_DIR/update.sh.2"

# Funktion zum Holen des aktuellen Commit-Hashes der update.sh
get_current_hash() {
    git -C "$REPO_DIR" rev-parse HEAD 2>/dev/null
}

# Funktion zum Holen des neuesten Remote-Commit-Hashes für update.sh
get_remote_hash() {
    git ls-remote "$REMOTE_URL" HEAD | awk '{print $1}'
}

# Prüfen, ob das Repository vorhanden ist
if [ -d "$REPO_DIR/.git" ]; then
    echo "Repository gefunden. Prüfe auf Updates..."
    cd "$REPO_DIR" || exit
    git fetch origin

    LOCAL_HASH=$(get_current_hash)
    REMOTE_HASH=$(get_remote_hash)

    if [ "$LOCAL_HASH" != "$REMOTE_HASH" ]; then
        echo "Update für update.sh erkannt."

        # Kopiere die aktuelle update.sh nach update.sh.2
        cp "$UPDATE_SCRIPT" "$TEMP_UPDATE_SCRIPT"

        # Ersetze die aktuelle update.sh durch die Version im Remote-Repository
        git checkout -- "$UPDATE_SCRIPT"

        # Stelle sicher, dass die neue update.sh ausführbar ist
        chmod +x "$UPDATE_SCRIPT"

        # Führe die aktualisierte update.sh aus (rekursiv)
        bash "$UPDATE_SCRIPT"

        # Nach Abschluss: lösche die temporäre Datei (falls gewünscht)
        rm -f "$TEMP_UPDATE_SCRIPT"

        # Beende das aktuelle Skript, da die neue Version jetzt läuft
        exit 0
    fi

    echo "Das Repository ist bereits aktuell."
else
    # Falls der Ordner nicht existiert, klone das Repository hierhin
    echo "Repository nicht gefunden. Klone es..."
    git clone "$REMOTE_URL" "$REPO_DIR"
fi

# Hier folgt dein ursprüngliches Update-Logik...
