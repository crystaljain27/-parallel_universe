import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:parallel_universe/features/life_interview/domain/entities/smart_memory_entity.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class UniverseRemoteDataSource {
  Future<List<Map<String, dynamic>>> generateUniverses(String chatSessionId, {SmartMemoryEntity? memory}) async {
    final apiKey = dotenv.env['GROQ_API_KEY'];
    
    final isWhatIf = chatSessionId != 'default' && chatSessionId != 'act as a career simulation';
    final scenarioText = isWhatIf ? chatSessionId : null;

    // Fallback to mock data if no API key is provided
    if (apiKey == null || apiKey.isEmpty) {
      await Future.delayed(const Duration(seconds: 4));
      return _getMockUniverses(scenario: scenarioText);
    }

    final promptScenarioText = isWhatIf 
        ? "The user has specifically requested a 'What If' scenario: '$chatSessionId'. You MUST generate 3 distinct parallel universes that explore this exact choice."
        : "Based on the user's current life profile, generate 3 distinct parallel universes (alternative future careers/paths) the user could take.";

    final systemPrompt = """
You are an advanced Parallel Universe Generator. $promptScenarioText
Vary the difficulty levels (e.g., one safe/easy, one medium, one extreme/moonshot).

Output ONLY a JSON object containing an array of exactly 3 universes under the key "universes".
Do NOT output any markdown, only valid JSON.

JSON Schema for each universe:
{
  "name": "string (e.g. Startup Founder, AI Researcher)",
  "coverImage": "string (A valid unsplash image URL like 'https://images.unsplash.com/photo-1555949963-aa79dcee981c?auto=format&fit=crop&w=800&q=80')",
  "summary": "string (1-2 sentences)",
  "confidenceScore": number (0-100),
  "difficultyLevel": "string (Easy, Medium, Hard, Extreme)",
  "estimatedTimeline": "string (e.g. 2 Years, 6 Months)",
  "requiredSkills": ["string", "string"],
  "keyMilestones": [
    {"title": "string", "description": "string", "year": "string"}
  ],
  "salaryProgression": [number, number, number, number],
  "pros": ["string"],
  "cons": ["string"],
  "dailyRoutine": "string",
  "aiRecommendation": "string"
}
""";

    final userProfile = memory != null ? """
Current Job: ${memory.currentJob ?? 'Unknown'}
Experience: ${memory.experience ?? 'Unknown'}
Skills: ${memory.skills ?? 'Unknown'}
Strengths: ${memory.strengths ?? 'Unknown'}
Weaknesses: ${memory.weaknesses ?? 'Unknown'}
Career Goals: ${memory.careerGoals ?? 'Unknown'}
Interests: ${memory.interests ?? 'Unknown'}
""" : "Profile: Unknown (The user wants to explore without providing a baseline profile)";

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
            {'role': 'user', 'content': userProfile}
          ],
          'temperature': 0.7,
          'response_format': { "type": "json_object" }
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final content = jsonResponse['choices'][0]['message']['content'];
        final parsed = jsonDecode(content);
        
        if (parsed['universes'] != null && parsed['universes'] is List) {
          final List universesList = parsed['universes'];
          return universesList.map((u) {
            final map = Map<String, dynamic>.from(u);
            map['id'] = const Uuid().v4();
            
            map['coverImage'] = _getRelatedImageUrl(map['name'] ?? '');
            
            return map;
          }).toList();
        }
      }
    } catch (e) {
      debugPrint("Error generating universes from Groq: \$e");
    }

    // Fallback if API fails
    return _getMockUniverses(scenario: scenarioText);
  }

  String _getRelatedImageUrl(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('chef') || lower.contains('food') || lower.contains('cook') || lower.contains('culinary') || lower.contains('kitchen') || lower.contains('line cook')) {
      return 'https://images.pexels.com/photos/1267320/pexels-photo-1267320.jpeg?auto=compress&cs=tinysrgb&w=800';
    } else if (lower.contains('tech') || lower.contains('software') || lower.contains('developer') || lower.contains('ai') || lower.contains('data') || lower.contains('engineer')) {
      return 'https://images.pexels.com/photos/1181675/pexels-photo-1181675.jpeg?auto=compress&cs=tinysrgb&w=800';
    } else if (lower.contains('art') || lower.contains('design') || lower.contains('creator') || lower.contains('writer')) {
      return 'https://images.pexels.com/photos/102127/pexels-photo-102127.jpeg?auto=compress&cs=tinysrgb&w=800';
    } else if (lower.contains('business') || lower.contains('startup') || lower.contains('founder') || lower.contains('ceo') || lower.contains('manager')) {
      return 'https://images.pexels.com/photos/3183150/pexels-photo-3183150.jpeg?auto=compress&cs=tinysrgb&w=800';
    } else if (lower.contains('sport') || lower.contains('athlete') || lower.contains('fitness') || lower.contains('basketball') || lower.contains('tennis') || lower.contains('football')) {
      return 'https://images.pexels.com/photos/1552242/pexels-photo-1552242.jpeg?auto=compress&cs=tinysrgb&w=800';
    } else if (lower.contains('science') || lower.contains('research') || lower.contains('doctor') || lower.contains('medical') || lower.contains('health')) {
      return 'https://images.pexels.com/photos/2280571/pexels-photo-2280571.jpeg?auto=compress&cs=tinysrgb&w=800';
    } else if (lower.contains('music') || lower.contains('singer') || lower.contains('guitar') || lower.contains('audio')) {
      return 'https://images.pexels.com/photos/164821/pexels-photo-164821.jpeg?auto=compress&cs=tinysrgb&w=800';
    } else if (lower.contains('space') || lower.contains('astronaut') || lower.contains('star')) {
      return 'https://images.pexels.com/photos/2156/sky-space-telescope-universe.jpg?auto=compress&cs=tinysrgb&w=800';
    } else if (lower.contains('travel') || lower.contains('pilot') || lower.contains('flight')) {
      return 'https://images.pexels.com/photos/2007401/pexels-photo-2007401.jpeg?auto=compress&cs=tinysrgb&w=800';
    } else if (lower.contains('car') || lower.contains('driver') || lower.contains('racing') || lower.contains('mechanic')) {
      return 'https://images.pexels.com/photos/120049/pexels-photo-120049.jpeg?auto=compress&cs=tinysrgb&w=800';
    } else {
      return 'https://images.pexels.com/photos/3184291/pexels-photo-3184291.jpeg?auto=compress&cs=tinysrgb&w=800';
    }
  }

  List<Map<String, dynamic>> _getMockUniverses({String? scenario}) {
    final title1 = scenario != null ? 'Safe: $scenario' : 'Google Software Engineer';
    final title2 = scenario != null ? 'Risky: $scenario' : 'Startup Founder';
    final title3 = scenario != null ? 'Extreme: $scenario' : 'AI Researcher';

    return [
      {
        'id': const Uuid().v4(),
        'name': title1,
        'coverImage': 'https://images.unsplash.com/photo-1573164713988-8665fc963095?auto=format&fit=crop&w=800&q=80',
        'summary': 'Join the Mountain View giant to work on planetary-scale systems.',
        'confidenceScore': 92,
        'difficultyLevel': 'Hard',
        'estimatedTimeline': '1-2 Years',
        'requiredSkills': ['Algorithms', 'Distributed Systems', 'System Design'],
        'keyMilestones': [
          {'title': 'Pass Interviews', 'description': 'Complete 5 rounds of rigorous technical interviews.', 'year': 'Year 1'},
          {'title': 'L4 Promotion', 'description': 'Demonstrate independence and system-level thinking.', 'year': 'Year 3'},
          {'title': 'Tech Lead', 'description': 'Lead a small team on a critical infrastructure project.', 'year': 'Year 5'},
        ],
        'salaryProgression': [150000, 200000, 300000, 450000],
        'pros': ['High compensation', 'Great perks', 'Smart colleagues'],
        'cons': ['Bureaucracy', 'Slow promotions', 'High stress'],
        'dailyRoutine': 'Morning standups, deep work coding sessions, design document reviews, and free lunches.',
        'aiRecommendation': 'Focus heavily on LeetCode Medium/Hard and mock system design interviews.',
      },
      {
        'id': const Uuid().v4(),
        'name': title2,
        'coverImage': 'https://images.unsplash.com/photo-1556761175-5973dc0f32d7?auto=format&fit=crop&w=800&q=80',
        'summary': 'Build your own venture backed by Y Combinator.',
        'confidenceScore': 75,
        'difficultyLevel': 'Extreme',
        'estimatedTimeline': '6 Months',
        'requiredSkills': ['Product Management', 'Sales', 'Full-stack Dev', 'Resilience'],
        'keyMilestones': [
          {'title': 'MVP Launch', 'description': 'Launch the first version of the product to early adopters.', 'year': 'Month 3'},
          {'title': 'Seed Round', 'description': 'Raise \$1.5M from top tier angels and VCs.', 'year': 'Year 1'},
          {'title': 'Series A', 'description': 'Reach \$1M ARR and raise a \$10M Series A.', 'year': 'Year 3'},
        ],
        'salaryProgression': [50000, 80000, 120000, 250000],
        'pros': ['Unlimited upside', 'Total autonomy', 'Rapid learning'],
        'cons': ['High risk of failure', 'No work-life balance', 'High stress'],
        'dailyRoutine': 'Constantly switching context between coding, talking to users, pitching investors, and putting out fires.',
        'aiRecommendation': 'Start talking to users immediately to validate the problem before writing any code.',
      },
      {
        'id': const Uuid().v4(),
        'name': title3,
        'coverImage': 'https://images.unsplash.com/photo-1620712943543-bcc4688e7485?auto=format&fit=crop&w=800&q=80',
        'summary': 'Push the boundaries of AGI at DeepMind or OpenAI.',
        'confidenceScore': 85,
        'difficultyLevel': 'Very Hard',
        'estimatedTimeline': '2-3 Years',
        'requiredSkills': ['Machine Learning', 'PyTorch', 'Linear Algebra', 'Paper Reading'],
        'keyMilestones': [
          {'title': 'Publish at NeurIPS', 'description': 'Get your first paper accepted at a major conference.', 'year': 'Year 1'},
          {'title': 'Research Scientist', 'description': 'Transition from an applied role to a core research role.', 'year': 'Year 2'},
          {'title': 'Lead a Breakthrough', 'description': 'Author a seminal paper that introduces a novel architecture.', 'year': 'Year 4'},
        ],
        'salaryProgression': [180000, 250000, 400000, 600000],
        'pros': ['Cutting edge work', 'High impact', 'Excellent compensation'],
        'cons': ['Intense competition', 'Publish or perish pressure', 'Requires heavy math background'],
        'dailyRoutine': 'Reading ArXiv papers, running experiments on compute clusters, and collaborating with top minds.',
        'aiRecommendation': 'Strengthen your math fundamentals and start reproducing recent papers from scratch.',
      }
    ];
  }
}
