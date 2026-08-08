import 'package:flutter/material.dart';

import 'package:parallel_universe/core/routing/app_router.dart';

class PremiumSearchBar extends StatelessWidget {
  const PremiumSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: TextField(
        onSubmitted: (value) {
          if (value.trim().isNotEmpty) {
            Navigator.pushNamed(context, AppRouter.generateLoading, arguments: value.trim());
          }
        },
        decoration: InputDecoration(
          hintText: 'Search careers, lifestyles, companies...',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
          ),
        ),
      ),
    );
  }
}
