class ActiveFutureEntity {
  final String id;
  final String name;
  final String coverImage;
  final double progressPercentage;
  final String currentPosition;
  final String estimatedSalary;
  final String lastConversation;
  final String nextMilestone;
  final double confidenceScore;

  ActiveFutureEntity({
    required this.id,
    required this.name,
    required this.coverImage,
    required this.progressPercentage,
    required this.currentPosition,
    required this.estimatedSalary,
    required this.lastConversation,
    required this.nextMilestone,
    required this.confidenceScore,
  });
}
