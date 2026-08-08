import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:parallel_universe/features/future_self/domain/entities/future_message_entity.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:parallel_universe/features/life_interview/domain/entities/smart_memory_entity.dart';

class FutureChatRemoteDataSource {
  Future<String> getIntroMessage(String universeId, String universeName) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return "Hi. I'm you, five years from now.\n\nI successfully became a $universeName.\n\nEverything I know comes only from this timeline. Ask me anything.";
  }

  Stream<String> sendMessageStream(String universeId, String universeName, String message, List<FutureMessageEntity> history, {SmartMemoryEntity? memory}) async* {
    final apiKey = dotenv.env['GROQ_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      yield "\n[Error: GROQ_API_KEY is not configured in the .env file. Please add your key to proceed.]";
      return;
    }

    final contextHistory = history.where((msg) => msg.text.isNotEmpty).toList();
    
    String userContext = "";
    if (memory != null) {
      userContext = "\nMy Past Background (5 years ago):"
          "\nJob: ${memory.currentJob ?? 'Unknown'}"
          "\nSkills: ${memory.skills ?? 'Unknown'}"
          "\nStrengths: ${memory.strengths ?? 'Unknown'}"
          "\nWeaknesses: ${memory.weaknesses ?? 'Unknown'}";
    }
    
    final systemPrompt = "You are my future self from a timeline where I became successful as a $universeName. "
        "Speak directly to me as if you are literally me 5 years in the future. "
        "You remember your past (which is my present). $userContext"
        "\nKeep your tone conversational and natural. "
        "Act as an interactive Decision Simulator: when I ask for advice, sometimes present me with difficult career or life choices you had to make, and ask what I would do before telling me what you did."
        "\nIf I just say 'hi', greet me back normally before diving into deep advice.";

    final messages = [
      {'role': 'system', 'content': systemPrompt},
    ];

    for (var msg in contextHistory) {
      messages.add({
        'role': msg.isUser ? 'user' : 'assistant',
        'content': msg.text,
      });
    }

    messages.add({
      'role': 'user',
      'content': message,
    });

    final request = http.Request('POST', Uri.parse('https://api.groq.com/openai/v1/chat/completions'));
    request.headers['Authorization'] = 'Bearer $apiKey';
    request.headers['Content-Type'] = 'application/json';
    request.body = jsonEncode({
      'model': 'llama-3.1-8b-instant',
      'messages': messages,
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
        yield "\n[Error connecting to my timeline: $errorStr]";
      }
    } finally {
      client.close();
    }
  }
}
