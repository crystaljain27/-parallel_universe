import 'package:flutter/material.dart';
import 'package:parallel_universe/features/universe_generation/domain/entities/generated_universe_entity.dart';
import 'package:parallel_universe/features/universe_generation/domain/repositories/i_universe_repository.dart';
import 'package:parallel_universe/features/life_interview/domain/repositories/i_life_interview_repository.dart';

class UniverseGenerationViewModel extends ChangeNotifier {
  final IUniverseRepository _repository;
  final ILifeInterviewRepository _lifeInterviewRepository;

  UniverseGenerationViewModel(this._repository, this._lifeInterviewRepository);

  bool _isGenerating = false;
  bool get isGenerating => _isGenerating;

  List<GeneratedUniverseEntity> _universes = [];
  List<GeneratedUniverseEntity> get universes => _universes;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> generate(String chatSessionId) async {
    _isGenerating = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final memory = await _lifeInterviewRepository.getSavedMemory();
      _universes = await _repository.generateUniverses(chatSessionId, memory: memory);
      
      // Save newly generated universes to local storage
      for (final universe in _universes) {
        await _repository.saveUniverse(universe);
      }
      
      _isGenerating = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isGenerating = false;
      notifyListeners();
      return false;
    }
  }
}
