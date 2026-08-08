import 'package:parallel_universe/features/universe_generation/domain/entities/generated_universe_entity.dart';
import 'package:parallel_universe/features/universe_generation/domain/repositories/i_universe_repository.dart';
import 'package:parallel_universe/features/universe_generation/data/datasources/universe_remote_data_source.dart';
import 'package:parallel_universe/features/universe_generation/data/datasources/universe_local_data_source.dart';
import 'package:parallel_universe/features/life_interview/domain/entities/smart_memory_entity.dart';

class UniverseRepositoryImpl implements IUniverseRepository {
  final UniverseRemoteDataSource _remoteDataSource;
  final IUniverseLocalDataSource _localDataSource;

  UniverseRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<List<GeneratedUniverseEntity>> generateUniverses(String chatSessionId, {SmartMemoryEntity? memory}) async {
    final data = await _remoteDataSource.generateUniverses(chatSessionId, memory: memory);
    return data.map((e) => GeneratedUniverseEntity(
      id: e['id'],
      name: e['name'],
      coverImage: e['coverImage'],
      summary: e['summary'],
      confidenceScore: e['confidenceScore'],
      difficultyLevel: e['difficultyLevel'],
      estimatedTimeline: e['estimatedTimeline'],
      requiredSkills: List<String>.from(e['requiredSkills']),
      keyMilestones: (e['keyMilestones'] as List).map((m) => Milestone(
        title: m['title'],
        description: m['description'],
        year: m['year'],
      )).toList(),
      salaryProgression: List<int>.from(e['salaryProgression']),
      pros: List<String>.from(e['pros']),
      cons: List<String>.from(e['cons']),
      dailyRoutine: e['dailyRoutine'],
      aiRecommendation: e['aiRecommendation'],
      createdAt: DateTime.now(), // set creation time when generated
    )).toList();
  }

  @override
  Future<void> saveUniverse(GeneratedUniverseEntity universe) async {
    await _localDataSource.saveUniverse(universe);
  }

  @override
  Future<List<GeneratedUniverseEntity>> getHistory() async {
    return await _localDataSource.getHistory();
  }
}
