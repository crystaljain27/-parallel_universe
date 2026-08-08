import 'package:parallel_universe/features/future_self/domain/repositories/i_future_chat_repository.dart';
import 'package:parallel_universe/features/future_self/data/datasources/future_chat_remote_data_source.dart';
import 'package:parallel_universe/features/future_self/data/datasources/future_chat_local_data_source.dart';
import 'package:parallel_universe/features/future_self/domain/entities/future_message_entity.dart';

import 'package:parallel_universe/features/life_interview/domain/entities/smart_memory_entity.dart';

class FutureChatRepositoryImpl implements IFutureChatRepository {
  final FutureChatRemoteDataSource _remoteDataSource;
  final FutureChatLocalDataSource _localDataSource;

  FutureChatRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<String> getIntroMessage(String universeId, String universeName) {
    return _remoteDataSource.getIntroMessage(universeId, universeName);
  }

  @override
  Stream<String> sendMessageStream(String universeId, String universeName, String message, List<FutureMessageEntity> history, {SmartMemoryEntity? memory}) {
    return _remoteDataSource.sendMessageStream(universeId, universeName, message, history, memory: memory);
  }

  @override
  Future<List<FutureMessageEntity>> getChatHistory(String universeId) async {
    return await _localDataSource.getChatHistory(universeId);
  }

  @override
  Future<void> saveMessage(String universeId, FutureMessageEntity message) async {
    await _localDataSource.saveMessage(universeId, message);
  }
}
