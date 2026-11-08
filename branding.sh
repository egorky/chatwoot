#!/bin/bash

# Este script reemplaza todas las apariciones de chatwoot.com y chwt.app
# con un dominio especificado.
# - Crea un respaldo .back SOLO de los archivos que realmente modifica.
# - Genera un archivo de registro (branding_changed_files.txt) con una lista de todos los archivos modificados.

# Salir inmediatamente si un comando falla.
set -e

# --- Configuración ---
REPLACE_DOMAIN="inexistent.com"
SEARCH_STRINGS=("chatwoot.com" "chwt.app")
# Patrón ERE para grep
SEARCH_PATTERN=$(IFS=\|; echo "${SEARCH_STRINGS[*]}")

LOG_FILE="branding_changed_files.txt"

# Scripts a excluir de la modificación.
EXCLUDE_FILES=("branding.sh" "restore.sh" "modify-sidebar.js" "modify-chat-list.js")
EXCLUDE_PATTERN=$(printf -- "--exclude=%s " "${EXCLUDE_FILES[@]}")

echo "Iniciando el script de reemplazo de dominios..."

# Limpiar el archivo de registro al inicio.
> "$LOG_FILE"

# --- Lógica Principal ---
# 1. Encontrar la lista de archivos que contienen las cadenas de búsqueda.
echo "Identificando archivos para modificar..."
# Usamos `grep -l` para obtener solo los nombres de los archivos.
# Se excluyen directorios comunes y los propios scripts.
FILES_TO_MODIFY=$(grep -rliE "$SEARCH_PATTERN" . \
    --exclude-dir={.git,node_modules,tmp,vendor} \
    $EXCLUDE_PATTERN)

if [ -z "$FILES_TO_MODIFY" ]; then
    echo "No se encontraron archivos que necesiten modificación."
    exit 0
fi

echo "Se modificarán los siguientes archivos:"
echo "$FILES_TO_MODIFY"
echo "---"

# 2. Iterar sobre la lista, crear respaldo, modificar y registrar.
echo "$FILES_TO_MODIFY" | while IFS= read -r file; do
    # Omitir líneas vacías que puedan aparecer en la salida de grep
    if [ -z "$file" ]; then
        continue
    fi

    echo "Procesando '$file'..."

    # Crear respaldo si aún no existe.
    if [ ! -f "${file}.back" ]; then
        cp "$file" "${file}.back"
    fi

    # Realizar el reemplazo in-situ (sin crear otro .back).
    # Se construyen múltiples expresiones -e para sed.
    SED_EXPRESSIONS=""
    for search_string in "${SEARCH_STRINGS[@]}"; do
        SED_EXPRESSIONS+="-e s/${search_string}/${REPLACE_DOMAIN}/g "
    done

    # Ejecutar sed con todas las expresiones.
    # shellcheck disable=SC2086
    sed -i $SED_EXPRESSIONS "$file"

    # Registrar el archivo modificado.
    echo "$file" >> "$LOG_FILE"
done

echo "---"
echo "Reemplazo de dominios completado."
echo "Se han creado archivos de respaldo .back para todos los archivos modificados."
echo "Una lista de los archivos modificados se ha guardado en '$LOG_FILE'."
