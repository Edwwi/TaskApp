import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _selectedDate;
  late DateTime _displayedMonth;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _displayedMonth = DateTime(_selectedDate.year, _selectedDate.month, 1);
  }

  void _previousMonth() {
    setState(() {
      _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1);
    });
  }

  List<Task> _getTasksForDate(DateTime date, List<Task> allTasks) {
    return allTasks.where((task) {
      return task.deadline.year == date.year &&
          task.deadline.month == date.month &&
          task.deadline.day == date.day;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Calendario de Tareas'),
        backgroundColor: const Color(0xFF2962FF),
        foregroundColor: Colors.white,
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, _) {
          final allTasks = taskProvider.allTasks;
          final daysInMonth =
              DateTime(_displayedMonth.year, _displayedMonth.month + 1, 0).day;
          final firstDayOfMonth =
              DateTime(_displayedMonth.year, _displayedMonth.month, 1).weekday;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header con navegación de meses
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed: _previousMonth,
                      ),
                      Text(
                        '${_getMonthName(_displayedMonth.month)} ${_displayedMonth.year}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: _nextMonth,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Calendario
                  Card(
                    elevation: 0,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // Días de la semana
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: ['L', 'M', 'X', 'J', 'V', 'S', 'D']
                                .map((day) => Expanded(
                                      child: Center(
                                        child: Text(
                                          day,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                          const Divider(),

                          // Días del mes
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 7,
                              childAspectRatio: 1.2,
                            ),
                            itemCount: firstDayOfMonth + daysInMonth - 1,
                            itemBuilder: (context, index) {
                              if (index < firstDayOfMonth - 1) {
                                return const SizedBox();
                              }

                              final day = index - firstDayOfMonth + 2;
                              final date = DateTime(
                                _displayedMonth.year,
                                _displayedMonth.month,
                                day,
                              );
                              final tasksForDay = _getTasksForDate(date, allTasks);
                              final isSelected = _selectedDate.year == date.year &&
                                  _selectedDate.month == date.month &&
                                  _selectedDate.day == date.day;
                              final isToday = DateTime.now().year == date.year &&
                                  DateTime.now().month == date.month &&
                                  DateTime.now().day == date.day;

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedDate = date;
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFF2962FF)
                                        : isToday
                                            ? Colors.blue[100]
                                            : Colors.white,
                                    border: Border.all(
                                      color: isToday ? Colors.blue : Colors.grey[300]!,
                                      width: isToday ? 2 : 0.5,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '$day',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: isSelected
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                          if (tasksForDay.isNotEmpty)
                                            Container(
                                              width: 4,
                                              height: 4,
                                              margin: const EdgeInsets.only(top: 2),
                                              decoration: BoxDecoration(
                                                color: isSelected
                                                    ? Colors.white
                                                    : const Color(0xFF2962FF),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Tareas del día seleccionado
                  Text(
                    'Tareas del ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (_getTasksForDate(_selectedDate, allTasks).isEmpty)
                    Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Text(
                            'No hay tareas para este día',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                      ),
                    )
                  else
                    ..._getTasksForDate(_selectedDate, allTasks)
                        .map((task) => _buildTaskCard(task, taskProvider))
                        .toList(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTaskCard(Task task, TaskProvider taskProvider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      color: Colors.white,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getPriorityColor(task.priority),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getCategoryIcon(task.category),
            color: Colors.white,
          ),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration:
                task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
          ),
        ),
        subtitle: Text(task.category),
        trailing: Checkbox(
          value: task.isCompleted,
          onChanged: (_) => taskProvider.toggleTaskStatus(task.id),
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre'
    ];
    return months[month - 1];
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'trabajo':
        return Icons.work;
      case 'personal':
        return Icons.person;
      case 'estudio':
        return Icons.school;
      case 'urgente':
        return Icons.priority_high;
      default:
        return Icons.assignment;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'alta':
        return Colors.red;
      case 'media':
        return Colors.orange;
      case 'baja':
        return Colors.green;
      default:
        return Colors.blue;
    }
  }
}
