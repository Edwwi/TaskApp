import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/task_card.dart';
import 'create_task_screen.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();
    
    // Find the start of the week (Monday) based on selected date
    final startOfWeek = _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), 
          onPressed: () => Navigator.pop(context),
        ),
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('MMMM yyyy', provider.language == 'es' ? 'es_ES' : 'en_US').format(_selectedDate),
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    Text(
                      DateFormat('EEEE d', provider.language == 'es' ? 'es_ES' : 'en_US').format(_selectedDate),
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
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
                    backgroundColor: Theme.of(context).colorScheme.primary,
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
                bool isSelected = dayDate.day == _selectedDate.day && 
                                  dayDate.month == _selectedDate.month &&
                                  dayDate.year == _selectedDate.year;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDate = dayDate;
                    });
                  },
                  child: Column(
                    children: [
                      Text(dayName, style: TextStyle(color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1) : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          border: isSelected ? Border.all(color: Theme.of(context).colorScheme.primary) : null,
                        ),
                        child: Text(
                          '$dayNum',
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? Theme.of(context).colorScheme.primary : (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
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
                          t.dueDate.day == _selectedDate.day && 
                          t.dueDate.month == _selectedDate.month && 
                          t.dueDate.year == _selectedDate.year
                        ).toList();

                        if (dailyTasks.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.calendar_today_outlined, size: 64, color: Colors.grey.withValues(alpha: 0.3)),
                                const SizedBox(height: 16),
                                Text(
                                  provider.translate('no_tasks'),
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          );
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
