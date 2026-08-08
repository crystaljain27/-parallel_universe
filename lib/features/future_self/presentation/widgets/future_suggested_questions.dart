import 'package:flutter/material.dart';

class FutureSuggestedQuestions extends StatelessWidget {
  final Function(String) onSelect;
  const FutureSuggestedQuestions({super.key, required this.onSelect});

  final questions = const [
    'How did you crack it?',
    'What mistakes should I avoid?',
    'What was your biggest failure?',
    'What should I study next?',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(8),
      child: Row(
        children: questions.map((q) => Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ActionChip(
            label: Text(q, style: const TextStyle(fontSize: 12)),
            onPressed: () => onSelect(q),
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          ),
        )).toList(),
      ),
    );
  }
}
