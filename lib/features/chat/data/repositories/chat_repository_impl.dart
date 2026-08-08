import 'package:parallel_universe/features/chat/domain/entities/chat_message_entity.dart';
import 'package:parallel_universe/features/chat/domain/entities/chat_session_entity.dart';
import 'package:parallel_universe/features/chat/domain/repositories/i_chat_repository.dart';
import 'package:parallel_universe/features/chat/data/datasources/chat_remote_data_source.dart';

class ChatRepositoryImpl implements IChatRepository {
  final ChatRemoteDataSource _remoteDataSource;

  ChatRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<ChatSessionEntity>> getChatSessions() async {
    final data = await _remoteDataSource.getChatSessions();
    return data.map((e) => ChatSessionEntity(
      id: e['id'],
      title: e['title'],
      lastMessage: e['lastMessage'],
      timestamp: e['timestamp'] as DateTime,
    )).toList();
  }

  @override
  Future<List<ChatMessageEntity>> getChatHistory(String sessionId) async {
    final data = await _remoteDataSource.getChatHistory(sessionId);
    return data.map((e) => ChatMessageEntity(
      id: e['id'],
      text: e['text'],
      isUser: e['isUser'],
      timestamp: e['timestamp'] as DateTime,
    )).toList();
  }

  @override
  Stream<String> sendMessageStream(String sessionId, String message) {
    return _remoteDataSource.sendMessageStream(sessionId, message);
  }
}
