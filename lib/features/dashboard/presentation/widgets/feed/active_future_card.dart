import 'package:flutter/material.dart';
import 'package:parallel_universe/features/dashboard/domain/entities/active_future_entity.dart';
import 'package:parallel_universe/core/widgets/safe_network_image.dart';
import 'package:parallel_universe/core/routing/app_router.dart';
import 'package:parallel_universe/features/universe_generation/domain/entities/generated_universe_entity.dart';
import 'package:uuid/uuid.dart';

class ActiveFutureCard extends StatelessWidget {
  final ActiveFutureEntity future;

  const ActiveFutureCard({super.key, required this.future});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
                color: Colors.black.withAlpha(100),
                colorBlendMode: BlendMode.darken,
              ),
              Positioned(
                bottom: 16,
                left: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      future.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildProgress(context),
                const SizedBox(height: 16),
                _buildInfoGrid(context),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      final mockUniverse = GeneratedUniverseEntity(
                        id: const Uuid().v4(),
                        name: future.name,
                        coverImage: future.coverImage,
                        summary: 'Continue your journey as a ${future.currentPosition}.',
                        confidenceScore: 90,
                        difficultyLevel: 'Hard',
                        estimatedTimeline: 'Ongoing',
                        requiredSkills: [],
                        keyMilestones: [],
                        salaryProgression: [],
                        pros: [],
                        cons: [],
                        dailyRoutine: 'Your daily routine as a ${future.currentPosition}.',
                        aiRecommendation: 'Keep up the good work on your progress!',
                      );
                      Navigator.pushNamed(context, AppRouter.futureChat, arguments: mockUniverse);
                    },
                    icon: const Icon(Icons.rocket_launch),
                    label: const Text('Continue Journey'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgress(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Journey Progress', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('${(future.progressPercentage * 100).toInt()}%', 
                style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: future.progressPercentage,
          borderRadius: BorderRadius.circular(8),
          minHeight: 8,
        ),
      ],
    );
  }

  Widget _buildInfoGrid(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildInfoItem(context, 'Current Position', future.currentPosition, Icons.work)),
        Expanded(child: _buildInfoItem(context, 'Est. Salary', future.estimatedSalary, Icons.attach_money)),
      ],
    );
  }

  Widget _buildInfoItem(BuildContext context, String title, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ],
    );
  }
}
