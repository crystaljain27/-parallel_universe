import 'package:flutter/material.dart';
import 'package:parallel_universe/features/dashboard/presentation/manager/dashboard_view_model.dart';
import 'package:parallel_universe/features/dashboard/presentation/widgets/feed_skeleton.dart';

import 'package:parallel_universe/features/dashboard/presentation/widgets/explore/explore_hero_section.dart';
import 'package:parallel_universe/features/dashboard/presentation/widgets/explore/premium_search_bar.dart';
import 'package:parallel_universe/features/dashboard/presentation/widgets/explore/category_filters_list.dart';
import 'package:parallel_universe/features/dashboard/presentation/widgets/explore/what_if_carousel.dart';
import 'package:parallel_universe/features/dashboard/presentation/widgets/explore/recommended_future_card.dart';
import 'package:parallel_universe/features/dashboard/presentation/widgets/explore/trending_futures_section.dart';

class ExploreTab extends StatelessWidget {
  final DashboardViewModel viewModel;
  const ExploreTab({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    if (viewModel.isLoadingExplore) {
      return const FeedSkeleton();
    }

    if (viewModel.errorMessage != null && viewModel.explore.isEmpty) {
      return Center(child: Text(viewModel.errorMessage!));
    }

    return RefreshIndicator(
      onRefresh: viewModel.fetchExplore,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 100),
        children: [
          const ExploreHeroSection(),
          const SizedBox(height: 16),
          const PremiumSearchBar(),
          const CategoryFiltersList(),
          const SizedBox(height: 24),
          
          if (viewModel.whatIfScenarios.isNotEmpty)
            WhatIfCarousel(scenarios: viewModel.whatIfScenarios),
            
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text('Recommended For You', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          ...viewModel.explore.map((future) => RecommendedFutureCard(future: future)),
          
          const SizedBox(height: 24),
          if (viewModel.trendingFutures.isNotEmpty)
            TrendingFuturesSection(trends: viewModel.trendingFutures),
        ],
      ),
    );
  }
}
