import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskProvider with ChangeNotifier {
  final List<Task> _tasks = [];
  String _language = 'es';
  String _userName = 'Usuario';
  bool _isDarkMode = false;
  int _selectedFilterIndex = 0; // 0: All, 1: In Progress, 2: Completed

  List<Task> get tasks => [..._tasks];
  String get language => _language;
  String get userName => _userName;
  bool get isDarkMode => _isDarkMode;
  int get selectedFilterIndex => _selectedFilterIndex;

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

  void setLanguage(String lang) {
    _language = lang;
    notifyListeners();
  }

  void toggleDarkMode(bool val) {
    _isDarkMode = val;
    notifyListeners();
  }

  void setUserName(String name) {
    _userName = name;
    notifyListeners();
  }

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void updateTask(Task task) {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index >= 0) {
      _tasks[index] = task;
      notifyListeners();
    }
  }

  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void toggleTaskStatus(String id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index >= 0) {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
      notifyListeners();
    }
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
    }
  };

  String translate(String key) {
    return _localizedStrings[_language]?[key] ?? key;
  }
}
