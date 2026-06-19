import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task_model.dart';
import '../theme/app_theme.dart';
import '../widgets/category_chip.dart';
import 'package:intl/intl.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  TaskCategory _category = TaskCategory.design;
  DateTime _selectedDate = DateTime(2026, 6, 2);
  TimeOfDay _startTime = const TimeOfDay(hour: 13, minute: 22);
  TimeOfDay _endTime = const TimeOfDay(hour: 15, minute: 20);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Crear una Tarea', style: TextStyle(color: Colors.white)),
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Nombre', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  TextFormField(
                    initialValue: 'Ingresa un nombre',
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                    ),
                    onSaved: (value) => _title = value ?? '',
                  ),
                  const SizedBox(height: 24),
                  const Text('Fecha', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 8),
                  Text(
                    DateFormat('MMM d, yyyy').format(_selectedDate),
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Divider(color: Colors.white30, height: 24),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Start Time', style: TextStyle(color: Colors.grey)),
                              const SizedBox(height: 8),
                              Text(_startTime.format(context), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('End Time', style: TextStyle(color: Colors.grey)),
                              const SizedBox(height: 8),
                              Text(_endTime.format(context), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text('Description', style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 8),
                    TextFormField(
                      initialValue: 'Lorem ipsum dolor sit amet, adipiscing elit, sed dianummy nibh euismod dolor sit amet, or adipiscing elit, sed dianummy nibh euismod.',
                      maxLines: 4,
                      decoration: const InputDecoration(border: InputBorder.none),
                      onSaved: (value) => _description = value ?? '',
                    ),
                    const SizedBox(height: 24),
                    const Text('Categoría', style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: TaskCategory.values.take(6).map((cat) {
                        return CategoryChip(
                          label: cat.name[0].toUpperCase() + cat.name.substring(1),
                          isSelected: _category == cat,
                          onTap: () => setState(() => _category = cat),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          _formKey.currentState?.save();
                          final newTask = Task(
                            id: DateTime.now().toString(),
                            title: _title,
                            description: _description,
                            category: _category,
                            priority: TaskPriority.medium,
                            dueDate: _selectedDate,
                            startTime: _startTime,
                            endTime: _endTime,
                          );
                          context.read<TaskProvider>().addTask(newTask);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryBlue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Text('Create Task', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
