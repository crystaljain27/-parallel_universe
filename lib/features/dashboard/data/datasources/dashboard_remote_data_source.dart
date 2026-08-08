import 'package:parallel_universe/features/dashboard/domain/entities/active_future_entity.dart';
import 'package:parallel_universe/features/dashboard/domain/entities/recommended_future_entity.dart';
import 'package:parallel_universe/features/dashboard/domain/entities/future_insight_entity.dart';
import 'package:parallel_universe/features/dashboard/domain/entities/readiness_score_entity.dart';
import 'package:parallel_universe/features/dashboard/domain/entities/weekly_report_entity.dart';
import 'package:parallel_universe/features/dashboard/domain/entities/achievement_entity.dart';
import 'package:parallel_universe/features/dashboard/domain/entities/what_if_scenario_entity.dart';
import 'package:parallel_universe/features/dashboard/domain/entities/trending_future_entity.dart';

class DashboardRemoteDataSource {
  Future<List<ActiveFutureEntity>> getFeed() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      ActiveFutureEntity(
        id: '1',
        name: 'Google Software Engineer',
        coverImage: 'https://images.unsplash.com/photo-1573164713988-8665fc963095?auto=format&fit=crop&w=800&q=80',
        progressPercentage: 0.72,
        currentPosition: 'Senior Software Engineer',
        estimatedSalary: '₹82 LPA',
        lastConversation: 'Yesterday',
        nextMilestone: 'Engineering Manager',
        confidenceScore: 0.92,
      ),
      ActiveFutureEntity(
        id: '2',
        name: 'AI Startup Founder',
        coverImage: 'https://images.unsplash.com/photo-1556761175-5973dc0f32e7?auto=format&fit=crop&w=800&q=80',
        progressPercentage: 0.45,
        currentPosition: 'Pre-Seed Stage',
        estimatedSalary: 'Equity Focus',
        lastConversation: '2 days ago',
        nextMilestone: 'Series A Funding',
        confidenceScore: 0.65,
      ),
    ];
  }

  Future<List<RecommendedFutureEntity>> getExploreUniverses() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      RecommendedFutureEntity(
        id: '3',
        name: 'OpenAI Research Engineer',
        coverImage: 'https://images.unsplash.com/photo-1620712943543-bcc4688e7485?auto=format&fit=crop&w=800&q=80',
        shortStory: 'Join the team building the next generation of AGI.',
        matchPercentage: 0.91,
        estimatedSalary: '\$350,000/yr',
        difficulty: 'Extreme',
        growthPotential: 'Exponential',
        whyRecommended: ['AI', 'Python', 'Math', 'Innovation'],
      ),
      RecommendedFutureEntity(
        id: '4',
        name: 'Digital Nomad in Bali',
        coverImage: 'https://images.unsplash.com/photo-1537996194471-e657df975ab4?auto=format&fit=crop&w=800&q=80',
        shortStory: 'Work remotely while exploring the beautiful islands of Indonesia.',
        matchPercentage: 0.85,
        estimatedSalary: '\$120,000/yr',
        difficulty: 'Medium',
        growthPotential: 'High',
        whyRecommended: ['Remote', 'Lifestyle', 'Freelance'],
      ),
      RecommendedFutureEntity(
        id: '5',
        name: 'Study Abroad (USA)',
        coverImage: 'https://images.unsplash.com/photo-1523050854058-8df90110c9f1?auto=format&fit=crop&w=800&q=80',
        shortStory: 'Pursue a Masters degree in Computer Science at a top university.',
        matchPercentage: 0.88,
        estimatedSalary: 'Student',
        difficulty: 'Hard',
        growthPotential: 'Very High',
        whyRecommended: ['Education', 'Networking', 'Growth'],
      ),
    ];
  }

  Future<String> getMessageFromFuture() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return "Today's consistency creates tomorrow's success.\n\nSpend one hour improving your backend fundamentals.\n\nYou'll thank yourself in 2029.";
  }

  Future<int> getStreak() async {
    return 7;
  }

  Future<ReadinessScoreEntity> getReadinessScore() async {
    return ReadinessScoreEntity(
      overallScore: 0.84,
      skills: {
        'Backend': 0.92,
        'System Design': 0.78,
        'Leadership': 0.63,
        'Communication': 0.74,
        'Problem Solving': 0.95,
      },
    );
  }

  Future<List<FutureInsightEntity>> getInsights() async {
    return [
      FutureInsightEntity(id: 'i1', text: 'Improve System Design to unlock your next promotion.', emoji: '💡'),
      FutureInsightEntity(id: 'i2', text: 'Your startup has a high probability of Series A funding.', emoji: '🚀'),
      FutureInsightEntity(id: 'i3', text: 'Your salary is projected to grow by 32% this year.', emoji: '📈'),
      FutureInsightEntity(id: 'i4', text: 'Focus on communication skills to accelerate leadership growth.', emoji: '🎯'),
    ];
  }

  Future<WeeklyReportEntity> getWeeklyReport() async {
    return WeeklyReportEntity(
      exploredFutures: ['Google Staff Engineer', 'AI Startup Founder'],
      aiObservation: 'You consistently choose high-growth careers.',
      suggestedNextFuture: 'OpenAI Research Engineer',
      successProbability: 0.91,
      recommendedSkill: 'Distributed Systems',
    );
  }

  Future<List<AchievementEntity>> getAchievements() async {
    return [
      AchievementEntity(id: 'a1', title: 'First Future Generated', emoji: '🏆', isUnlocked: true),
      AchievementEntity(id: 'a2', title: 'Future Explorer', emoji: '🗺️', isUnlocked: true),
      AchievementEntity(id: 'a3', title: 'AI Conversation Master', emoji: '🤖', isUnlocked: true),
      AchievementEntity(id: 'a4', title: 'Career Architect', emoji: '🏗️', isUnlocked: false),
      AchievementEntity(id: 'a5', title: 'Startup Visionary', emoji: '💡', isUnlocked: false),
    ];
  }

  Future<List<WhatIfScenarioEntity>> getWhatIfScenarios() async {
    return [
      WhatIfScenarioEntity(id: 'w1', title: 'What if you joined Google?', query: 'Join Google as SWE'),
      WhatIfScenarioEntity(id: 'w2', title: 'What if you started a startup?', query: 'Start AI startup'),
      WhatIfScenarioEntity(id: 'w3', title: 'What if you studied abroad?', query: 'Study MS in USA'),
      WhatIfScenarioEntity(id: 'w4', title: 'What if you became a Product Manager?', query: 'Transition to PM'),
    ];
  }

  Future<List<TrendingFutureEntity>> getTrendingFutures() async {
    return [
      TrendingFutureEntity(id: 't1', name: 'AI Engineer', popularity: '#1', averageHappiness: '94%', growthPotential: 'Very High'),
      TrendingFutureEntity(id: 't2', name: 'Startup Founder', popularity: '#2', averageHappiness: '88%', growthPotential: 'Exponential'),
      TrendingFutureEntity(id: 't3', name: 'Remote Freelancer', popularity: '#3', averageHappiness: '96%', growthPotential: 'High'),
    ];
  }
}
