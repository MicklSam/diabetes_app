import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class GeminiService {
  static final Gemini _gemini =
      Gemini.init(apiKey: 'AIzaSyBMKKrS6QVW1ClTrnmHFNvrpy_fLtDf7YA');

  static Future<String?> sendQuery({
    required List<Map<String, dynamic>> data,
    required String userQuery,
    String? systemContext,
    String? responseFormat,
  }) async {
    try {
      final prompt = _buildSystemPrompt(
        items: data,
        contextDescription: systemContext,
        responseInstructions: responseFormat,
      );

      final response = await _gemini.prompt(
        parts: [Part.text(prompt), Part.text(userQuery)],
      );
      debugPrint(response?.output);

      return response?.output;
    } catch (e) {
      debugPrint('Gemini Error: \${e.toString()}');
      return null;
    }
  }

  static String _buildSystemPrompt({
    required List<Map<String, dynamic>> items,
    String? contextDescription,
    String? responseInstructions,
  }) {
    final buffer = StringBuffer();

    buffer.write(contextDescription ?? 'Analyze this data:\n');

    for (final item in items) {
      item.forEach((key, value) {
        if (value is List) {
          for (int i = 0; i < value.length; i++) {
            buffer.write('• ${key.toUpperCase()}_${i + 1}: ${value[i]}\n');
          }
        } else {
          buffer.write('• ${key.toUpperCase()}: $value\n');
        }
      });
    }

    buffer.write(responseInstructions ?? '\nRespond helpfully.');
    return buffer.toString();
  }
}
