import 'package:flutter/material.dart';
import 'package:parallel_universe/features/universe_generation/domain/entities/generated_universe_entity.dart';
import 'package:parallel_universe/features/universe_generation/domain/repositories/i_universe_repository.dart';

class TravelHistoryViewModel extends ChangeNotifier {
  final IUniverseRepository _repository;

  TravelHistoryViewModel(this._repository);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<GeneratedUniverseEntity> _history = [];
  List<GeneratedUniverseEntity> get history => _history;

  Future<void> fetchHistory() async {
    _isLoading = true;
    notifyListeners();

    try {
      _history = await _repository.getHistory();
    } catch (e) {
      debugPrint('Failed to load history: $e');
      _history = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
