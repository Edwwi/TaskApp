import 'package:flutter/material.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1115),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('MODELO DE NEGOCIO', style: TextStyle(fontSize: 12, letterSpacing: 1.5, color: Colors.greenAccent)),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                'PRECIOS PROPUESTOS',
                style: TextStyle(color: Colors.orange.shade300, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Gratis para empezar. Pro para crecer.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 48),
            
            // FREE Plan
            _buildPlanCard(
              context: context,
              title: 'FREE',
              price: 'DOP\$0 / mes',
              color: Colors.blueAccent,
              features: [
                'Gestión básica',
                'Categorías y prioridades',
                'Calendario · Sincronización',
                'Accesibilidad · OCR básico',
              ],
            ),
            const SizedBox(height: 24),

            // PRO Plan
            _buildPlanCard(
              context: context,
              title: 'PRO',
              price: 'DOP\$650 / mes',
              color: Colors.greenAccent,
              isPopular: true,
              features: [
                'Todo FREE · IA avanzada',
                'Escaneo ilimitado',
                'Automatización · Analíticas',
                'Personalización avanzada',
              ],
            ),
            const SizedBox(height: 24),

            // TEAMS Plan
            _buildPlanCard(
              context: context,
              title: 'TEAMS',
              price: 'DOP\$800 / usuario / mes',
              color: Colors.orangeAccent,
              features: [
                'Colaboración · Equipos',
                'Panel administrativo',
                'Analíticas de equipo',
                'Integraciones corporativas',
              ],
            ),
            const SizedBox(height: 48),

            const Row(
              children: [
                Text('Adopción', style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
                Text(' → ', style: TextStyle(color: Colors.white24)),
                Text('Conversión', style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
                Text(' → ', style: TextStyle(color: Colors.white24)),
                Text('Escala', style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 32),
            const Divider(color: Colors.white12),
            const SizedBox(height: 16),
            const Row(
              children: [
                Text('06 / 08  CHECK-IT · NEGOCIO', style: TextStyle(color: Colors.white38, fontSize: 10, letterSpacing: 1.2)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard({
    required BuildContext context,
    required String title,
    required String price,
    required Color color,
    required List<String> features,
    bool isPopular = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D23),
        borderRadius: BorderRadius.circular(4),
        border: Border(top: BorderSide(color: color, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.2),
          ),
          const SizedBox(height: 16),
          Text(
            price,
            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          ...features.map((f) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              f,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          )),
        ],
      ),
    );
  }
}
