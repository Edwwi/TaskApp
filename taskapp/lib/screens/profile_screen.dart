import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(provider.translate('profile')),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: AppTheme.primaryBlue,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              provider.userName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            
            // Preferences Section
            _buildSectionHeader(provider.translate('preferences')),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.language),
                    title: Text(provider.translate('language')),
                    subtitle: Text(provider.language == 'es' ? 'Español' : 'English'),
                    trailing: Switch(
                      value: provider.language == 'en',
                      onChanged: (val) => provider.setLanguage(val ? 'en' : 'es'),
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(provider.isDarkMode ? Icons.dark_mode : Icons.light_mode),
                    title: Text(provider.translate('dark_mode')),
                    trailing: Switch(
                      value: provider.isDarkMode,
                      onChanged: (val) => provider.toggleDarkMode(val),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Statistics Section
            _buildSectionHeader(provider.translate('stats')),
            _buildStatsGrid(provider),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
        ),
      ),
    );
  }

  Widget _buildStatsGrid(TaskProvider provider) {
    final total = provider.tasks.length;
    final completed = provider.tasks.where((t) => t.isCompleted).length;
    final pending = total - completed;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 0.8,
      children: [
        _buildStatItem(provider.translate('total'), total.toString(), Colors.blue),
        _buildStatItem(provider.translate('completed'), completed.toString(), Colors.green),
        _buildStatItem(provider.translate('pending'), pending.toString(), Colors.orange),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
