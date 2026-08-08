class WeeklyReportEntity {
  final List<String> exploredFutures;
  final String aiObservation;
  final String suggestedNextFuture;
  final double successProbability;
  final String recommendedSkill;

  WeeklyReportEntity({
    required this.exploredFutures,
    required this.aiObservation,
    required this.suggestedNextFuture,
    required this.successProbability,
    required this.recommendedSkill,
  });
}
