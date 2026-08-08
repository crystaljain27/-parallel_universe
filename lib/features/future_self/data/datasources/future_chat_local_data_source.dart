import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:parallel_universe/features/future_self/domain/entities/future_message_entity.dart';

class FutureChatLocalDataSource {
  final SharedPreferences _prefs;

  FutureChatLocalDataSource(this._prefs);

  String _getKey(String universeId) => 'future_chat_$universeId';

  Future<List<FutureMessageEntity>> getChatHistory(String universeId) async {
    try {
      final jsonString = _prefs.getString(_getKey(universeId));
      if (jsonString != null) {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        return jsonList.map((e) => FutureMessageEntity(
          id: e['id'],
          text: e['text'],
          isUser: e['isUser'],
          timestamp: DateTime.parse(e['timestamp']),
        )).toList();
      }
    } catch (e) {
      debugPrint("Error loading chat history from local storage: $e");
    }
    return [];
  }

  Future<void> saveMessage(String universeId, FutureMessageEntity message) async {
    try {
      final history = await getChatHistory(universeId);
      
      // Update if exists, otherwise add
      final index = history.indexWhere((m) => m.id == message.id);
      if (index != -1) {
        history[index] = message;
      } else {
        history.add(message);
      }

      final jsonList = history.map((e) => {
        'id': e.id,
        'text': e.text,
        'isUser': e.isUser,
        'timestamp': e.timestamp.toIso8601String(),
      }).toList();

      await _prefs.setString(_getKey(universeId), jsonEncode(jsonList));
    } catch (e) {
      debugPrint("Error saving message to local storage: $e");
    }
  }
}
