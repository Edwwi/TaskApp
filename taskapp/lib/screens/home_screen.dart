import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/task_card.dart';
import '../widgets/category_chip.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();

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
            Text(
              '${provider.translate('welcome')} ${provider.userName}!',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            Text(
              provider.translate('tasks_today').replaceFirst('{count}', provider.tasks.length.toString()),
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  CategoryChip(
                    label: provider.translate('my_tasks'),
                    isSelected: provider.selectedFilterIndex == 0,
                    onTap: () => provider.setFilterIndex(0),
                  ),
                  CategoryChip(
                    label: provider.translate('in_progress'),
                    isSelected: provider.selectedFilterIndex == 1,
                    onTap: () => provider.setFilterIndex(1),
                  ),
                  CategoryChip(
                    label: provider.translate('completed'),
                    isSelected: provider.selectedFilterIndex == 2,
                    onTap: () => provider.setFilterIndex(2),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            if (provider.filteredTasks.isEmpty)
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.assignment_outlined, size: 48, color: Colors.grey.shade300),
                      const SizedBox(height: 12),
                      Text(provider.translate('no_tasks'), style: TextStyle(color: Colors.grey.shade400)),
                    ],
                  ),
                ),
              )
            else
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: provider.filteredTasks.length,
                  itemBuilder: (context, index) {
                    return TaskCard(task: provider.filteredTasks[index], isHorizontal: true);
                  },
                ),
              ),
            
            const SizedBox(height: 24),
            Text(
              provider.translate('progress'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            if (provider.filteredTasks.isEmpty)
              const SizedBox()
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: provider.filteredTasks.length,
                itemBuilder: (context, index) {
                  return TaskCard(task: provider.filteredTasks[index]);
                },
              ),
          ],
        ),
      ),
    );
  }
}
