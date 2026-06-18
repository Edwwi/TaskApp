import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

class CreateTaskScreen extends StatefulWidget {
  final Task? taskToEdit;

  const CreateTaskScreen({super.key, this.taskToEdit});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late String _category;
  late String _priority;
  late DateTime _deadline;

  @override
  void initState() {
    super.initState();
    if (widget.taskToEdit != null) {
      _title = widget.taskToEdit!.title;
      _description = widget.taskToEdit!.description;
      _category = widget.taskToEdit!.category;
      _priority = widget.taskToEdit!.priority;
      _deadline = widget.taskToEdit!.deadline;
    } else {
      _title = '';
      _description = '';
      _category = 'Trabajo';
      _priority = 'Media';
      _deadline = DateTime.now().add(const Duration(days: 1));
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _deadline,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _deadline) {
      setState(() {
        _deadline = picked;
      });
    }
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newTask = Task(
        id: widget.taskToEdit?.id,
        title: _title,
        description: _description,
        category: _category,
        priority: _priority,
        deadline: _deadline,
        isCompleted: widget.taskToEdit?.isCompleted ?? false,
      );

      if (widget.taskToEdit != null) {
        context.read<TaskProvider>().updateTask(widget.taskToEdit!.id, newTask);
      } else {
        context.read<TaskProvider>().addTask(newTask);
      }
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.taskToEdit != null;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Tarea' : 'Crear una Tarea'),
        backgroundColor: const Color(0xFF2962FF),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'El nombre es requerido' : null,
                onSaved: (value) => _title = value!,
              ),
              const SizedBox(height: 15),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                onSaved: (value) => _description = value ?? '',
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(
                  labelText: 'Categoría',
                  border: OutlineInputBorder(),
                ),
                items: ['Trabajo', 'Personal', 'Estudio', 'Urgente']
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (val) => setState(() => _category = val!),
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: _priority,
                decoration: const InputDecoration(
                  labelText: 'Prioridad',
                  border: OutlineInputBorder(),
                ),
                items: ['Alta', 'Media', 'Baja']
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged: (val) => setState(() => _priority = val!),
              ),
              const SizedBox(height: 15),
              OutlinedButton.icon(
                onPressed: () => _selectDate(context),
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  'Fecha límite: ${_deadline.day}/${_deadline.month}/${_deadline.year}',
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2962FF),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: _saveTask,
                child: Text(
                  isEditing ? 'Actualizar Tarea' : 'Crear Tarea',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}