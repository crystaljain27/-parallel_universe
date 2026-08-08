import 'package:parallel_universe/features/chat/domain/entities/chat_message_entity.dart';
import 'package:parallel_universe/features/life_interview/domain/entities/smart_memory_entity.dart';
import 'package:parallel_universe/features/life_interview/domain/repositories/i_life_interview_repository.dart';
import 'package:parallel_universe/features/life_interview/data/datasources/life_interview_remote_data_source.dart';
import 'package:parallel_universe/features/life_interview/data/datasources/smart_memory_local_data_source.dart';

class LifeInterviewRepositoryImpl implements ILifeInterviewRepository {
  final LifeInterviewRemoteDataSource _remoteDataSource;
  final SmartMemoryLocalDataSource _localDataSource;

  LifeInterviewRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Stream<String> streamInterviewResponse(String message, List<ChatMessageEntity> history) {
    return _remoteDataSource.streamInterviewResponse(message, history);
  }

  @override
  Future<SmartMemoryEntity?> extractAndSaveMemory(List<ChatMessageEntity> transcript) async {
    final memory = await _remoteDataSource.extractMemory(transcript);
    if (memory != null) {
      await _localDataSource.saveMemory(memory);
    }
    return memory;
  }

  @override
  Future<SmartMemoryEntity?> getSavedMemory() async {
    return await _localDataSource.getMemory();
  }

  @override
  Future<void> clearMemory() async {
    await _localDataSource.clearMemory();
  }
}
