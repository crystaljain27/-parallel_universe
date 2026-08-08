import 'package:flutter/material.dart';

class SalaryGrowthGraph extends StatelessWidget {
  final List<int> salaries;
  const SalaryGrowthGraph({super.key, required this.salaries});

  @override
  Widget build(BuildContext context) {
    if (salaries.isEmpty) return const SizedBox();
    
    final maxSalary = salaries.reduce((a, b) => a > b ? a : b);

    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: salaries.map((salary) {
          final heightRatio = salary / maxSalary;
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('\$${(salary / 1000).toStringAsFixed(0)}k', style: const TextStyle(fontSize: 10)),
              const SizedBox(height: 8),
              AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                width: 40,
                height: 140 * heightRatio,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
