import 'package:parallel_universe/features/chat/domain/entities/chat_message_entity.dart';
import 'package:parallel_universe/features/chat/domain/entities/chat_session_entity.dart';

abstract class IChatRepository {
  Future<List<ChatSessionEntity>> getChatSessions();
  Future<List<ChatMessageEntity>> getChatHistory(String sessionId);
  Stream<String> sendMessageStream(String sessionId, String message);
}
