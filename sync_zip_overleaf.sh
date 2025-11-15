#!/bin/bash

echo "-------------------------------------------------"
echo "   SCRIPT DI SINCRONIZZAZIONE ZIP → GIT (TESI)"
echo "-------------------------------------------------"
echo

# === CONFIGURAZIONE ===
TESI_DIR="$(pwd)"
ZIP_FILE="Tesi_Barone.zip"
TARGET_DIR="$TESI_DIR/Tesi_Barone"
LOG_FILE="$TESI_DIR/sync_log.txt"

echo "[INFO] Cartella tesi: $TESI_DIR"
echo "[INFO] ZIP previsto: $ZIP_FILE"
echo "[INFO] Cartella di destinazione: $TARGET_DIR"
echo "[INFO] File di log: $LOG_FILE"
echo

# === 1. VERIFICA ESISTENZA ZIP ===
if [ ! -f "$ZIP_FILE" ]; then
    echo "[ERRORE] Il file $ZIP_FILE non esiste nella cartella!"
    exit 1
fi

echo "[OK] File ZIP trovato: $ZIP_FILE"
echo

# === 2. CREA LA CARTELLA DI DESTINAZIONE SE NON ESISTE ===
mkdir -p "$TARGET_DIR"

# === 3. UNZIP CON SOVRASCRITTURA ===
echo "[INFO] Estraggo lo ZIP nella cartella Tesi_Barone..."
unzip -o -q "$ZIP_FILE" -d "$TARGET_DIR"   # -o = overwrite senza chiedere

echo "[OK] Estrazione completata."
echo

# === 4. MESSAGGIO DI COMMIT ===
echo "Scrivi il messaggio del commit:"
read COMMIT_MSG

if [ -z "$COMMIT_MSG" ]; then
    COMMIT_MSG="Aggiornamento automatico da ZIP"
fi

echo "[INFO] Messaggio di commit: \"$COMMIT_MSG\""
echo

# === 5. GIT ADD/COMMIT/PUSH ===
echo "[INFO] Eseguo git add..."
git add .

echo "[INFO] Eseguo git commit..."
git commit -m "$COMMIT_MSG"

echo "[INFO] Eseguo git push..."
git push

echo "[OK] Push completato!"
echo

# === 6. LOG ===
{
    echo "------------------------------"
    echo "$(date)"
    echo "ZIP sincronizzato: $ZIP_FILE"
    echo "Cartella estratta: Tesi_Barone"
    echo "Commit: $COMMIT_MSG"
    echo "------------------------------"
} >> "$LOG_FILE"

echo "[INFO] Log aggiornato in: $LOG_FILE"
echo

echo "-------------------------------------------------"
echo "    SINCRONIZZAZIONE COMPLETATA CON SUCCESSO 🎉"
echo "-------------------------------------------------"
