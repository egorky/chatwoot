#!/bin/bash

# Define the target file
TARGET_FILE="public/manifest.json"
BACKUP_FILE="$TARGET_FILE.back"

# Check if the target file exists
if [ ! -f "$TARGET_FILE" ]; then
  echo "Error: El archivo $TARGET_FILE no existe."
  exit 1
fi

# Create a backup if it doesn't exist
if [ ! -f "$BACKUP_FILE" ]; then
  cp "$TARGET_FILE" "$BACKUP_FILE"
  echo "Backup de $TARGET_FILE creado en $BACKUP_FILE."
fi

# Replace "Chatwoot" with "Sempitecno" in name and short_name fields
sed -i -e 's/"name": "Chatwoot"/"name": "Sempitecno"/' \
       -e 's/"short_name": "Chatwoot"/"short_name": "Sempitecno"/' "$TARGET_FILE"

echo "El manifiesto PWA ($TARGET_FILE) ha sido actualizado."
echo "Se ha reemplazado 'Chatwoot' por 'Sempitecno' en los campos name y short_name."
