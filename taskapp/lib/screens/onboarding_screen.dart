import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../main.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() => isLastPage = index == 2);
            },
            children: [
              _buildPage(
                color: Theme.of(context).colorScheme.primaryContainer,
                title: 'Organiza tu Vida',
                description: 'Gestiona tus tareas diarias de forma sencilla y eficiente con Check-IT.',
                icon: Icons.task_alt,
              ),
              _buildPage(
                color: Theme.of(context).colorScheme.secondaryContainer,
                title: 'No Olvides Nada',
                description: 'Configura recordatorios y mantente al tanto de tus plazos importantes.',
                icon: Icons.notifications_active,
              ),
              _buildPage(
                color: Theme.of(context).colorScheme.tertiaryContainer,
                title: 'Analiza tu Progreso',
                description: 'Visualiza tus logros y mejora tu productividad cada día.',
                icon: Icons.analytics,
              ),
            ],
          ),
          Container(
            alignment: const Alignment(0, 0.8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => _controller.jumpToPage(2),
                  child: const Text('SALTAR'),
                ),
                SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  effect: WormEffect(
                    dotColor: Colors.black26,
                    activeDotColor: Theme.of(context).colorScheme.primary,
                  ),
                  onDotClicked: (index) => _controller.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeIn,
                  ),
                ),
                isLastPage
                    ? TextButton(
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setBool('showHome', true);
                          if (mounted) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const MainNavigation()),
                            );
                          }
                        },
                        child: const Text('COMENZAR'),
                      )
                    : TextButton(
                        onPressed: () => _controller.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        ),
                        child: const Text('SIGUIENTE'),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage({
    required Color color,
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Container(
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 100, color: Theme.of(context).colorScheme.onPrimaryContainer),
          const SizedBox(height: 64),
          Text(
            title,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
