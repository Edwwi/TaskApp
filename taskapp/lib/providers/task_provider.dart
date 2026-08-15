import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';

class TaskProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Task> _tasks = [];
  String? _userId;

  String _language = 'es';
  String _firstName = '';
  String _lastName = '';
  bool _isDarkMode = false;
  int _selectedFilterIndex = 0;

  List<Task> get tasks => [..._tasks];
  String get language => _language;
  String get userName => '$_firstName $_lastName'.trim().isEmpty ? 'Usuario' : '$_firstName $_lastName';
  bool get isDarkMode => _isDarkMode;
  int get selectedFilterIndex => _selectedFilterIndex;

  // Actualizar el ID de usuario y sincronizar
  void updateUserId(String? uid) {
    if (_userId == uid) return;
    _userId = uid;
    if (_userId != null) {
      _listenToTasks();
      _fetchUserProfile();
    } else {
      _tasks = [];
      _firstName = '';
      _lastName = '';
      notifyListeners();
    }
  }

  void _listenToTasks() {
    _firestore
        .collection('users')
        .doc(_userId)
        .collection('tasks')
        .snapshots()
        .listen((snapshot) {
      _tasks = snapshot.docs
          .map((doc) => Task.fromFirestore(doc.data(), doc.id))
          .toList();
      notifyListeners();
    });
  }

  Future<void> _fetchUserProfile() async {
    if (_userId == null) return;
    try {
      final doc = await _firestore.collection('users').doc(_userId).get();
      if (doc.exists) {
        final data = doc.data()!;
        _firstName = data['firstName'] ?? '';
        _lastName = data['lastName'] ?? '';
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error al obtener perfil: $e');
    }
  }

  void setFilterIndex(int index) {
    _selectedFilterIndex = index;
    notifyListeners();
  }

  List<Task> get filteredTasks {
    if (_selectedFilterIndex == 1) {
      return _tasks.where((t) => !t.isCompleted).toList();
    } else if (_selectedFilterIndex == 2) {
      return _tasks.where((t) => t.isCompleted).toList();
    }
    return [..._tasks];
  }

  // Métodos de Firestore
  Future<void> addTask(Task task) async {
    if (_userId == null) return;
    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('tasks')
        .add(task.toFirestore());
  }

  Future<void> updateTask(Task task) async {
    if (_userId == null) return;
    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('tasks')
        .doc(task.id)
        .update(task.toFirestore());
  }

  Future<void> deleteTask(String id) async {
    if (_userId == null) return;
    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('tasks')
        .doc(id)
        .delete();
  }

  Future<void> toggleTaskStatus(String id) async {
    final task = _tasks.firstWhere((t) => t.id == id);
    await updateTask(task.copyWith(isCompleted: !task.isCompleted));
  }

  // UI Settings
  void setLanguage(String lang) {
    _language = lang;
    notifyListeners();
  }

  void toggleDarkMode(bool val) {
    _isDarkMode = val;
    notifyListeners();
  }

  // Localization strings
  final Map<String, Map<String, String>> _localizedStrings = {
    'es': {
      'welcome': 'Hola',
      'tasks_today': 'Tienes {count} tareas hoy',
      'no_tasks': 'No tienes tareas aún. ¡Crea una!',
      'my_tasks': 'Mis tareas',
      'in_progress': 'En progreso',
      'completed': 'Completadas',
      'progress': 'Progreso',
      'create_task': 'Crear una Tarea',
      'name': 'Nombre',
      'date': 'Fecha',
      'start_time': 'Hora Inicio',
      'end_time': 'Hora Fin',
      'description': 'Descripción',
      'category': 'Categoría',
      'priority': 'Prioridad',
      'reminder': 'Recordatorio',
      'none': 'Ninguno',
      'min_5': '5 minutos antes',
      'min_15': '15 minutos antes',
      'min_30': '30 minutos antes',
      'hour_1': '1 hora antes',
      'save': 'Crear Tarea',
      'profile': 'Perfil',
      'language': 'Idioma',
      'stats': 'Estadísticas',
      'total': 'Total',
      'pending': 'Pendientes',
      'preferences': 'Preferencias',
      'dark_mode': 'Modo Oscuro',
      'high': 'Alta',
      'medium': 'Media',
      'low': 'Baja',
      'mark_completed': 'Marcar completada',
      'mark_pending': 'Marcar pendiente',
      'logout': 'Cerrar Sesión',
    },
    'en': {
      'welcome': 'Hello',
      'tasks_today': 'You have {count} tasks today',
      'no_tasks': 'No tasks yet. Create one!',
      'my_tasks': 'My tasks',
      'in_progress': 'In progress',
      'completed': 'Completed',
      'progress': 'Progress',
      'create_task': 'Create a Task',
      'name': 'Name',
      'date': 'Date',
      'start_time': 'Start Time',
      'end_time': 'End Time',
      'description': 'Description',
      'category': 'Category',
      'priority': 'Priority',
      'reminder': 'Reminder',
      'none': 'None',
      'min_5': '5 minutes before',
      'min_15': '15 minutes before',
      'min_30': '30 minutes before',
      'hour_1': '1 hour before',
      'save': 'Create Task',
      'profile': 'Profile',
      'language': 'Language',
      'stats': 'Statistics',
      'total': 'Total',
      'pending': 'Pending',
      'preferences': 'Preferences',
      'dark_mode': 'Dark Mode',
      'high': 'High',
      'medium': 'Medium',
      'low': 'Low',
      'mark_completed': 'Mark completed',
      'mark_pending': 'Mark pending',
      'logout': 'Logout',
    }
  };

  String translate(String key) {
    return _localizedStrings[_language]?[key] ?? key;
  }
}
