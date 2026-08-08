import 'package:flutter/material.dart';
import 'package:parallel_universe/features/dashboard/domain/repositories/i_dashboard_repository.dart';
import 'package:parallel_universe/features/dashboard/domain/entities/active_future_entity.dart';
import 'package:parallel_universe/features/dashboard/domain/entities/recommended_future_entity.dart';
import 'package:parallel_universe/features/dashboard/domain/entities/future_insight_entity.dart';
import 'package:parallel_universe/features/dashboard/domain/entities/readiness_score_entity.dart';
import 'package:parallel_universe/features/dashboard/domain/entities/weekly_report_entity.dart';
import 'package:parallel_universe/features/dashboard/domain/entities/achievement_entity.dart';
import 'package:parallel_universe/features/dashboard/domain/entities/what_if_scenario_entity.dart';
import 'package:parallel_universe/features/dashboard/domain/entities/trending_future_entity.dart';

class DashboardViewModel extends ChangeNotifier {
  final IDashboardRepository _dashboardRepository;

  DashboardViewModel(this._dashboardRepository);

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  bool _isLoadingFeed = false;
  bool get isLoadingFeed => _isLoadingFeed;

  bool _isLoadingExplore = false;
  bool get isLoadingExplore => _isLoadingExplore;

  List<ActiveFutureEntity> _feed = [];
  List<ActiveFutureEntity> get feed => _feed;

  List<RecommendedFutureEntity> _explore = [];
  List<RecommendedFutureEntity> get explore => _explore;

  // New states for premium dashboard
  String _messageFromFuture = '';
  String get messageFromFuture => _messageFromFuture;

  int _streak = 0;
  int get streak => _streak;

  ReadinessScoreEntity? _readinessScore;
  ReadinessScoreEntity? get readinessScore => _readinessScore;

  List<FutureInsightEntity> _insights = [];
  List<FutureInsightEntity> get insights => _insights;

  WeeklyReportEntity? _weeklyReport;
  WeeklyReportEntity? get weeklyReport => _weeklyReport;

  List<AchievementEntity> _achievements = [];
  List<AchievementEntity> get achievements => _achievements;

  List<WhatIfScenarioEntity> _whatIfScenarios = [];
  List<WhatIfScenarioEntity> get whatIfScenarios => _whatIfScenarios;

  List<TrendingFutureEntity> _trendingFutures = [];
  List<TrendingFutureEntity> get trendingFutures => _trendingFutures;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void setTabIndex(int index) {
    _currentIndex = index;
    notifyListeners();
    if (index == 0 && _feed.isEmpty) {
      fetchFeed();
    } else if (index == 1 && _explore.isEmpty) {
      fetchExplore();
    }
  }

  Future<void> fetchFeed() async {
    _isLoadingFeed = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final results = await Future.wait([
        _dashboardRepository.getFeed(),
        _dashboardRepository.getMessageFromFuture(),
        _dashboardRepository.getStreak(),
        _dashboardRepository.getReadinessScore(),
        _dashboardRepository.getInsights(),
        _dashboardRepository.getWeeklyReport(),
        _dashboardRepository.getAchievements(),
      ]);

      _feed = results[0] as List<ActiveFutureEntity>;
      _messageFromFuture = results[1] as String;
      _streak = results[2] as int;
      _readinessScore = results[3] as ReadinessScoreEntity;
      _insights = results[4] as List<FutureInsightEntity>;
      _weeklyReport = results[5] as WeeklyReportEntity;
      _achievements = results[6] as List<AchievementEntity>;

    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoadingFeed = false;
      notifyListeners();
    }
  }

  Future<void> fetchExplore() async {
    _isLoadingExplore = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final results = await Future.wait([
        _dashboardRepository.getExploreUniverses(),
        _dashboardRepository.getWhatIfScenarios(),
        _dashboardRepository.getTrendingFutures(),
      ]);

      _explore = results[0] as List<RecommendedFutureEntity>;
      _whatIfScenarios = results[1] as List<WhatIfScenarioEntity>;
      _trendingFutures = results[2] as List<TrendingFutureEntity>;

    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoadingExplore = false;
      notifyListeners();
    }
  }
}
