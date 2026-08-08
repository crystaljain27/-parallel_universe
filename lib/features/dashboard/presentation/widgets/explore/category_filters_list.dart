import 'package:flutter/material.dart';

import 'package:parallel_universe/core/routing/app_router.dart';

class CategoryFiltersList extends StatelessWidget {
  final List<String> categories = const [
    'Career', 'Technology', 'Business', 'Startup', 
    'Finance', 'Study Abroad', 'Lifestyle', 
    'Entrepreneurship', 'AI', 'Remote Work'
  ];

  const CategoryFiltersList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ActionChip(
              label: Text(categories[index]),
              onPressed: () {
                Navigator.pushNamed(context, AppRouter.generateLoading, arguments: 'Explore ${categories[index]}');
              },
              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          );
        },
      ),
    );
  }
}
