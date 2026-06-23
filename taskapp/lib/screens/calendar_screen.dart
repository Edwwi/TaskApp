import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/task_card.dart';
import 'create_task_screen.dart';
import '../theme/app_theme.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final provider = context.watch<TaskProvider>();
    
    // Find the start of the week (Monday)
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () {}),
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('MMMM d, yyyy', provider.language == 'es' ? 'es_ES' : 'en_US').format(now),
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CreateTaskScreen()),
                    );
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(provider.translate('create_task')),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (idx) {
                final dayDate = startOfWeek.add(Duration(days: idx));
                final dayName = DateFormat('E', provider.language == 'es' ? 'es_ES' : 'en_US').format(dayDate);
                final dayNum = dayDate.day;
                bool isSelected = dayDate.day == now.day && dayDate.month == now.month;

                return Column(
                  children: [
                    Text(dayName, style: TextStyle(color: isSelected ? AppTheme.primaryBlue : Colors.grey)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.primaryBlue.withValues(alpha: 0.1) : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: isSelected ? Border.all(color: AppTheme.primaryBlue) : null,
                      ),
                      child: Text(
                        '$dayNum',
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? AppTheme.primaryBlue : (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    provider.translate('my_tasks'),
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Consumer<TaskProvider>(
                      builder: (context, provider, child) {
                        final dailyTasks = provider.tasks.where((t) => 
                          t.dueDate.day == now.day && 
                          t.dueDate.month == now.month && 
                          t.dueDate.year == now.year
                        ).toList();

                        if (dailyTasks.isEmpty) {
                          return Center(child: Text(provider.translate('no_tasks')));
                        }

                        return ListView.builder(
                          itemCount: dailyTasks.length,
                          itemBuilder: (context, index) {
                            return TaskCard(task: dailyTasks[index]);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
