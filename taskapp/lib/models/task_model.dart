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
