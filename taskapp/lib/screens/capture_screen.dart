import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CaptureScreen extends StatelessWidget {
  const CaptureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () {}),
        title: const Text('Capturar', style: TextStyle(color: Colors.white)),
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppTheme.primaryBlue, AppTheme.secondaryBlue],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.mic_none, size: 100, color: Colors.white30),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.2),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text('Empieza a grabar'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              color: Colors.white,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: -50,
                    left: -20,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: AppTheme.blueGradient.gradient,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: const Icon(Icons.camera_alt, size: 60, color: Colors.white),
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryBlue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        child: const Text('Escaneer o tomar una foto'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
