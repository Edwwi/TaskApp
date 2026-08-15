# Sugerencias Inteligentes con IA (Gemini)

Este plan detalla la integración de **Google Gemini AI** para proporcionar sugerencias automáticas al crear tareas, analizando tanto el texto extraído de archivos/fotos como lo que el usuario escribe manualmente.

## User Review Required

> [!IMPORTANT]
> **API Key de Gemini**: Para que esta funcionalidad sea gratuita y rápida de implementar, utilizaremos el paquete `google_generative_ai`. Se requiere una API Key de [Google AI Studio](https://aistudio.google.com/).
> **Prompt Engineering**: Se ha diseñado un prompt específico para que la IA devuelva siempre un formato JSON válido que la app pueda procesar.

## Proposed Changes

### 1. Servicio de Inteligencia Artificial

#### [MODIFY] [pubspec.yaml](file:///C:/Users/edwip/OneDrive/Documents/TaskApp/taskapp/pubspec.yaml)
- Añadir la dependencia `google_generative_ai`.

#### [NEW] [ai_service.dart](file:///C:/Users/edwip/OneDrive/Documents/TaskApp/taskapp/lib/services/ai_service.dart)
- Crear una clase que configure el modelo `gemini-1.5-flash`.
- Método `suggestFields(String rawText)` que analice el texto y extraiga: Título, Descripción, Prioridad, Categoría y Fecha estimada.

### 2. Integración en Captura (OCR)

#### [MODIFY] [capture_screen.dart](file:///C:/Users/edwip/OneDrive/Documents/TaskApp/taskapp/lib/screens/capture_screen.dart)
- Al terminar el OCR, en lugar de crear una tarea genérica, enviar el texto a la IA.
- Mostrar una pantalla intermedia de "Propuesta de IA" donde el usuario vea los campos sugeridos antes de guardar.

### 3. Integración en Creación Manual

#### [MODIFY] [create_task_screen.dart](file:///C:/Users/edwip/OneDrive/Documents/TaskApp/taskapp/lib/screens/create_task_screen.dart)
- Añadir un botón flotante o de acción con el icono `Icons.auto_awesome` (Magia).
- Al pulsarlo, la IA analizará el Título y Descripción actuales para rellenar automáticamente la Prioridad, Categoría y sugerir una fecha.

## Verification Plan

### Manual Verification
1. **Prueba OCR**: Subir una foto de un ticket o nota manuscrita. Verificar que la IA asigna una categoría lógica (ej: "Work" si dice "Reunión", "Study" si dice "Examen").
2. **Prueba Manual**: Escribir en el título "Estudiar para el examen de Flutter el lunes" y pulsar el botón de IA. Verificar que:
    - La categoría cambie a **Study**.
    - La prioridad sea **Alta**.
    - La fecha se ajuste al próximo lunes.
