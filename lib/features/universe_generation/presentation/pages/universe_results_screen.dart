import 'package:flutter/material.dart';
import 'package:parallel_universe/core/di/dependency_injection.dart';
import 'package:parallel_universe/core/routing/app_router.dart';
import 'package:parallel_universe/features/universe_generation/presentation/widgets/animated_universe_card.dart';

import 'package:parallel_universe/features/universe_generation/presentation/widgets/comparison_dashboard_widget.dart';

class UniverseResultsScreen extends StatelessWidget {
  const UniverseResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = DI.universeGenerationViewModel;
    final universes = viewModel.universes;

    return Scaffold(
      appBar: AppBar(title: const Text('Your Parallel Lives')),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: universes.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return ComparisonDashboardWidget(universes: universes);
          }
          final universeIndex = index - 1;
          return AnimatedUniverseCard(
            universe: universes[universeIndex],
            onTap: () {
              Navigator.pushNamed(
                context, 
                AppRouter.universeDetails, 
                arguments: universes[universeIndex],
              );
            },
          );
        },
      ),
    );
  }
}
