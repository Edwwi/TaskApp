import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/task_card.dart';
import '../widgets/category_chip.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hola Usuario!',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            Consumer<TaskProvider>(
              builder: (context, provider, child) {
                return Text(
                  'Tienes ${provider.tasks.length} tareas hoy',
                  style: const TextStyle(color: Colors.grey),
                );
              },
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                CategoryChip(label: 'Mis tareas', isSelected: true, onTap: () {}),
                CategoryChip(label: 'En progreso', isSelected: false, onTap: () {}),
                CategoryChip(label: 'Completadas', isSelected: false, onTap: () {}),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: Consumer<TaskProvider>(
                builder: (context, provider, child) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: provider.tasks.length,
                    itemBuilder: (context, index) {
                      return TaskCard(task: provider.tasks[index], isHorizontal: true);
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(3, (index) => Container(
                  width: index == 0 ? 16 : 8,
                  height: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: index == 0 ? Colors.purple : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                )),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Progress',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Consumer<TaskProvider>(
              builder: (context, provider, child) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.tasks.length,
                  itemBuilder: (context, index) {
                    return TaskCard(task: provider.tasks[index]);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
