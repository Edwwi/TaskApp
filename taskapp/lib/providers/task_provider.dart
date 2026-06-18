import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskProvider extends ChangeNotifier {
  final List<Task> _tasks = [];
  String _selectedCategoryFilter = 'Todas';
  String _selectedStatusFilter = 'Todas'; // todas, pendientes, completadas

  List<Task> get tasks {
    List<Task> filtered = _tasks;

    // Filtro por categoría
    if (_selectedCategoryFilter != 'Todas') {
      filtered = filtered.where((t) => t.category == _selectedCategoryFilter).toList();
    }

    // Filtro por estado
    if (_selectedStatusFilter == 'Pendientes') {
      filtered = filtered.where((t) => !t.isCompleted).toList();
    } else if (_selectedStatusFilter == 'Completadas') {
      filtered = filtered.where((t) => t.isCompleted).toList();
    }

    return filtered;
  }

  List<Task> get allTasks => _tasks;
  List<Task> get pendingTasks => _tasks.where((t) => !t.isCompleted).toList();
  List<Task> get completedTasks => _tasks.where((t) => t.isCompleted).toList();

  String get selectedCategoryFilter => _selectedCategoryFilter;
  String get selectedStatusFilter => _selectedStatusFilter;

  // Obtener tareas por rango de fecha
  List<Task> getTasksByDateRange(DateTime startDate, DateTime endDate) {
    return _tasks.where((t) {
      return t.deadline.isAfter(startDate.subtract(const Duration(days: 1))) &&
             t.deadline.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();
  }

  // Obtener tareas por una fecha específica
  List<Task> getTasksByDate(DateTime date) {
    return _tasks.where((t) {
      return t.deadline.year == date.year &&
             t.deadline.month == date.month &&
             t.deadline.day == date.day;
    }).toList();
  }

  // Estadísticas: contar tareas por categoría
  Map<String, int> getTasksByCategory() {
    final Map<String, int> stats = {};
    for (final task in _tasks) {
      stats[task.category] = (stats[task.category] ?? 0) + 1;
    }
    return stats;
  }

  // Estadísticas: contar tareas completadas por categoría
  Map<String, int> getCompletedTasksByCategory() {
    final Map<String, int> stats = {};
    for (final task in _tasks.where((t) => t.isCompleted)) {
      stats[task.category] = (stats[task.category] ?? 0) + 1;
    }
    return stats;
  }

  // Obtener porcentaje de completado
  double getCompletionPercentage() {
    if (_tasks.isEmpty) return 0;
    return (_tasks.where((t) => t.isCompleted).length / _tasks.length) * 100;
  }

  void setCategoryFilter(String category) {
    _selectedCategoryFilter = category;
    notifyListeners();
  }

  void setStatusFilter(String status) {
    _selectedStatusFilter = status;
    notifyListeners();
  }

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void updateTask(String id, Task updatedTask) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      notifyListeners();
    }
  }

  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void toggleTaskStatus(String id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
      notifyListeners();
    }
  }
}