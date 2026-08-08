import 'package:flutter/material.dart';
import 'package:parallel_universe/features/universe_generation/domain/entities/generated_universe_entity.dart';

class ComparisonDashboardWidget extends StatelessWidget {
  final List<GeneratedUniverseEntity> universes;
  
  const ComparisonDashboardWidget({super.key, required this.universes});

  @override
  Widget build(BuildContext context) {
    if (universes.isEmpty) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Parallel Lives Comparison',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(Colors.deepPurple.withOpacity(0.1)),
                columns: [
                  const DataColumn(label: Text('Universe')),
                  const DataColumn(label: Text('Difficulty')),
                  const DataColumn(label: Text('Timeline')),
                  const DataColumn(label: Text('Confidence')),
                ],
                rows: universes.map((u) {
                  return DataRow(cells: [
                    DataCell(Text(u.name, style: const TextStyle(fontWeight: FontWeight.bold))),
                    DataCell(Text(u.difficultyLevel)),
                    DataCell(Text(u.estimatedTimeline)),
                    DataCell(
                      Row(
                        children: [
                          Icon(Icons.star, size: 16, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text('${u.confidenceScore}%'),
                        ],
                      ),
                    ),
                  ]);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
