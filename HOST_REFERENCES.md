# Referencias de Host de Chatwoot

Este documento enumera los archivos clave en el código fuente donde se hace referencia a los hosts `chatwoot.com`. Esta lista es útil para fines de "rebranding" o "white-labeling", ya que le ayuda a identificar rápidamente dónde necesita reemplazar las URL específicas de Chatwoot.

La siguiente lista fue generada buscando `chatwoot.com` y excluyendo archivos de prueba, dependencias y archivos de documentación.

## Archivos de Configuración y Scripts

- `config/initializers/devise.rb`: Contiene configuraciones para la autenticación de usuarios.
- `.env.example`: Archivo de ejemplo de variables de entorno, que puede contener URLs predeterminadas.
- `lib/chatwoot_hub.rb`: Lógica relacionada con el Chatwoot Hub.
- `deployment/setup_20.04.sh`: Scripts de implementación que pueden contener URLs hardcodeadas.
- `deployment/setup_18.04.sh`: Scripts de implementación que pueden contener URLs hardcodeadas.

## Backend (Rails)

- `app/views/super_admin/settings/show.html.erb`: Vistas de administrador que pueden mostrar URLs.
- `app/views/mailers/administrator_notifications/account_notification_mailer/account_deletion_for_inactivity.liquid`: Plantillas de correo electrónico que contienen enlaces.
- `app/presenters/mail_presenter.rb`: Lógica de presentación para correos electrónicos.
- `app/controllers/public_controller.rb`: Controladores públicos que pueden manejar redireccionamientos o enlaces.
- `app/mailers/application_mailer.rb`: Configuración base para los mailers de la aplicación.
- `app/mailers/conversation_reply_mailer.rb`: Plantillas de correo electrónico para respuestas de conversación.

## Frontend (JavaScript/Vue)

- `app/javascript/entrypoints/v3app.js`: Punto de entrada principal para la aplicación de JavaScript.
- `app/javascript/v3/views/auth/signup/components/Signup/Form.vue`: Componente de formulario de registro.
- `app/javascript/dashboard/components/widgets/AICTAModal.vue`: Componentes de la interfaz de usuario que pueden contener enlaces a documentación o sitios externos.
- `app/javascript/dashboard/components/widgets/conversation/ReplyBox.vue`: Componente de caja de respuesta.
- `app/javascript/dashboard/routes/dashboard/settings/inbox/settingsPage/ConfigurationPage.vue`: Página de configuración de la bandeja de entrada.
- `app/javascript/dashboard/constants/globals.js`: Archivo de constantes globales.
- `app/javascript/dashboard/components-next/captain/pageComponents/emptyStates/captainEmptyStateContent.js`: Contenido para estados vacíos de la interfaz de usuario.
- `app/javascript/dashboard/components-next/Campaigns/EmptyState/CampaignEmptyStateContent.js`: Contenido para estados vacíos de campañas.
- `app/javascript/dashboard/components-next/sidebar/SidebarChangelogCard.vue`: Tarjeta de registro de cambios en la barra lateral.
- `app/javascript/dashboard/components-next/sidebar/SidebarProfileMenu.vue`: Menú de perfil en la barra lateral.
- `app/javascript/shared/constants/links.js`: Archivo dedicado a almacenar URLs y enlaces.
