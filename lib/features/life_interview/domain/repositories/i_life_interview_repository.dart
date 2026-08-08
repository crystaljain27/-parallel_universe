import 'package:parallel_universe/features/chat/domain/entities/chat_message_entity.dart';
import 'package:parallel_universe/features/life_interview/domain/entities/smart_memory_entity.dart';

abstract class ILifeInterviewRepository {
  Stream<String> streamInterviewResponse(String message, List<ChatMessageEntity> history);
  Future<SmartMemoryEntity?> extractAndSaveMemory(List<ChatMessageEntity> transcript);
  Future<SmartMemoryEntity?> getSavedMemory();
  Future<void> clearMemory();
}
