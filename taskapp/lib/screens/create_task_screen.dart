import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task_model.dart';
import '../widgets/category_chip.dart';
import '../services/ai_service.dart';
import 'package:intl/intl.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _aiService = AIService();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  bool _isAILoading = false;

  Future<void> _getAISuggestions() async {
    final text = _titleController.text;
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escribe un título para obtener sugerencias')),
      );
      return;
    }

    setState(() => _isAILoading = true);
    final suggestions = await _aiService.suggestFields(text);
    setState(() => _isAILoading = false);

    if (suggestions != null && mounted) {
      setState(() {
        _titleController.text = suggestions['title'] ?? _titleController.text;
        _descriptionController.text = suggestions['description'] ?? _descriptionController.text;
        _category = TaskCategory.values.byName(suggestions['category'] ?? 'personal');
        _priority = TaskPriority.values.byName(suggestions['priority'] ?? 'medium');
        _selectedDate = DateTime.parse(suggestions['dueDate'] ?? DateTime.now().toIso8601String());
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('IA ha optimizado tu tarea ✨')),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
  
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
      appBar: AppBar(
        title: Text(provider.translate('create_task')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  hintText: provider.translate('name'),
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5)),
                  suffixIcon: _isAILoading 
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : IconButton(
                        icon: const Icon(Icons.auto_awesome, color: Colors.amber),
                        onPressed: _getAISuggestions,
                        tooltip: 'Mejorar con IA',
                      ),
                ),
                validator: (value) => (value == null || value.isEmpty) ? 'Campo requerido' : null,
              ),
              const Divider(),
              const SizedBox(height: 24),
              
              _buildSectionTitle(provider.translate('date')),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_today_outlined),
                title: Text(DateFormat('EEEE, d MMMM, yyyy').format(_selectedDate)),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now().subtract(const Duration(days: 365)),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null) setState(() => _selectedDate = picked);
                },
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle(provider.translate('start_time')),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.access_time),
                          title: Text(_startTime.format(context)),
                          onTap: () async {
                            final picked = await showTimePicker(context: context, initialTime: _startTime);
                            if (picked != null) setState(() => _startTime = picked);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle(provider.translate('end_time')),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.access_time_filled),
                          title: Text(_endTime.format(context)),
                          onTap: () async {
                            final picked = await showTimePicker(context: context, initialTime: _endTime);
                            if (picked != null) setState(() => _endTime = picked);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              _buildSectionTitle(provider.translate('priority')),
              const SizedBox(height: 12),
              SegmentedButton<TaskPriority>(
                segments: TaskPriority.values.map((p) => ButtonSegment(
                  value: p,
                  label: Text(provider.translate(p.name)),
                )).toList(),
                selected: {_priority},
                onSelectionChanged: (val) => setState(() => _priority = val.first),
              ),
              const SizedBox(height: 24),

              _buildSectionTitle(provider.translate('category')),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: TaskCategory.values.map((cat) {
                  return CategoryChip(
                    label: cat.name[0].toUpperCase() + cat.name.substring(1),
                    isSelected: _category == cat,
                    onTap: () => setState(() => _category = cat),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              _buildSectionTitle(provider.translate('description')),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Escribe algo sobre la tarea...',
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      _formKey.currentState?.save();
                      final newTask = Task(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        title: _titleController.text,
                        description: _descriptionController.text,
                        category: _category,
                        priority: _priority,
                        dueDate: _selectedDate,
                        startTime: _startTime,
                        endTime: _endTime,
                        reminderMinutes: _reminderMinutes,
                      );
                      context.read<TaskProvider>().addTask(newTask);
                      Navigator.pop(context);
                    }
                  },
                  child: Text(provider.translate('save'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
    );
  }
}
