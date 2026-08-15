# Rediseño Integral Material Design 3 - Check-IT

Este plan detalla la transformación de la aplicación "TaskApp" a una experiencia moderna siguiendo los estándares de Material Design 3, accesibilidad WCAG 2.1 AA y micro-interacciones.

## User Review Required

> [!IMPORTANT]
> **Identidad Visual**: Se ha seleccionado el nombre **"Check-IT"** y el color semilla **#2196F3** (extraído del icono proporcionado).
> **Tipografía**: Se utilizará **Google Font "Poppins"** como fuente principal para un aspecto moderno y limpio.
> **Assets**: Se requiere que el usuario guarde la imagen del icono en `assets/images/app_logo.png` para configurar el Splash Screen nativo.

## Open Questions

- ¿Existe alguna ilustración específica que prefiera para el onboarding? De lo contrario, usaré iconos vectoriales elegantes o placeholders de colores.

---

## Proposed Changes

### Parte A: Branding y Material Design 3

#### [MODIFY] [pubspec.yaml](file:///C:/Users/edwip/OneDrive/Documents/TaskApp/taskapp/pubspec.yaml)
- Añadir dependencias: `google_fonts`, `flutter_native_splash`, `shared_preferences`, `shimmer`, `smooth_page_indicator`.
- Configurar activos y fuentes.

#### [MODIFY] [app_theme.dart](file:///C:/Users/edwip/OneDrive/Documents/TaskApp/taskapp/lib/theme/app_theme.dart)
- Implementar `ColorScheme.fromSeed` con `seedColor: Color(0xFF2196F3)`.
- Integrar `GoogleFonts.poppinsTextTheme()`.
- Configurar temas Light y Dark unificados.

#### [NEW] [onboarding_screen.dart](file:///C:/Users/edwip/OneDrive/Documents/TaskApp/taskapp/lib/screens/onboarding_screen.dart)
- Crear flujo de 3 pantallas con `PageView` y `DotsIndicator`.
- Lógica de persistencia con `SharedPreferences`.

#### [MODIFY] [main.dart](file:///C:/Users/edwip/OneDrive/Documents/TaskApp/taskapp/lib/main.dart)
- Actualizar `MaterialApp` para manejar el estado de onboarding.
- Configurar `useMaterial3: true`.

---

### Parte B: Mejoras de UI

#### [MODIFY] [main.dart](file:///C:/Users/edwip/OneDrive/Documents/TaskApp/taskapp/lib/main.dart)
- Reemplazar `BottomNavigationBar` por `NavigationBar`.
- Añadir `NavigationRail` para layouts adaptativos (tablets).

#### [MODIFY] [home_screen.dart](file:///C:/Users/edwip/OneDrive/Documents/TaskApp/taskapp/lib/screens/home_screen.dart)
- Implementar `SearchAnchor` en el `AppBar`.
- Reemplazar listas estáticas por estados (Loading/Empty/Error).

#### [NEW] [ui_state_widgets.dart](file:///C:/Users/edwip/OneDrive/Documents/TaskApp/taskapp/lib/widgets/ui_state_widgets.dart)
- Crear widgets reutilizables para `ShimmerLoading`, `EmptyState` y `ErrorState`.

#### [MODIFY] [task_card.dart](file:///C:/Users/edwip/OneDrive/Documents/TaskApp/taskapp/lib/widgets/task_card.dart)
- Usar `Card` con elevación tonal de M3.
- Actualizar jerarquía de botones.

---

### Parte C: Animaciones y Micro-interacciones

#### [MODIFY] [task_card.dart](file:///C:/Users/edwip/OneDrive/Documents/TaskApp/taskapp/lib/widgets/task_card.dart)
- Envolver elementos clave en `Hero` para transiciones a detalles.
- Añadir `HapticFeedback` en acciones de completado.

#### [MODIFY] [home_screen.dart](file:///C:/Users/edwip/OneDrive/Documents/TaskApp/taskapp/lib/screens/home_screen.dart)
- Usar `AnimatedList` para inserción/borrado de tareas.
- `AnimatedSwitcher` para cambios de estado de UI.

---

### Parte D: Accesibilidad WCAG 2.1 AA

#### [GENERAL] Auditoría de Semántica
- Envolver todos los iconos e imágenes con `Semantics(label: '...')`.
- Asegurar que los botones tengan un área de toque de al menos `48x48dp`.
- Verificar contraste de colores generados por M3.

## Verification Plan

### Automated Tests
- Ejecutar `flutter analyze` para asegurar limpieza del código.

### Manual Verification
- Probar el flujo de onboarding (debe aparecer solo una vez).
- Cambiar el tema del sistema (Light/Dark) y verificar la adaptación automática.
- Probar la navegación en diferentes tamaños de pantalla (si es posible simular tablet).
- Verificar que el `SnackBar` de borrado tenga opción de deshacer.
