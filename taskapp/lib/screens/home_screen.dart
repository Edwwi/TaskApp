import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/task_card.dart';
import '../widgets/category_chip.dart';
import '../widgets/ui_state_widgets.dart';
import 'create_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SearchController _searchController = SearchController();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Check-IT', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        actions: [
          SearchAnchor(
            searchController: _searchController,
            builder: (context, controller) {
              return IconButton(
                icon: const Icon(Icons.search),
                onPressed: () => controller.openView(),
              );
            },
            suggestionsBuilder: (context, controller) {
              final query = controller.text.toLowerCase();
              final filtered = provider.tasks.where((t) => t.title.toLowerCase().contains(query)).toList();
              return filtered.map((task) => ListTile(
                    title: Text(task.title),
                    onTap: () {
                      controller.closeView(task.title);
                      // Navegar a detalles si fuera necesario
                    },
                  ));
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Simular carga
          await Future.delayed(const Duration(seconds: 1));
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${provider.translate('welcome')} ${provider.userName}!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                provider.translate('tasks_today').replaceFirst('{count}', provider.tasks.length.toString()),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.outline),
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
                SizedBox(
                  height: 300,
                  child: EmptyState(
                    message: provider.translate('no_tasks'),
                    actionLabel: provider.translate('save'),
                    onAction: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CreateTaskScreen()),
                    ),
                  ),
                )
              else
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Column(
                    key: ValueKey(provider.selectedFilterIndex),
                    children: [
                      SizedBox(
                        height: 210,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: provider.filteredTasks.length,
                          itemBuilder: (context, index) {
                            return TaskCard(task: provider.filteredTasks[index], isHorizontal: true);
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            provider.translate('progress'),
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          TextButton(onPressed: () {}, child: const Text('Ver todo')),
                        ],
                      ),
                      const SizedBox(height: 16),
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
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CreateTaskScreen()),
        ),
        label: Text(provider.translate('save')),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
