import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:parallel_universe/features/chat/domain/entities/chat_message_entity.dart';
import 'package:parallel_universe/features/life_interview/domain/entities/smart_memory_entity.dart';

class LifeInterviewRemoteDataSource {
  
  Stream<String> streamInterviewResponse(String message, List<ChatMessageEntity> history) async* {
    final apiKey = dotenv.env['GROQ_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      yield "Error: API Key missing.";
      return;
    }

    final systemPrompt = """
You are a highly empathetic and perceptive AI Career & Life Coach.
Your goal is to conduct a natural conversational interview to understand the user's current life, skills, goals, strengths, weaknesses, and lifestyle preferences.
DO NOT ask a long list of questions at once. Ask exactly ONE or TWO questions at a time.
Acknowledge their previous answer naturally before asking the next question.
Keep the conversation engaging and fluid.
Examples of what you want to discover: Current Job, Salary, Experience, City, Dream Company, Long-term goal, Strengths, Weaknesses, Preferred lifestyle, Financial goals.
If they say they are unemployed, ask what role they are preparing for instead of asking their current company.
""";

    final messages = [
      {'role': 'system', 'content': systemPrompt},
    ];

    for (var msg in history) {
      if (msg.text.isNotEmpty) {
        messages.add({
          'role': msg.isUser ? 'user' : 'assistant',
          'content': msg.text,
        });
      }
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
        yield "Error: ${response.statusCode}";
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
              // ignore
            }
          }
        }
      }
    } catch (e) {
      yield "Error connecting to AI Coach.";
    } finally {
      client.close();
    }
  }

  Future<SmartMemoryEntity?> extractMemory(List<ChatMessageEntity> transcript) async {
    final apiKey = dotenv.env['GROQ_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) return null;

    final transcriptText = transcript.map((m) => "${m.isUser ? 'User' : 'Coach'}: ${m.text}").join("\n");

    final systemPrompt = """
You are an AI data extractor. Read the following interview transcript and extract the user's details into a strict JSON format.
If a detail is not mentioned, set it to null.
JSON structure must exactly match:
{
  "currentJob": "...",
  "currentSalary": "...",
  "experience": "...",
  "skills": "...",
  "dreamCompany": "...",
  "weaknesses": "...",
  "strengths": "...",
  "careerGoals": "...",
  "personalGoals": "...",
  "lifestylePreferences": "...",
  "interests": "..."
}
Output ONLY the JSON object. No markdown formatting, no backticks, no other text.
""";

    try {
      final response = await http.post(
        Uri.parse('https://api.groq.com/openai/v1/chat/completions'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'llama-3.1-8b-instant',
          'messages': [
            {'role': 'system', 'content': systemPrompt},
            {'role': 'user', 'content': "Transcript:\n$transcriptText"}
          ],
          'temperature': 0.1,
          'response_format': { "type": "json_object" }
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final content = jsonResponse['choices'][0]['message']['content'];
        final parsed = jsonDecode(content);
        
        return SmartMemoryEntity(
          currentJob: parsed['currentJob'],
          currentSalary: parsed['currentSalary'],
          experience: parsed['experience'],
          skills: parsed['skills'],
          dreamCompany: parsed['dreamCompany'],
          weaknesses: parsed['weaknesses'],
          strengths: parsed['strengths'],
          careerGoals: parsed['careerGoals'],
          personalGoals: parsed['personalGoals'],
          lifestylePreferences: parsed['lifestylePreferences'],
          interests: parsed['interests'],
          rawInterviewTranscript: transcriptText,
        );
      }
    } catch (e) {
      debugPrint("Memory extraction error: $e");
    }
    return null;
  }
}
