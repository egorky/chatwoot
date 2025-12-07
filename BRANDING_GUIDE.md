# Guía de Personalización de Marca de Chatwoot

Esta guía explica cómo modificar los logos y el esquema de colores de la plataforma Chatwoot para que coincida con su propia marca.

## Personalización de Logos

La aplicación utiliza varios archivos de logo en diferentes ubicaciones. Para un cambio de marca completo, deberá reemplazar los siguientes archivos de logo con sus propias versiones. Se recomienda mantener las mismas dimensiones y formatos de archivo para evitar problemas de alineación en la interfaz de usuario.

### Logos Principales

-   **Logo del Panel de Control:** El logo principal que aparece en la barra lateral y en otras áreas clave.
    -   **Archivo:** `app/javascript/dashboard/components-next/icon/Logo.vue`
    -   **Recomendación:** Este es un componente de Vue que contiene el SVG del logo directamente. Deberá editar este archivo y reemplazar el SVG existente con su propio SVG.

-   **Activos de Marca Públicos:** Estos logos se utilizan en páginas públicas, correos electrónicos y otros activos.
    -   **Archivos:**
        -   `public/brand-assets/logo.svg` (versión clara)
        -   `public/brand-assets/logo_dark.svg` (versión oscura)
        -   `public/brand-assets/logo_thumbnail.svg` (versión en miniatura)
    -   **Recomendación:** Reemplace estos archivos con sus logos correspondientes.

-   **Logo del Widget:** El logo que aparece en el widget de chat.
    -   **Archivo:** `app/javascript/widget/assets/images/logo.svg`
    -   **Recomendación:** Reemplace este archivo SVG con el logo de su widget.

### Favicon

Para reemplazar el favicon (el ícono que aparece en la pestaña del navegador), reemplace los siguientes archivos:

-   `public/favicon.ico`
-   `public/apple-touch-icon.png`

## Personalización de Colores

La paleta de colores de la aplicación se gestiona a través de Tailwind CSS. El archivo de configuración principal de los colores se encuentra en `theme/colors.js`.

### Pasos para Cambiar los Colores

1.  **Abra `theme/colors.js`:** Este archivo contiene un objeto JavaScript que define la paleta de colores de la aplicación, utilizando un sistema de escalas de colores (por ejemplo, `azul-50`, `azul-100`, `azul-200`, etc.).

2.  **Modifique los Valores de los Colores:**
    -   Puede cambiar los valores hexadecimales de los colores existentes para que coincidan con la paleta de su marca. Por ejemplo, si desea cambiar el color primario, deberá modificar las variables `azul`.
    -   La configuración utiliza un formato `hsl` o `rgb` para los colores, así que asegúrese de que sus nuevos valores de color sigan el mismo formato.

3.  **Recompile los Activos:** Después de modificar los colores, deberá recompilar los activos de JavaScript y CSS para que los cambios surtan efecto. Puede hacerlo ejecutando el siguiente comando:

    ```bash
    pnpm dev
    ```

    O, si está en un entorno de producción, deberá reconstruir los activos según los procedimientos de implementación de su entorno.

Al seguir esta guía, puede personalizar eficazmente los logos y colores de su instancia de Chatwoot para alinearla con la identidad visual de su marca.
