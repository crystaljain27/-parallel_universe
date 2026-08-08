class Milestone {
  final String title;
  final String description;
  final String year;

  Milestone({required this.title, required this.description, required this.year});

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'year': year,
    };
  }

  factory Milestone.fromJson(Map<String, dynamic> json) {
    return Milestone(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      year: json['year'] ?? '',
    );
  }
}

class GeneratedUniverseEntity {
  final String id;
  final String name;
  final String coverImage;
  final String summary;
  final int confidenceScore;
  final String difficultyLevel;
  final String estimatedTimeline;
  final List<String> requiredSkills;
  final List<Milestone> keyMilestones;
  final List<int> salaryProgression; // e.g. [80000, 100000, 150000, 200000]
  final List<String> pros;
  final List<String> cons;
  final String dailyRoutine;
  final String aiRecommendation;
  final DateTime? createdAt;

  GeneratedUniverseEntity({
    required this.id,
    required this.name,
    required this.coverImage,
    required this.summary,
    required this.confidenceScore,
    required this.difficultyLevel,
    required this.estimatedTimeline,
    required this.requiredSkills,
    required this.keyMilestones,
    required this.salaryProgression,
    required this.pros,
    required this.cons,
    required this.dailyRoutine,
    required this.aiRecommendation,
    this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'coverImage': coverImage,
      'summary': summary,
      'confidenceScore': confidenceScore,
      'difficultyLevel': difficultyLevel,
      'estimatedTimeline': estimatedTimeline,
      'requiredSkills': requiredSkills,
      'keyMilestones': keyMilestones.map((m) => m.toJson()).toList(),
      'salaryProgression': salaryProgression,
      'pros': pros,
      'cons': cons,
      'dailyRoutine': dailyRoutine,
      'aiRecommendation': aiRecommendation,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory GeneratedUniverseEntity.fromJson(Map<String, dynamic> json) {
    return GeneratedUniverseEntity(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      coverImage: json['coverImage'] ?? '',
      summary: json['summary'] ?? '',
      confidenceScore: json['confidenceScore'] ?? 0,
      difficultyLevel: json['difficultyLevel'] ?? '',
      estimatedTimeline: json['estimatedTimeline'] ?? '',
      requiredSkills: List<String>.from(json['requiredSkills'] ?? []),
      keyMilestones: (json['keyMilestones'] as List<dynamic>?)
              ?.map((m) => Milestone.fromJson(m))
              .toList() ??
          [],
      salaryProgression: List<int>.from(json['salaryProgression'] ?? []),
      pros: List<String>.from(json['pros'] ?? []),
      cons: List<String>.from(json['cons'] ?? []),
      dailyRoutine: json['dailyRoutine'] ?? '',
      aiRecommendation: json['aiRecommendation'] ?? '',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }
}
