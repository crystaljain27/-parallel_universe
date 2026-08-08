import 'dart:io';
import 'dart:convert';

void main() async {
  final apiKey = 'AQ.Ab8RN6JyMd3-jUbFZqR43bWqytV3YHFwxQmBWsid050iZpGD9Q';
  
  final client = HttpClient();
  try {
    final request = await client.getUrl(Uri.parse('https://generativelanguage.googleapis.com/v1beta/models?key=$apiKey'));
    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();
    
    print('Response status: ${response.statusCode}');
    print('Response body: $responseBody');
  } catch(e) {
    print('Error: $e');
  } finally {
    client.close();
  }
}
