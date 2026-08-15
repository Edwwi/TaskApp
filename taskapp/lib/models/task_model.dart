import 'package:flutter/material.dart';

enum TaskCategory {
  design,
  meeting,
  coding,
  biz,
  testing,
  quickest,
  work,
  personal,
  study,
  urgent
}

enum TaskPriority {
  high,
  medium,
  low
}

class Task {
  final String id;
  final String title;
  final String description;
  final TaskCategory category;
  final TaskPriority priority;
  final DateTime dueDate;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final int reminderMinutes;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.dueDate,
    required this.startTime,
    required this.endTime,
    this.reminderMinutes = 0,
    this.isCompleted = false,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'category': category.name,
      'priority': priority.name,
      'dueDate': dueDate.toIso8601String(),
      'startTime': '${startTime.hour}:${startTime.minute}',
      'endTime': '${endTime.hour}:${endTime.minute}',
      'reminderMinutes': reminderMinutes,
      'isCompleted': isCompleted,
    };
  }

  factory Task.fromFirestore(Map<String, dynamic> data, String id) {
    final startTimeParts = (data['startTime'] as String).split(':');
    final endTimeParts = (data['endTime'] as String).split(':');

    return Task(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      category: TaskCategory.values.byName(data['category'] ?? 'personal'),
      priority: TaskPriority.values.byName(data['priority'] ?? 'medium'),
      dueDate: DateTime.parse(data['dueDate']),
      startTime: TimeOfDay(
        hour: int.parse(startTimeParts[0]),
        minute: int.parse(startTimeParts[1]),
      ),
      endTime: TimeOfDay(
        hour: int.parse(endTimeParts[0]),
        minute: int.parse(endTimeParts[1]),
      ),
      reminderMinutes: data['reminderMinutes'] ?? 0,
      isCompleted: data['isCompleted'] ?? false,
    );
  }

  Task copyWith({
    String? id,
    String? title,
    String? description,
    TaskCategory? category,
    TaskPriority? priority,
    DateTime? dueDate,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    int? reminderMinutes,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      reminderMinutes: reminderMinutes ?? this.reminderMinutes,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
