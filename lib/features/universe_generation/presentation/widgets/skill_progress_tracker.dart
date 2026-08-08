import 'package:flutter/material.dart';

class SkillProgressTracker extends StatelessWidget {
  final List<String> skills;
  const SkillProgressTracker({super.key, required this.skills});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: skills.map((skill) {
        return Chip(
          label: Text(skill),
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSecondaryContainer),
        );
      }).toList(),
    );
  }
}
