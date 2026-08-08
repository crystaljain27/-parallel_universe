import 'dart:io';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  final apiKey = dotenv.env['GEMINI_API_KEY'];
  
  final client = HttpClient();
  try {
    final request = await client.getUrl(Uri.parse('https://generativelanguage.googleapis.com/v1beta/models?key=$apiKey'));
    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();
    
    File('models_output.json').writeAsStringSync(responseBody);
    print('Wrote models to models_output.json');
  } catch(e) {
    print('Error: $e');
  } finally {
    client.close();
  }
}
