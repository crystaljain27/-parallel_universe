class FutureMessageEntity {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;

  FutureMessageEntity({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}
