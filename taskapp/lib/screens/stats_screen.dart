import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task_model.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Estadísticas')),
      body: Consumer<TaskProvider>(
        builder: (context, provider, child) {
          final totalTasks = provider.tasks.length;
          final completedTasks = provider.tasks.where((t) => t.isCompleted).length;
          final pendingTasks = totalTasks - completedTasks;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Resumen General', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Row(
                  children: [
                    _buildStatCard('Total', totalTasks.toString(), Colors.blue),
                    const SizedBox(width: 16),
                    _buildStatCard('Completadas', completedTasks.toString(), Colors.green),
                    const SizedBox(width: 16),
                    _buildStatCard('Pendientes', pendingTasks.toString(), Colors.orange),
                  ],
                ),
                const SizedBox(height: 32),
                const Text('Tareas por Categoría', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                ...TaskCategory.values.take(4).map((cat) {
                  final count = provider.tasks.where((t) => t.category == cat).length;
                  final percentage = totalTasks > 0 ? count / totalTasks : 0.0;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(cat.name[0].toUpperCase() + cat.name.substring(1)),
                            Text('$count tasks'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: percentage,
                          backgroundColor: Colors.grey.shade200,
                          color: Theme.of(context).colorScheme.primary,
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(fontSize: 12, color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}
