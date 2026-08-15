import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';
import 'package:intl/intl.dart';
import 'task_detail_sheet.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final bool isHorizontal;

  const TaskCard({
    super.key,
    required this.task,
    this.isHorizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    Color priorityColor = _getPriorityColor(task.priority);

    if (isHorizontal) {
      return Hero(
        tag: 'task_${task.id}',
        child: Material(
          color: Colors.transparent,
          child: GestureDetector(
            onTap: () => _showTaskDetails(context),
            child: Container(
              width: 200,
              margin: const EdgeInsets.only(right: 16, bottom: 8),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    priorityColor.withValues(alpha: 0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: priorityColor.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          task.category.name.toUpperCase(),
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Icon(
                        task.isCompleted ? Icons.check_circle : Icons.circle_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    task.title,
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_month, color: Colors.white70, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('d MMM').format(task.dueDate),
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showTaskDetails(context),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: priorityColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  _getCategoryIcon(task.category),
                  color: priorityColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                            color: task.isCompleted ? Theme.of(context).colorScheme.outline : null,
                          ),
                    ),
                    Text(
                      '${task.startTime.format(context)} - ${task.category.name}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.outline),
                    ),
                  ],
                ),
              ),
              Checkbox(
                value: task.isCompleted,
                onChanged: (val) {
                  HapticFeedback.lightImpact();
                  context.read<TaskProvider>().toggleTaskStatus(task.id);
                  _showUndoSnackBar(context);
                },
                shape: const CircleBorder(),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  if (value == 'delete') {
                    context.read<TaskProvider>().deleteTask(task.id);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Eliminar', style: TextStyle(color: Colors.red)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showTaskDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => TaskDetailSheet(task: task),
    );
  }

  void _showUndoSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(task.isCompleted ? 'Tarea completada' : 'Tarea pendiente'),
        action: SnackBarAction(
          label: 'DESHACER',
          onPressed: () {
            context.read<TaskProvider>().toggleTaskStatus(task.id);
          },
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Color _getPriorityColor(TaskPriority p) {
    switch (p) {
      case TaskPriority.high: return Colors.red;
      case TaskPriority.medium: return Colors.orange;
      case TaskPriority.low: return Colors.green;
    }
  }

  IconData _getCategoryIcon(TaskCategory category) {
    switch (category) {
      case TaskCategory.design: return Icons.brush;
      case TaskCategory.meeting: return Icons.people;
      case TaskCategory.coding: return Icons.code;
      case TaskCategory.study: return Icons.book;
      case TaskCategory.personal: return Icons.person_outline;
      case TaskCategory.work: return Icons.work_outline;
      default: return Icons.task;
    }
  }
}
