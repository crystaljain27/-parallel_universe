import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatRemoteDataSource {
  Future<List<Map<String, dynamic>>> getChatSessions() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      {
        'id': '1',
        'title': 'How to build a Flutter app?',
        'lastMessage': 'Flutter is a great framework...',
        'timestamp': DateTime.now().subtract(const Duration(hours: 1)),
      },
      {
        'id': '2',
        'title': 'Quantum Physics explained',
        'lastMessage': 'It involves superpositions.',
        'timestamp': DateTime.now().subtract(const Duration(days: 1)),
      },
    ];
  }

  Future<List<Map<String, dynamic>>> getChatHistory(String sessionId) async {
    await Future.delayed(const Duration(seconds: 1));
    if (sessionId == '1') {
      return [
        {'id': 'msg1', 'text': 'How to build a Flutter app?', 'isUser': true, 'timestamp': DateTime.now().subtract(const Duration(hours: 1, minutes: 5))},
        {'id': 'msg2', 'text': 'Flutter is a great framework for cross-platform development.\n\n```dart\nvoid main() {\n  runApp(MyApp());\n}\n```', 'isUser': false, 'timestamp': DateTime.now().subtract(const Duration(hours: 1))},
      ];
    }
    return [];
  }

  Stream<String> sendMessageStream(String sessionId, String message) async* {
    final apiKey = dotenv.env['GROQ_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      yield "\n[Error: GROQ_API_KEY is missing from .env file.]";
      return;
    }

    final request = http.Request('POST', Uri.parse('https://api.groq.com/openai/v1/chat/completions'));
    request.headers['Authorization'] = 'Bearer $apiKey';
    request.headers['Content-Type'] = 'application/json';
    request.body = jsonEncode({
      'model': 'llama-3.1-8b-instant',
      'messages': [
        {'role': 'user', 'content': message}
      ],
      'stream': true,
    });

    final client = http.Client();
    try {
      final response = await client.send(request);

      if (response.statusCode != 200) {
        final error = await response.stream.bytesToString();
        yield "\n[Error from Groq: ${response.statusCode} $error]";
        return;
      }

      await for (final chunk in response.stream.transform(utf8.decoder)) {
        final lines = chunk.split('\n');
        for (final line in lines) {
          if (line.startsWith('data: ') && line != 'data: [DONE]') {
            final data = line.substring(6);
            if (data.trim().isEmpty) continue;
            try {
              final json = jsonDecode(data);
              if (json['choices'] != null && json['choices'].isNotEmpty) {
                final content = json['choices'][0]['delta']['content'];
                if (content != null) {
                  yield content;
                }
              }
            } catch (e) {
              // Ignore partial JSON parsing errors which can happen in chunked streaming
            }
          }
        }
      }
    } catch (e) {
      final errorStr = e.toString();
      if (errorStr.contains('ClientException') || errorStr.contains('Failed to fetch') || errorStr.contains('SocketException')) {
        yield "\nNo internet connection. Please check your network and try again.";
      } else {
        yield "\n[Error: $errorStr]";
      }
    } finally {
      client.close();
    }
  }
}
