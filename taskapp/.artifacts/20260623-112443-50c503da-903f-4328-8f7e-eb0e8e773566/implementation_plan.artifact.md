# Implementación de Persistencia con Firebase Firestore y Auth

El objetivo es reemplazar el almacenamiento en memoria por una persistencia real en la nube usando Firebase, permitiendo además la autenticación de usuarios.

## Requisitos Previos (Acción del Usuario)
Debido a que no puedo interactuar con la consola de forma externa para el login de Firebase, necesito que ejecutes lo siguiente en tu terminal si aún no lo has hecho:
1. `npm install -g firebase-tools` (si no tienes Firebase CLI)
2. `firebase login`
3. `dart pub global activate flutterfire_cli`
4. `flutterfire configure` (selecciona tu proyecto o crea uno nuevo)

## Cambios Propuestos

### Dependencias
#### [pubspec.yaml](file:///C:/Users/edwip/OneDrive/Documents/TaskApp/taskapp/pubspec.yaml)
- Añadir `firebase_core`, `cloud_firestore` y `firebase_auth`.

---

### Modelos
#### [task_model.dart](file:///C:/Users/edwip/OneDrive/Documents/TaskApp/taskapp/lib/models/task_model.dart)
- Añadir métodos `toMap()` y `fromMap()` para serialización con Firestore.
- Convertir `TimeOfDay` a `String` o `Map` para almacenamiento.

---

### Proveedores y Autenticación
#### [NEW] [auth_provider.dart](file:///C:/Users/edwip/OneDrive/Documents/TaskApp/taskapp/lib/providers/auth_provider.dart)
- Manejar el estado de autenticación (Login, Registro, Logout).

#### [task_provider.dart](file:///C:/Users/edwip/OneDrive/Documents/TaskApp/taskapp/lib/providers/task_provider.dart)
- Refactorizar para usar `Stream<List<Task>>` desde Firestore en lugar de una lista local.
- Vincular las tareas al `uid` del usuario autenticado.

---

### Interfaz de Usuario
#### [NEW] [login_screen.dart](file:///C:/Users/edwip/OneDrive/Documents/TaskApp/taskapp/lib/screens/login_screen.dart)
- Pantalla para que el usuario inicie sesión o se registre.

#### [main.dart](file:///C:/Users/edwip/OneDrive/Documents/TaskApp/taskapp/lib/main.dart)
- Inicializar Firebase.
- Envolver la app en un `StreamBuilder` para alternar entre Login y Home.

## Plan de Verificación

### Verificación Manual
- Registrar un nuevo usuario.
- Crear una tarea y verificar que aparezca en la consola de Firebase.
- Cerrar sesión e iniciar con otro usuario; verificar que no vea las tareas del primero.
- Activar el modo avión y verificar que la app siga funcionando (offline-first de Firestore).
