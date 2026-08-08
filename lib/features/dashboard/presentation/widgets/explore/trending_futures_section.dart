import 'package:flutter/material.dart';
import 'package:parallel_universe/features/dashboard/domain/entities/trending_future_entity.dart';
import 'package:parallel_universe/core/routing/app_router.dart';

class TrendingFuturesSection extends StatelessWidget {
  final List<TrendingFutureEntity> trends;

  const TrendingFuturesSection({super.key, required this.trends});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text('Trending This Week', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: trends.length,
          itemBuilder: (context, index) {
            final trend = trends[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Text(trend.popularity.replaceAll('#', ''), style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer, fontWeight: FontWeight.bold)),
              ),
              title: Text(trend.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Row(
                children: [
                  const Icon(Icons.sentiment_very_satisfied, size: 14, color: Colors.green),
                  const SizedBox(width: 4),
                  Text('${trend.averageHappiness} Happiness'),
                  const SizedBox(width: 12),
                  const Icon(Icons.trending_up, size: 14, color: Colors.blue),
                  const SizedBox(width: 4),
                  Text(trend.growthPotential),
                ],
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pushNamed(context, AppRouter.generateLoading, arguments: 'Become an ${trend.name}');
              },
            );
          },
        ),
      ],
    );
  }
}
