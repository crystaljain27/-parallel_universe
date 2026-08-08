import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:parallel_universe/features/universe_generation/domain/entities/generated_universe_entity.dart';

abstract class IUniverseLocalDataSource {
  Future<void> saveUniverse(GeneratedUniverseEntity universe);
  Future<List<GeneratedUniverseEntity>> getHistory();
}

class UniverseLocalDataSourceImpl implements IUniverseLocalDataSource {
  final SharedPreferences _prefs;
  static const String _historyKey = 'universe_history';

  UniverseLocalDataSourceImpl(this._prefs);

  @override
  Future<void> saveUniverse(GeneratedUniverseEntity universe) async {
    final history = await getHistory();
    // Add the new universe at the beginning of the list
    history.insert(0, universe);
    
    final jsonList = history.map((e) => jsonEncode(e.toJson())).toList();
    await _prefs.setStringList(_historyKey, jsonList);
  }

  @override
  Future<List<GeneratedUniverseEntity>> getHistory() async {
    final jsonList = _prefs.getStringList(_historyKey);
    if (jsonList == null) return [];

    try {
      return jsonList
          .map((jsonStr) => GeneratedUniverseEntity.fromJson(jsonDecode(jsonStr)))
          .toList();
    } catch (e) {
      // In case of parsing errors
      return [];
    }
  }
}
