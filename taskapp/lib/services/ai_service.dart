import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AIService {
  // TODO: Reemplazar con tu API Key real de Google AI Studio
  static const String _apiKey = 'TU_API_KEY_AQUI';
  
  final GenerativeModel _model;

  AIService() : _model = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: _apiKey,
  );

  Future<Map<String, dynamic>?> suggestFields(String text) async {
    if (_apiKey == 'TU_API_KEY_AQUI') return null;

    final prompt = '''
Analiza el siguiente texto y extrae la información necesaria para crear una tarea. 
Devuelve la respuesta EXCLUSIVAMENTE en formato JSON plano, sin bloques de código ni texto adicional.

Texto: "$text"

El JSON debe tener exactamente estas llaves:
- "title": un título corto y conciso (máximo 30 caracteres).
- "description": una descripción más detallada basada en el texto.
- "category": debe ser exactamente uno de estos valores: design, meeting, coding, work, personal, study.
- "priority": debe ser exactamente uno de estos valores: high, medium, low.
- "dueDate": una fecha estimada en formato ISO 8601 (YYYY-MM-DD). Si no se menciona fecha, usa la fecha de hoy: ${DateTime.now().toIso8601String().split('T')[0]}.

Ejemplo de respuesta:
{"title": "Comprar leche", "description": "Ir al supermercado", "category": "personal", "priority": "low", "dueDate": "2024-08-15"}
''';

    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      
      final cleanJson = response.text?.replaceAll('```json', '').replaceAll('```', '').trim();
      if (cleanJson == null) return null;

      return jsonDecode(cleanJson) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('Error en Gemini AI: \$e');
      return null;
    }
  }
}
