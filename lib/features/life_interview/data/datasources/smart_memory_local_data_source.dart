import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:parallel_universe/features/life_interview/domain/entities/smart_memory_entity.dart';

class SmartMemoryLocalDataSource {
  final SharedPreferences _prefs;
  static const String _memoryKey = 'smart_memory';

  SmartMemoryLocalDataSource(this._prefs);

  Future<void> saveMemory(SmartMemoryEntity memory) async {
    final jsonString = jsonEncode(memory.toJson());
    await _prefs.setString(_memoryKey, jsonString);
  }

  Future<SmartMemoryEntity?> getMemory() async {
    final jsonString = _prefs.getString(_memoryKey);
    if (jsonString != null) {
      try {
        final jsonMap = jsonDecode(jsonString);
        return SmartMemoryEntity.fromJson(jsonMap);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Future<void> clearMemory() async {
    await _prefs.remove(_memoryKey);
  }
}
