import 'package:parallel_universe/features/universe_generation/domain/entities/generated_universe_entity.dart';
import 'package:parallel_universe/features/life_interview/domain/entities/smart_memory_entity.dart';

abstract class IUniverseRepository {
  Future<List<GeneratedUniverseEntity>> generateUniverses(String chatSessionId, {SmartMemoryEntity? memory});
  Future<void> saveUniverse(GeneratedUniverseEntity universe);
  Future<List<GeneratedUniverseEntity>> getHistory();
}
