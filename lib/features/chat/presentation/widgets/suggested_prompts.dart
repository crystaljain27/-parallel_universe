import 'package:flutter/material.dart';

class SuggestedPrompts extends StatelessWidget {
  final Function(String) onPromptSelected;
  const SuggestedPrompts({super.key, required this.onPromptSelected});

  final prompts = const [
    'Explain parallel universes',
    'How do I travel?',
    'Write a sci-fi story',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: prompts.map((p) => Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ActionChip(
            label: Text(p),
            onPressed: () => onPromptSelected(p),
          ),
        )).toList(),
      ),
    );
  }
}
