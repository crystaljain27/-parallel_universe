class ChatSessionEntity {
  final String id;
  final String title;
  final String lastMessage;
  final DateTime timestamp;

  ChatSessionEntity({
    required this.id,
    required this.title,
    required this.lastMessage,
    required this.timestamp,
  });
}
