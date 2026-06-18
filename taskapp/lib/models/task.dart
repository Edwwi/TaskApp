import 'package:uuid/uuid.dart';

// Cambiamos 'const' por 'final' para evitar problemas de inicialización
final uuid = const Uuid(); 

class Task {
// ... resto de tu código
  final String id;
  String title;
  String description;
  String category;
  String priority;
  DateTime deadline;
  bool isCompleted;

  Task({
    String? id,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.deadline,
    this.isCompleted = false,
  }) : id = id ?? uuid.v4();
}