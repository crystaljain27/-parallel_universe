class RecommendedFutureEntity {
  final String id;
  final String name;
  final String coverImage;
  final String shortStory;
  final double matchPercentage;
  final String estimatedSalary;
  final String difficulty;
  final String growthPotential;
  final List<String> whyRecommended;

  RecommendedFutureEntity({
    required this.id,
    required this.name,
    required this.coverImage,
    required this.shortStory,
    required this.matchPercentage,
    required this.estimatedSalary,
    required this.difficulty,
    required this.growthPotential,
    required this.whyRecommended,
  });
}
