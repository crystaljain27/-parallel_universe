class SmartMemoryEntity {
  final String? currentJob;
  final String? currentSalary;
  final String? experience;
  final String? skills;
  final String? dreamCompany;
  final String? weaknesses;
  final String? strengths;
  final String? careerGoals;
  final String? personalGoals;
  final String? lifestylePreferences;
  final String? interests;
  final String rawInterviewTranscript;

  SmartMemoryEntity({
    this.currentJob,
    this.currentSalary,
    this.experience,
    this.skills,
    this.dreamCompany,
    this.weaknesses,
    this.strengths,
    this.careerGoals,
    this.personalGoals,
    this.lifestylePreferences,
    this.interests,
    required this.rawInterviewTranscript,
  });

  Map<String, dynamic> toJson() {
    return {
      'currentJob': currentJob,
      'currentSalary': currentSalary,
      'experience': experience,
      'skills': skills,
      'dreamCompany': dreamCompany,
      'weaknesses': weaknesses,
      'strengths': strengths,
      'careerGoals': careerGoals,
      'personalGoals': personalGoals,
      'lifestylePreferences': lifestylePreferences,
      'interests': interests,
      'rawInterviewTranscript': rawInterviewTranscript,
    };
  }

  factory SmartMemoryEntity.fromJson(Map<String, dynamic> json) {
    return SmartMemoryEntity(
      currentJob: json['currentJob'],
      currentSalary: json['currentSalary'],
      experience: json['experience'],
      skills: json['skills'],
      dreamCompany: json['dreamCompany'],
      weaknesses: json['weaknesses'],
      strengths: json['strengths'],
      careerGoals: json['careerGoals'],
      personalGoals: json['personalGoals'],
      lifestylePreferences: json['lifestylePreferences'],
      interests: json['interests'],
      rawInterviewTranscript: json['rawInterviewTranscript'] ?? '',
    );
  }

  bool get isEmpty {
    return currentJob == null &&
           currentSalary == null &&
           experience == null &&
           dreamCompany == null &&
           careerGoals == null;
  }
}
