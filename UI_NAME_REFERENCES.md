# Referencias del Nombre "Chatwoot" en la Interfaz de Usuario

Este documento describe las ubicaciones clave en el código fuente donde se utiliza el nombre "Chatwoot" en la interfaz de usuario. Esta guía es esencial para cualquiera que busque realizar un "rebranding" completo o "white-labeling" de la plataforma, asegurando que todas las menciones del nombre de la aplicación sean reemplazadas.

## Manifiesto de la Aplicación Web Progresiva (PWA)

El manifiesto PWA define el nombre de la aplicación, los iconos y otros detalles que se utilizan cuando un usuario "instala" la aplicación en su dispositivo.

-   **Archivo:** `public/manifest.json`
-   **Claves a Modificar:** Deberá cambiar los valores de `short_name` y `name` en este archivo para que reflejen el nombre de su aplicación.

    ```json
    {
      "short_name": "Chatwoot",
      "name": "Chatwoot",
      "...": "..."
    }
    ```

## Archivos de Internacionalización (i18n)

La mayoría del texto visible en la interfaz de usuario, incluido el nombre de la aplicación, se gestiona a través de archivos de internacionalización (i18n). Cambiar el nombre en estos archivos lo actualizará en todo el panel de control.

-   **Ubicación Principal:** `app/javascript/dashboard/i18n/locale/en/`
-   **Archivos Clave:**
    -   `generalSettings.json`: A menudo contiene el nombre de la aplicación utilizado en varias configuraciones.
    -   `login.json`: Para la página de inicio de sesión.
    -   `signup.json`: Para la página de registro.
    -   `resetPassword.json`: Para la página de restablecimiento de contraseña.
-   **Recomendación:** Busque "Chatwoot" en todos los archivos `.json` dentro del directorio `app/javascript/dashboard/i18n/locale/en/` y reemplace las apariciones por el nombre de su aplicación. Después, deberá asegurarse de que su proceso de compilación actualice los archivos de idioma para otros idiomas si es necesario.

## Títulos de Página y Metadatos

El título principal de la aplicación que aparece en la pestaña del navegador se define en las vistas principales de Rails.

-   **Archivo:** `app/views/layouts/dashboard.html.erb`
-   **Línea a Modificar:** Busque la etiqueta `<title>` y reemplace "Chatwoot" por el nombre de su aplicación.

    ```html
    <title>
      <%= @page_title.present? ? "#{@page_title} - Chatwoot" : "Chatwoot" %>
    </title>
    ```

## Componentes de Vue y Texto Hardcodeado

Aunque la mayoría del texto se maneja a través de i18n, algunas apariciones del nombre "Chatwoot" pueden estar hardcodeadas directamente en los componentes de Vue, especialmente en contenido de marketing o informativo.

-   **Ubicaciones Comunes:**
    -   `app/javascript/dashboard/components-next/sidebar/SidebarChangelogCard.vue`: Puede contener enlaces o texto sobre las actualizaciones de Chatwoot.
    -   `app/javascript/v3/views/auth/signup/components/Signup/Form.vue`: La página de registro puede tener texto adicional de la marca.
    -   `app.json`: Puede contener el nombre "Chatwoot" en la configuración de la aplicación Heroku.

-   **Recomendación:** Realice una búsqueda global (sin distinguir entre mayúsculas y minúsculas) de "Chatwoot" en todos los archivos `.vue` y `.js` para encontrar y reemplazar cualquier aparición hardcodeada que no se gestione a través de i18n.

Al actualizar estas ubicaciones clave, puede eliminar eficazmente las referencias al nombre "Chatwoot" de la interfaz de usuario de la aplicación.
