#!/bin/bash

# Este script reemplaza la palabra "Chatwoot" por "Sempitecno" en todos
# los archivos de internacionalización (i18n) de la aplicación.
# Crea un archivo de respaldo .back para cada archivo modificado.

# Salir inmediatamente si un comando falla.
set -e

# --- Configuración ---
I18N_DIRECTORY="app/javascript/dashboard/i18n/"
SEARCH_WORD="Chatwoot"
REPLACE_WORD="Sempitecno"

echo "Iniciando el script de traducción de i18n..."

# --- Lógica Principal ---
# Verificar si el directorio de i18n existe.
if [ ! -d "$I18N_DIRECTORY" ]; then
    echo "Advertencia: Directorio '$I18N_DIRECTORY' no encontrado. Omitiendo."
    exit 0
fi

# Encontrar todos los archivos .json en el directorio de i18n y sus subdirectorios.
# Para cada archivo, usar sed para reemplazar la palabra (ignorando mayúsculas y minúsculas)
# y crear un archivo de respaldo (si aún no existe).
find "$I18N_DIRECTORY" -type f -name "*.json" -print0 | while IFS= read -r -d '' file; do
    echo "Procesando '$file'..."
    if [ ! -f "${file}.back" ]; then
        cp "$file" "${file}.back"
    fi
    sed -i "s/${SEARCH_WORD}/${REPLACE_WORD}/gi" "$file"
done

# --- Limpieza ---
# Eliminar cualquier archivo .back vacío que sed pueda haber creado.
find "$I18N_DIRECTORY" -type f -name "*.back" -size 0 -delete

echo "Traducción de i18n completada. Se han creado archivos de respaldo .back para todos los archivos modificados."
