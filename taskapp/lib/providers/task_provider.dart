import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskProvider with ChangeNotifier {
  final List<Task> _tasks = [
    Task(
      id: '1',
      title: 'Front-End Development',
      description: 'Project 1 description',
      category: TaskCategory.design,
      priority: TaskPriority.high,
      dueDate: DateTime(2026, 6, 2),
      startTime: const TimeOfDay(hour: 9, minute: 0),
      endTime: const TimeOfDay(hour: 17, minute: 0),
    ),
    Task(
      id: '2',
      title: 'Back-End Development',
      description: 'Project 2 description',
      category: TaskCategory.coding,
      priority: TaskPriority.medium,
      dueDate: DateTime(2026, 6, 2),
      startTime: const TimeOfDay(hour: 10, minute: 0),
      endTime: const TimeOfDay(hour: 18, minute: 0),
    ),
    Task(
      id: '3',
      title: 'Design Changes',
      description: 'Minor tweaks',
      category: TaskCategory.design,
      priority: TaskPriority.low,
      dueDate: DateTime(2026, 6, 2),
      startTime: const TimeOfDay(hour: 13, minute: 22),
      endTime: const TimeOfDay(hour: 15, minute: 20),
    ),
  ];

  List<Task> get tasks => [..._tasks];

  List<Task> get tasksForToday {
    final now = DateTime.now();
    return _tasks.where((task) => 
      task.dueDate.year == now.year &&
      task.dueDate.month == now.month &&
      task.dueDate.day == now.day
    ).toList();
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

  List<Task> filterTasks({TaskCategory? category, bool? isCompleted}) {
    return _tasks.where((task) {
      final categoryMatch = category == null || task.category == category;
      final statusMatch = isCompleted == null || task.isCompleted == isCompleted;
      return categoryMatch && statusMatch;
    }).toList();
  }
}
