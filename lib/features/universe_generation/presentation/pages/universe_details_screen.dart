import 'package:parallel_universe/core/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:parallel_universe/features/universe_generation/domain/entities/generated_universe_entity.dart';
import 'package:parallel_universe/features/universe_generation/presentation/widgets/premium_timeline_view.dart';
import 'package:parallel_universe/features/universe_generation/presentation/widgets/salary_growth_graph.dart';
import 'package:parallel_universe/features/universe_generation/presentation/widgets/skill_progress_tracker.dart';
import 'package:parallel_universe/features/universe_generation/presentation/widgets/pros_cons_list.dart';
import 'package:parallel_universe/core/widgets/safe_network_image.dart';

class UniverseDetailsScreen extends StatelessWidget {
  final GeneratedUniverseEntity universe;
  const UniverseDetailsScreen({super.key, required this.universe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.black54,
                child: const BackButton(color: Colors.white),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(universe.name, style: const TextStyle(shadows: [Shadow(color: Colors.black, blurRadius: 4)])),
              background: Hero(
                tag: 'universe_${universe.id}',
                child: SafeNetworkImage(
                  imageUrl: universe.coverImage,
                  height: 300,
                  fit: BoxFit.cover,
                  color: Colors.black.withAlpha(100),
                  colorBlendMode: BlendMode.darken,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(context, 'Summary'),
                  Text(universe.summary, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 24),

                  _buildSectionTitle(context, 'AI Recommendation'),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      universe.aiRecommendation,
                      style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer, fontStyle: FontStyle.italic),
                    ),
                  ),
                  const SizedBox(height: 24),

                  _buildSectionTitle(context, 'Required Skills'),
                  SkillProgressTracker(skills: universe.requiredSkills),
                  const SizedBox(height: 24),

                  _buildSectionTitle(context, 'Career Timeline'),
                  PremiumTimelineView(milestones: universe.keyMilestones),
                  const SizedBox(height: 24),

                  _buildSectionTitle(context, 'Salary Progression'),
                  SalaryGrowthGraph(salaries: universe.salaryProgression),
                  const SizedBox(height: 24),

                  _buildSectionTitle(context, 'Pros & Cons'),
                  ProsConsList(pros: universe.pros, cons: universe.cons),
                  const SizedBox(height: 24),

                  _buildSectionTitle(context, 'Daily Routine'),
                  Text(universe.dailyRoutine),
                  const SizedBox(height: 64),
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(
            context,
            AppRouter.futureChat,
            arguments: universe,
          );
        },
        icon: const Icon(Icons.psychology),
        label: const Text('Talk to Future Self'),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
      ),
    );
  }
}
