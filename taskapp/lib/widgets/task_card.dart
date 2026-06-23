import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';
import '../theme/app_theme.dart';
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
      return GestureDetector(
        onTap: () => _showTaskDetails(context),
        child: Container(
          width: 200,
        margin: const EdgeInsets.only(right: 16, bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF4A90E2),
              priorityColor.withValues(alpha: 0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
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
                Row(
                  children: [
                    const Icon(Icons.settings, color: Colors.white70, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      task.category.name.toUpperCase(),
                      style: const TextStyle(color: Colors.white70, fontSize: 10),
                    ),
                  ],
                ),
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                ),
              ],
            ),
            const Spacer(),
            Text(
              task.title,
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            Text(
              DateFormat('d MMMM, yyyy').format(task.dueDate),
              style: const TextStyle(color: Colors.white70, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

    return GestureDetector(
      onTap: () => _showTaskDetails(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(16),
          border: Border(left: BorderSide(color: priorityColor, width: 4)),
          boxShadow: const [
            BoxShadow(
              color: AppTheme.cardShadow,
              blurRadius: 8,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: priorityColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
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
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Row(
                    children: [
                      Text(
                        task.startTime.format(context),
                        style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                      ),
                      if (task.reminderMinutes > 0) ...[
                        const SizedBox(width: 8),
                        Icon(Icons.notifications_active, size: 12, color: AppTheme.primaryBlue.withValues(alpha: 0.5)),
                      ]
                    ],
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 'delete') {
                  context.read<TaskProvider>().deleteTask(task.id);
                } else if (value == 'toggle') {
                  context.read<TaskProvider>().toggleTaskStatus(task.id);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'toggle',
                  child: Text(task.isCompleted ? 'Marcar pendiente' : 'Marcar completada'),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Eliminar', style: TextStyle(color: Colors.red)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _showTaskDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TaskDetailSheet(task: task),
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
