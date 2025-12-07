#!/usr/bin/env node

// Este script modifica el componente Sidebar.vue para ocultar elementos del menú.
// Específicamente, elimina la sección 'Captain' y comenta varias opciones
// de configuración.
// Crea un archivo de respaldo .back antes de modificar el archivo.

const fs = require('fs');
const path = require('path');

const SIDEBAR_FILE_PATH = path.join(__dirname, 'app/javascript/dashboard/components-next/sidebar/Sidebar.vue');
const BACKUP_FILE_PATH = `${SIDEBAR_FILE_PATH}.back`;

/**
 * Encuentra el bloque de texto completo de un objeto JavaScript en un string basado en un patrón de inicio.
 * Maneja correctamente las llaves anidadas.
 * @param {string} content El contenido completo del string a buscar.
 * @param {string} startPattern Un string único que identifica el inicio del objeto.
 * @returns {{startIndex: number, endIndex: number, block: string}|null}
 */
function findObjectBlock(content, startPattern) {
  const patternIndex = content.indexOf(startPattern);
  if (patternIndex === -1) {
    return null;
  }

  // Encuentra la llave de apertura del objeto literal `{` que precede al patrón.
  let startIndex = content.lastIndexOf('{', patternIndex);
  if (startIndex === -1) {
    return null;
  }

  let braceCount = 1;
  let currentIndex = startIndex + 1;

  while (currentIndex < content.length && braceCount > 0) {
    if (content[currentIndex] === '{') {
      braceCount++;
    } else if (content[currentIndex] === '}') {
      braceCount--;
    }
    currentIndex++;
  }

  if (braceCount !== 0) {
    return null; // Llaves no coincidentes
  }

  // El bloque termina en la llave de cierre. Busca la coma final si existe.
  let endIndex = currentIndex;
  while (endIndex < content.length && /\s|,/.test(content[endIndex])) {
    if (content[endIndex] === ',') {
      endIndex++;
      break;
    }
    endIndex++;
  }

  return {
    startIndex,
    endIndex,
    block: content.substring(startIndex, endIndex),
  };
}

// --- Lógica Principal ---
try {
  // Verificar si el archivo de la barra lateral existe.
  if (!fs.existsSync(SIDEBAR_FILE_PATH)) {
    console.warn(`Advertencia: Archivo de la barra lateral no encontrado en ${SIDEBAR_FILE_PATH}. Omitiendo modificación.`);
    process.exit(0);
  }

  // Crear un respaldo si aún no existe.
  if (!fs.existsSync(BACKUP_FILE_PATH)) {
    console.log(`Creando archivo de respaldo en ${BACKUP_FILE_PATH}...`);
    fs.copyFileSync(SIDEBAR_FILE_PATH, BACKUP_FILE_PATH);
  } else {
    console.log('El archivo de respaldo ya existe, no se creará uno nuevo.');
  }

  let fileContent = fs.readFileSync(SIDEBAR_FILE_PATH, 'utf8');

  // --- Eliminar el elemento del menú "Captain" ---
  console.log("Eliminando la sección 'Captain'...");
  const captainBlock = findObjectBlock(fileContent, "name: 'Captain',");
  if (captainBlock) {
    fileContent = fileContent.substring(0, captainBlock.startIndex) + fileContent.substring(captainBlock.endIndex);
    console.log("'Captain' sección eliminada exitosamente.");
  } else {
    console.warn("Advertencia: Sección 'Captain' no encontrada. Omitiendo eliminación.");
  }

  // --- Comentar la sección de configuración ---
  console.log("Comentando la sección de configuración...");
  const settingsStartPattern = "name: 'Settings Audit Logs',";
  const settingsEndPattern = "to: accountScopedRoute('billing_settings_index'),";

  // Usar el contenido del archivo ya modificado para el segundo patrón
  const settingsStartBlock = findObjectBlock(fileContent, settingsStartPattern);
  const settingsEndBlock = findObjectBlock(fileContent, settingsEndPattern);

  if (settingsStartBlock && settingsEndBlock) {
    const commentStartIndex = settingsStartBlock.startIndex;
    const commentEndIndex = settingsEndBlock.endIndex;

    const originalBlock = fileContent.substring(commentStartIndex, commentEndIndex);
    const commentedBlock = `/* ${originalBlock} */`;

    fileContent = fileContent.substring(0, commentStartIndex) + commentedBlock + fileContent.substring(commentEndIndex);
    console.log("Sección de configuración comentada exitosamente.");
  } else {
    console.warn("Advertencia: Sección de configuración para comentar no encontrada. Omitiendo.");
  }

  // Escribir el contenido modificado de nuevo en el archivo.
  fs.writeFileSync(SIDEBAR_FILE_PATH, fileContent, 'utf8');
  console.log('Archivo de la barra lateral modificado exitosamente.');

} catch (error) {
  console.error('Ocurrió un error:', error);
  process.exit(1);
}
