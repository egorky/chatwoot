#!/usr/bin/env bash
set -e

# ==============================================================================
# Script to apply or revert unified customization and feature patches
# ==============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PATCH_FILE="${SCRIPT_DIR}/unified_customizations.patch"

usage() {
  echo "Uso: $0 [apply | revert | check | run-all]"
  echo ""
  echo "Comandos:"
  echo "  apply     Aplica el parche unificado al repositorio."
  echo "  revert    Revierte el parche unificado y restaura copias .back si existen."
  echo "  check     Verifica si el parche puede aplicarse limpiamente sin errores."
  echo "  run-all   Aplica el parche y ejecuta los scripts de personalización y voz."
  exit 1
}

check_patch() {
  if [ ! -f "$PATCH_FILE" ]; then
    echo "Error: No se encontró el archivo de parche: $PATCH_FILE"
    exit 1
  fi
  echo "Verificando el parche unificado..."
  if git apply --check "$PATCH_FILE"; then
    echo "El parche se puede aplicar limpiamente."
    return 0
  else
    echo "Error: El parche no se puede aplicar limpiamente."
    return 1
  fi
}

apply_patch() {
  if [ ! -f "$PATCH_FILE" ]; then
    echo "Error: No se encontró el archivo de parche: $PATCH_FILE"
    exit 1
  fi
  echo "Aplicando el parche unificado..."
  git apply "$PATCH_FILE"
  echo "Parche aplicado exitosamente."
}

revert_patch() {
  if [ -f "${SCRIPT_DIR}/restore.sh" ]; then
    echo "Ejecutando restore.sh para restaurar archivos modificados por scripts..."
    "${SCRIPT_DIR}/restore.sh" || true
  fi

  if [ -f "$PATCH_FILE" ]; then
    echo "Revirtiendo el parche unificado..."
    git apply --reverse "$PATCH_FILE" 2>/dev/null || echo "Aviso: Algunos cambios del parche ya estaban revertidos."
  fi
  echo "Reversión completada."
}

run_all_customizations() {
  echo "=== Aplicando scripts de personalización ==="

  # 1. Aplicar cambios de UI en Sidebar
  if [ -f "${SCRIPT_DIR}/modify-sidebar.js" ]; then
    echo "Ejecutando modify-sidebar.js..."
    node "${SCRIPT_DIR}/modify-sidebar.js"
  fi

  # 2. Ocultar pestañas de conversación para no administradores
  if [ -f "${SCRIPT_DIR}/hide-extra-tabs.js" ]; then
    echo "Ejecutando hide-extra-tabs.js..."
    node "${SCRIPT_DIR}/hide-extra-tabs.js"
  fi

  # 3. Desactivar banner de actualización
  if [ -f "${SCRIPT_DIR}/disable-update-check.sh" ]; then
    echo "Ejecutando disable-update-check.sh..."
    "${SCRIPT_DIR}/disable-update-check.sh"
  fi

  # 4. Actualizar manifiesto PWA
  if [ -f "${SCRIPT_DIR}/update-pwa-manifest.sh" ]; then
    echo "Ejecutando update-pwa-manifest.sh..."
    "${SCRIPT_DIR}/update-pwa-manifest.sh"
  fi

  # 5. Reemplazar menciones en i18n
  if [ -f "${SCRIPT_DIR}/translate-i18n.sh" ]; then
    echo "Ejecutando translate-i18n.sh..."
    "${SCRIPT_DIR}/translate-i18n.sh"
  fi

  # 6. Nullificar URLs de telemetría de Chatwoot
  if [ -f "${SCRIPT_DIR}/bin/nullify_chatwoot_urls.sh" ]; then
    echo "Ejecutando bin/nullify_chatwoot_urls.sh..."
    "${SCRIPT_DIR}/bin/nullify_chatwoot_urls.sh"
  fi

  echo "=== Personalizaciones completadas exitosamente ==="
  echo "Nota: Para activar el canal Twilio Voice en la base de datos, ejecute bin/activate_voice.sh"
}

ACTION="${1:-apply}"

case "$ACTION" in
  apply)
    apply_patch
    ;;
  revert)
    revert_patch
    ;;
  check)
    check_patch
    ;;
  run-all)
    if git apply --check "$PATCH_FILE" >/dev/null 2>&1; then
      apply_patch
    else
      echo "El parche ya ha sido aplicado o los archivos ya están presentes en el repositorio."
    fi
    run_all_customizations
    ;;
  *)
    usage
    ;;
esac
