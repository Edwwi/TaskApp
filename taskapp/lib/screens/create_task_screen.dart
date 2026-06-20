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
  TaskPriority _priority = TaskPriority.medium;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.fromDateTime(DateTime.now().add(const Duration(hours: 1)));
  int _reminderMinutes = 15;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();

    return Scaffold(
      backgroundColor: AppTheme.primaryBlue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(provider.translate('create_task'), style: const TextStyle(color: Colors.white)),
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
                  Text(provider.translate('name'), style: const TextStyle(color: Colors.white70, fontSize: 14)),
                  TextFormField(
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                    ),
                    onSaved: (value) => _title = value ?? '',
                  ),
                  const SizedBox(height: 24),
                  Text(provider.translate('date'), style: const TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime.now().subtract(const Duration(days: 365)),
                        lastDate: DateTime(2030),
                      );
                      if (picked != null) setState(() => _selectedDate = picked);
                    },
                    child: Text(
                      DateFormat('MMM d, yyyy').format(_selectedDate),
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
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
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
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
                              Text(provider.translate('start_time'), style: const TextStyle(color: Colors.grey)),
                              const SizedBox(height: 8),
                              InkWell(
                                onTap: () async {
                                  final picked = await showTimePicker(context: context, initialTime: _startTime);
                                  if (picked != null) setState(() => _startTime = picked);
                                },
                                child: Text(_startTime.format(context), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(provider.translate('end_time'), style: const TextStyle(color: Colors.grey)),
                              const SizedBox(height: 8),
                              InkWell(
                                onTap: () async {
                                  final picked = await showTimePicker(context: context, initialTime: _endTime);
                                  if (picked != null) setState(() => _endTime = picked);
                                },
                                child: Text(_endTime.format(context), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    Text(provider.translate('priority'), style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: TaskPriority.values.map((p) {
                        bool isSelected = _priority == p;
                        Color pColor = p == TaskPriority.high ? Colors.red : p == TaskPriority.medium ? Colors.orange : Colors.green;
                        return ChoiceChip(
                          label: Text(provider.translate(p.name)),
                          selected: isSelected,
                          onSelected: (val) => setState(() => _priority = p),
                          selectedColor: pColor.withOpacity(0.2),
                          labelStyle: TextStyle(color: isSelected ? pColor : Colors.grey),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    Text(provider.translate('reminder'), style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      value: _reminderMinutes,
                      decoration: const InputDecoration(border: OutlineInputBorder()),
                      items: [
                        DropdownMenuItem(value: 0, child: Text(provider.translate('none'))),
                        DropdownMenuItem(value: 5, child: Text(provider.translate('min_5'))),
                        DropdownMenuItem(value: 15, child: Text(provider.translate('min_15'))),
                        DropdownMenuItem(value: 30, child: Text(provider.translate('min_30'))),
                        DropdownMenuItem(value: 60, child: Text(provider.translate('hour_1'))),
                      ],
                      onChanged: (val) => setState(() => _reminderMinutes = val ?? 0),
                    ),
                    const SizedBox(height: 24),

                    Text(provider.translate('description'), style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 8),
                    TextFormField(
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: provider.translate('description'),
                        border: InputBorder.none,
                      ),
                      onSaved: (value) => _description = value ?? '',
                    ),
                    const SizedBox(height: 24),
                    Text(provider.translate('category'), style: const TextStyle(color: Colors.grey)),
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
                          if (_title.isEmpty) return;
                          
                          final newTask = Task(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            title: _title,
                            description: _description,
                            category: _category,
                            priority: _priority,
                            dueDate: _selectedDate,
                            startTime: _startTime,
                            endTime: _endTime,
                            reminderMinutes: _reminderMinutes,
                          );
                          context.read<TaskProvider>().addTask(newTask);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryBlue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Text(provider.translate('save'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
