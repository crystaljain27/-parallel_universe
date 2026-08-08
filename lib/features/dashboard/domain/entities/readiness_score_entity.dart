class ReadinessScoreEntity {
  final double overallScore;
  final Map<String, double> skills; // e.g., {'Backend': 92, 'System Design': 78}

  ReadinessScoreEntity({
    required this.overallScore,
    required this.skills,
  });
}
