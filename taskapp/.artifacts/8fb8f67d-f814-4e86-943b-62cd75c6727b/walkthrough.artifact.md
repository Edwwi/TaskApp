# Notificaciones y Modelo de Negocio - Check-IT

Se han implementado las funcionalidades de permisos de notificación y la pantalla de modelos de negocio para profesionalizar la aplicación.

## Cambios Realizados

### 1. Sistema de Notificaciones
- **`NotificationService`**: Nueva clase de servicio para gestionar la inicialización de notificaciones y la solicitud de permisos.
- **Solicitud en el Primer Inicio**: La aplicación ahora detecta si es la primera vez que se abre y lanza automáticamente el diálogo de permiso del sistema (Android e iOS).
- **Configuración Nativa**: Se añadieron los permisos necesarios en el `AndroidManifest.xml` (`POST_NOTIFICATIONS`, `SCHEDULE_EXACT_ALARM`, etc.) para asegurar la compatibilidad con Android 13+.

### 2. Pantalla de Suscripción (Modelo de Negocio)
- **`SubscriptionScreen`**: Nueva interfaz premium con fondo oscuro siguiendo fielmente el diseño de la imagen proporcionada.
- **Planes en DOP**: Se configuraron tres niveles de precios:
    - **Free (DOP $0)**: Gestión básica y OCR esencial.
    - **Pro (DOP $650)**: IA avanzada, escaneo ilimitado y analíticas.
    - **Teams (DOP $800/usuario)**: Herramientas de colaboración e integraciones corporativas.
- **Acceso desde Perfil**: Se añadió un nuevo apartado en la pantalla de **Perfil** llamado "Planes de Suscripción" con un icono de estrella dorada.

## Verificación

> [!IMPORTANT]
> **Primera Ejecución**: Al desinstalar y reinstalar la app, el sistema preguntará inmediatamente por los permisos de notificación.
> **Diseño**: La pantalla de suscripción utiliza colores `Colors.blueAccent`, `Colors.greenAccent` y `Colors.orangeAccent` para diferenciar claramente los planes.

---

¡La aplicación **Check-IT** ahora está lista para ser presentada en el formato Shark Tank con una estrategia de negocio clara y un sistema de retención de usuarios (notificaciones) robusto!
