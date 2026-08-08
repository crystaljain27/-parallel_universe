import 'package:flutter/material.dart';
import 'package:parallel_universe/features/dashboard/domain/entities/recommended_future_entity.dart';
import 'package:parallel_universe/core/widgets/safe_network_image.dart';
import 'package:parallel_universe/core/routing/app_router.dart';
import 'package:parallel_universe/features/universe_generation/domain/entities/generated_universe_entity.dart';
import 'package:uuid/uuid.dart';

class RecommendedFutureCard extends StatelessWidget {
  final RecommendedFutureEntity future;

  const RecommendedFutureCard({super.key, required this.future});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              SafeNetworkImage(
                imageUrl: future.coverImage,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${(future.matchPercentage * 100).toInt()}% Match',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  future.name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  future.shortStory,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildMetric(context, Icons.attach_money, future.estimatedSalary),
                    _buildMetric(context, Icons.trending_up, future.growthPotential),
                    _buildMetric(context, Icons.speed, future.difficulty),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Why Recommended:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: future.whyRecommended.map((tag) => Chip(
                    label: Text(tag, style: const TextStyle(fontSize: 10)),
                    padding: EdgeInsets.zero,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  )).toList(),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      final mockUniverse = GeneratedUniverseEntity(
                        id: const Uuid().v4(),
                        name: future.name,
                        coverImage: future.coverImage,
                        summary: future.shortStory,
                        confidenceScore: (future.matchPercentage * 100).toInt(),
                        difficultyLevel: future.difficulty,
                        estimatedTimeline: '2 Years',
                        requiredSkills: future.whyRecommended,
                        keyMilestones: [],
                        salaryProgression: [],
                        pros: [],
                        cons: [],
                        dailyRoutine: 'Your daily routine as a ${future.name}.',
                        aiRecommendation: 'Consider exploring this highly recommended path.',
                      );
                      Navigator.pushNamed(context, AppRouter.universeDetails, arguments: mockUniverse);
                    },
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Explore This Future'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
