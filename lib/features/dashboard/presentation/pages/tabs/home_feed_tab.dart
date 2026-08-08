import 'package:flutter/material.dart';
import 'package:parallel_universe/features/dashboard/presentation/manager/dashboard_view_model.dart';
import 'package:parallel_universe/features/dashboard/presentation/widgets/feed_skeleton.dart';

import 'package:parallel_universe/features/dashboard/presentation/widgets/feed/message_from_future_hero.dart';
import 'package:parallel_universe/features/dashboard/presentation/widgets/feed/streak_badge.dart';
import 'package:parallel_universe/features/dashboard/presentation/widgets/feed/future_readiness_dashboard.dart';
import 'package:parallel_universe/features/dashboard/presentation/widgets/feed/live_insight_card.dart';
import 'package:parallel_universe/features/dashboard/presentation/widgets/feed/active_future_card.dart';
import 'package:parallel_universe/features/dashboard/presentation/widgets/feed/weekly_future_report.dart';
import 'package:parallel_universe/features/dashboard/presentation/widgets/feed/achievements_row.dart';

class HomeFeedTab extends StatelessWidget {
  final DashboardViewModel viewModel;
  const HomeFeedTab({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    if (viewModel.isLoadingFeed) {
      return const FeedSkeleton();
    }

    if (viewModel.errorMessage != null && viewModel.feed.isEmpty) {
      return Center(child: Text(viewModel.errorMessage!));
    }

    return RefreshIndicator(
      onRefresh: viewModel.fetchFeed,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 100, top: 16),
        children: [
          MessageFromFutureHero(message: viewModel.messageFromFuture),
          
          if (viewModel.streak > 0) 
            StreakBadge(streak: viewModel.streak),
            
          const SizedBox(height: 24),
          
          if (viewModel.insights.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text('Live Future Insights', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: viewModel.insights.length,
                itemBuilder: (context, index) => LiveInsightCard(insight: viewModel.insights[index]),
              ),
            ),
            const SizedBox(height: 24),
          ],

          if (viewModel.readinessScore != null)
            FutureReadinessDashboard(score: viewModel.readinessScore!),

          const SizedBox(height: 24),
          
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text('Your Active Futures', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          ...viewModel.feed.map((future) => ActiveFutureCard(future: future)),
          
          const SizedBox(height: 24),
          
          if (viewModel.weeklyReport != null)
            WeeklyFutureReport(report: viewModel.weeklyReport!),
            
          const SizedBox(height: 16),
          
          if (viewModel.achievements.isNotEmpty)
            AchievementsRow(achievements: viewModel.achievements),
        ],
      ),
    );
  }
}
