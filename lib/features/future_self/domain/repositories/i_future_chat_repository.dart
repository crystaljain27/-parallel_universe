import 'package:parallel_universe/features/future_self/domain/entities/future_message_entity.dart';
import 'package:parallel_universe/features/life_interview/domain/entities/smart_memory_entity.dart';

abstract class IFutureChatRepository {
  Future<String> getIntroMessage(String universeId, String universeName);
  Stream<String> sendMessageStream(String universeId, String universeName, String message, List<FutureMessageEntity> history, {SmartMemoryEntity? memory});
  
  Future<List<FutureMessageEntity>> getChatHistory(String universeId);
  Future<void> saveMessage(String universeId, FutureMessageEntity message);
}
