#!/bin/bash

echo "-------------------------------------------------"
echo "   SCRIPT DI SINCRONIZZAZIONE ZIP → GIT (TESI)"
echo "-------------------------------------------------"
echo

# === CONFIGURAZIONE ===
TESI_DIR="$(pwd)"
LOG_FILE="$TESI_DIR/sync_log.txt"

echo "[INFO] Cartella tesi: $TESI_DIR"
echo "[INFO] File di log: $LOG_FILE"
echo

# === 1. TROVA IL FILE ZIP ===
ZIP_FILE=$(ls *.zip 2>/dev/null | head -n 1)

if [ -z "$ZIP_FILE" ]; then
    echo "[ERRORE] Nessun file ZIP trovato nella cartella tesi."
    exit 1
fi

echo "[OK] Trovato file ZIP: $ZIP_FILE"
echo

# === 2. CREA UNA CARTELLA TEMP ===
TEMP_DIR="$TESI_DIR/_tmp_unzip"

echo "[INFO] Creo la cartella temporanea: $TEMP_DIR"
rm -rf "$TEMP_DIR"
mkdir "$TEMP_DIR"

# === 3. UNZIP ===
echo "[INFO] Estraggo lo ZIP..."
unzip -q "$ZIP_FILE" -d "$TEMP_DIR"

echo "[OK] Estrazione completata."
echo

# === 4. SOSTITUZIONE CONTENUTO ===
echo "[INFO] Rimuovo file attuali (eccetto .git, script e ZIP)..."

find "$TESI_DIR" -maxdepth 1 ! -name "_tmp_unzip" \
                                   ! -name ".git" \
                                   ! -name "*.zip" \
                                   ! -name "$(basename $0)" \
                                   -exec rm -rf {} +

echo "[OK] Cartella pulita."
echo

echo "[INFO] Copio i nuovi file dalla cartella estratta..."

# Copia contenuto della cartella unzippata
cp -R "$TEMP_DIR"/* "$TESI_DIR/"

echo "[OK] Copia completata."
echo

# === 5. CHIEDI IL MESSAGGIO DI COMMIT ===
echo "Scrivi il messaggio del commit:"
read COMMIT_MSG

if [ -z "$COMMIT_MSG" ]; then
    COMMIT_MSG="Aggiornamento automatico"
fi

echo "[INFO] Messaggio di commit: \"$COMMIT_MSG\""
echo

# === 6. GIT ADD/COMMIT/PUSH ===
echo "[INFO] Eseguo git add..."
git add .

echo "[INFO] Eseguo git commit..."
git commit -m "$COMMIT_MSG"

echo "[INFO] Eseguo git push..."
git push

echo "[OK] Push completato!"
echo

# === 7. LOG ===
{
    echo "------------------------------"
    echo "$(date)"
    echo "ZIP sincronizzato: $ZIP_FILE"
    echo "Commit: $COMMIT_MSG"
    echo "------------------------------"
} >> "$LOG_FILE"

echo "[INFO] Log aggiornato in: $LOG_FILE"
echo

echo "-------------------------------------------------"
echo "    SINCRONIZZAZIONE COMPLETATA CON SUCCESSO 🎉"
echo "-------------------------------------------------"

