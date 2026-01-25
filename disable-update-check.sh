#!/bin/bash

# Este script desactiva el banner de notificación de actualización comentando
# el componente UpdateBanner en el archivo principal de la aplicación.
# Crea un archivo de respaldo .back del archivo modificado.

# Salir inmediatamente si un comando falla.
set -e

# --- Configuración ---
APP_VUE_FILE="app/javascript/dashboard/App.vue"
SEARCH_PATTERN="<UpdateBanner :latest-chatwoot-version=\"latestChatwootVersion\" />"

echo "Iniciando el script para desactivar la verificación de actualizaciones..."

# --- Lógica Principal ---
# Verificar si el archivo App.vue existe.
if [ ! -f "$APP_VUE_FILE" ]; then
    echo "Advertencia: Archivo '$APP_VUE_FILE' no encontrado. Omitiendo."
    exit 0
fi

# Comentar la línea que contiene el componente UpdateBanner.
# Usamos sed para encontrar la línea y envolverla en comentarios HTML.
# Crear respaldo si aún no existe.
if [ ! -f "${APP_VUE_FILE}.back" ]; then
    cp "$APP_VUE_FILE" "${APP_VUE_FILE}.back"
fi

echo "Comentando el componente UpdateBanner en '$APP_VUE_FILE'..."
sed -i "s|${SEARCH_PATTERN}|<!-- ${SEARCH_PATTERN} -->|" "$APP_VUE_FILE"

echo "El banner de actualización ha sido desactivado exitosamente."
