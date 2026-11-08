#!/usr/bin/env node

// Este script modifica ChatList.vue para ocultar la pestaña "Todos" a los usuarios
// que no son administradores. Sigue el patrón robusto de modify-sidebar.js.

const fs = require('fs');
const path = require('path');

const CHAT_LIST_FILE_PATH = path.join(__dirname, 'app/javascript/dashboard/components/ChatList.vue');
const BACKUP_FILE_PATH = `${CHAT_LIST_FILE_PATH}.back`;

/**
 * Encuentra el bloque de texto completo de una propiedad computada o función en un string.
 * @param {string} content El contenido completo del string a buscar.
 * @param {string} startPattern El inicio del bloque de código (ej. "const assigneeTabItems = computed(() => {").
 * @returns {{startIndex: number, endIndex: number, block: string}|null}
 */
function findCodeBlock(content, startPattern) {
  const startIndex = content.indexOf(startPattern);
  if (startIndex === -1) {
    return null;
  }

  // Asumimos que el bloque es una función o propiedad computada, por lo que buscamos el paréntesis de apertura.
  let openParenIndex = content.indexOf('(', startIndex);
  let braceCount = 1;
  let currentIndex = openParenIndex + 1;

  while (currentIndex < content.length && braceCount > 0) {
    if (content[currentIndex] === '(' || content[currentIndex] === '{') {
      braceCount++;
    } else if (content[currentIndex] === ')' || content[currentIndex] === '}') {
      braceCount--;
    }
    currentIndex++;
  }

  if (braceCount !== 0) {
    return null; // Paréntesis/llaves no coincidentes
  }

  return {
    startIndex,
    endIndex: currentIndex,
    block: content.substring(startIndex, currentIndex),
  };
}


// --- Lógica Principal ---
try {
  if (!fs.existsSync(CHAT_LIST_FILE_PATH)) {
    console.warn(`Advertencia: Archivo de ChatList no encontrado en ${CHAT_LIST_FILE_PATH}. Omitiendo.`);
    process.exit(0);
  }

  // Crear un respaldo si aún no existe.
  if (!fs.existsSync(BACKUP_FILE_PATH)) {
    console.log(`Creando archivo de respaldo en ${BACKUP_FILE_PATH}...`);
    fs.copyFileSync(CHAT_LIST_FILE_PATH, BACKUP_FILE_PATH);
  } else {
    console.log('El archivo de respaldo ya existe.');
  }

  let fileContent = fs.readFileSync(CHAT_LIST_FILE_PATH, 'utf8');
  let modified = false;

  // 1. Inyectar la importación de useAdmin.
  const importMarker = "import { useAdmin } from 'dashboard/composables/useAdmin';";
  const importAnchor = "import { useI18n } from 'vue-i18n';";
  if (!fileContent.includes(importMarker)) {
    fileContent = fileContent.replace(importAnchor, `${importAnchor}\n${importMarker}`);
    console.log('Importación de useAdmin inyectada.');
    modified = true;
  }

  // 2. Inyectar la llamada a useAdmin.
  const useAdminMarker = "const { isAdmin } = useAdmin();";
  const useAdminAnchor = "const { t } = useI18n();";
  if (!fileContent.includes(useAdminMarker)) {
    fileContent = fileContent.replace(useAdminAnchor, `${useAdminAnchor}\nconst { isAdmin } = useAdmin();`);
    console.log('Llamada a useAdmin inyectada.');
    modified = true;
  }

  // 3. Reemplazar la propiedad computada assigneeTabItems.
  const startPattern = "const assigneeTabItems = computed(() => {";
  const blockToReplace = findCodeBlock(fileContent, startPattern);

  const newCode = `const assigneeTabItems = computed(() => {
  const allTabs = filterItemsByPermission(
    ASSIGNEE_TYPE_TAB_PERMISSIONS,
    userPermissions.value,
    item => item.permissions
  ).map(({ key, count: countKey }) => ({
    key,
    name: t(\`CHAT_LIST.ASSIGNEE_TYPE_TABS.\${key}\`),
    count: conversationStats.value[countKey] || 0,
  }));

  if (!isAdmin.value) {
    return allTabs.filter(tab => tab.key !== 'all');
  }

  return allTabs;
});`;

  if (blockToReplace && blockToReplace.block.trim() !== newCode.trim()) {
    fileContent = fileContent.substring(0, blockToReplace.startIndex) + newCode + fileContent.substring(blockToReplace.endIndex);
    console.log('Propiedad computada "assigneeTabItems" reemplazada.');
    modified = true;
  } else if (!blockToReplace) {
    console.warn('Advertencia: No se pudo encontrar el bloque de código de assigneeTabItems para reemplazar.');
  }

  // Escribir el archivo solo si se realizaron cambios.
  if (modified) {
    fs.writeFileSync(CHAT_LIST_FILE_PATH, fileContent, 'utf8');
    console.log('Archivo ChatList.vue modificado exitosamente.');
  } else {
    console.log('No se necesitaron modificaciones en ChatList.vue.');
  }

} catch (error) {
  console.error('Ocurrió un error:', error);
  process.exit(1);
}
