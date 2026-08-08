import 'package:parallel_universe/features/dashboard/domain/entities/active_future_entity.dart';
import 'package:parallel_universe/features/dashboard/domain/entities/recommended_future_entity.dart';
import 'package:parallel_universe/features/dashboard/domain/entities/future_insight_entity.dart';
import 'package:parallel_universe/features/dashboard/domain/entities/readiness_score_entity.dart';
import 'package:parallel_universe/features/dashboard/domain/entities/weekly_report_entity.dart';
import 'package:parallel_universe/features/dashboard/domain/entities/achievement_entity.dart';
import 'package:parallel_universe/features/dashboard/domain/entities/what_if_scenario_entity.dart';
import 'package:parallel_universe/features/dashboard/domain/entities/trending_future_entity.dart';

abstract class IDashboardRepository {
  Future<List<ActiveFutureEntity>> getFeed();
  Future<List<RecommendedFutureEntity>> getExploreUniverses();
  
  Future<String> getMessageFromFuture();
  Future<int> getStreak();
  Future<ReadinessScoreEntity> getReadinessScore();
  Future<List<FutureInsightEntity>> getInsights();
  Future<WeeklyReportEntity> getWeeklyReport();
  Future<List<AchievementEntity>> getAchievements();
  
  Future<List<WhatIfScenarioEntity>> getWhatIfScenarios();
  Future<List<TrendingFutureEntity>> getTrendingFutures();
}
