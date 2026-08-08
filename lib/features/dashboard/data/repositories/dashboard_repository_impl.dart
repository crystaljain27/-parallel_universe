import 'package:parallel_universe/features/dashboard/domain/entities/active_future_entity.dart';
import 'package:parallel_universe/features/dashboard/domain/entities/recommended_future_entity.dart';
import 'package:parallel_universe/features/dashboard/domain/entities/future_insight_entity.dart';
import 'package:parallel_universe/features/dashboard/domain/entities/readiness_score_entity.dart';
import 'package:parallel_universe/features/dashboard/domain/entities/weekly_report_entity.dart';
import 'package:parallel_universe/features/dashboard/domain/entities/achievement_entity.dart';
import 'package:parallel_universe/features/dashboard/domain/entities/what_if_scenario_entity.dart';
import 'package:parallel_universe/features/dashboard/domain/entities/trending_future_entity.dart';
import 'package:parallel_universe/features/dashboard/domain/repositories/i_dashboard_repository.dart';
import 'package:parallel_universe/features/dashboard/data/datasources/dashboard_remote_data_source.dart';

class DashboardRepositoryImpl implements IDashboardRepository {
  final DashboardRemoteDataSource _remoteDataSource;

  DashboardRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<ActiveFutureEntity>> getFeed() async {
    return _remoteDataSource.getFeed();
  }

  @override
  Future<List<RecommendedFutureEntity>> getExploreUniverses() async {
    return _remoteDataSource.getExploreUniverses();
  }

  @override
  Future<String> getMessageFromFuture() async {
    return _remoteDataSource.getMessageFromFuture();
  }

  @override
  Future<int> getStreak() async {
    return _remoteDataSource.getStreak();
  }

  @override
  Future<ReadinessScoreEntity> getReadinessScore() async {
    return _remoteDataSource.getReadinessScore();
  }

  @override
  Future<List<FutureInsightEntity>> getInsights() async {
    return _remoteDataSource.getInsights();
  }

  @override
  Future<WeeklyReportEntity> getWeeklyReport() async {
    return _remoteDataSource.getWeeklyReport();
  }

  @override
  Future<List<AchievementEntity>> getAchievements() async {
    return _remoteDataSource.getAchievements();
  }

  @override
  Future<List<WhatIfScenarioEntity>> getWhatIfScenarios() async {
    return _remoteDataSource.getWhatIfScenarios();
  }

  @override
  Future<List<TrendingFutureEntity>> getTrendingFutures() async {
    return _remoteDataSource.getTrendingFutures();
  }
}
