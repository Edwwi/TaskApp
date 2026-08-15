import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../services/auth_service.dart';
import 'subscription_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();
    final authService = AuthService();

    return Scaffold(
      appBar: AppBar(
        title: Text(provider.translate('profile')),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Theme.of(context).colorScheme.primary,
              backgroundImage: const AssetImage('assets/images/app_logo.png'),
            ),
            const SizedBox(height: 16),
            Text(
              provider.userName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            
            // Preferences Section
            _buildSectionHeader(context, provider.translate('preferences')),
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
            _buildSectionHeader(context, provider.translate('stats')),
            _buildStatsGrid(provider),

            const SizedBox(height: 24),
            
            // Subscription Section
            Card(
              child: ListTile(
                leading: const Icon(Icons.star, color: Colors.amber),
                title: const Text('Planes de Suscripción'),
                subtitle: const Text('Ver modelos de negocio'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SubscriptionScreen()),
                  );
                },
              ),
            ),

            const SizedBox(height: 32),
            
            // Logout Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => authService.signOut(),
                icon: const Icon(Icons.logout),
                label: Text(provider.translate('logout')),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
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
