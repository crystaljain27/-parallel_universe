import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  final apiKey = dotenv.env['GEMINI_API_KEY'];
  if (apiKey == null) {
    print('No API key');
    return;
  }
  
  final models = ['gemini-1.5-flash-latest', 'gemini-1.5-flash', 'gemini-pro', 'gemini-1.0-pro'];
  for (var m in models) {
    print('Testing model: $m');
    try {
      final model = GenerativeModel(model: m, apiKey: apiKey);
      final response = await model.generateContent([Content.text('Say hello')]);
      print('Success for $m: ${response.text}');
    } catch (e) {
      print('Error for $m: $e');
    }
  }
}
