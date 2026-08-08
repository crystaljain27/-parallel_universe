import 'package:flutter/material.dart';
import 'package:parallel_universe/core/di/dependency_injection.dart';
import 'package:parallel_universe/core/routing/app_router.dart';

class GenerationLoadingScreen extends StatefulWidget {
  final String sessionId;
  const GenerationLoadingScreen({super.key, required this.sessionId});

  @override
  State<GenerationLoadingScreen> createState() => _GenerationLoadingScreenState();
}

class _GenerationLoadingScreenState extends State<GenerationLoadingScreen> with SingleTickerProviderStateMixin {
  final _viewModel = DI.universeGenerationViewModel;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
    _generate();
  }

  Future<void> _generate() async {
    final success = await _viewModel.generate(widget.sessionId);
    if (success && mounted) {
      Navigator.pushReplacementNamed(context, AppRouter.universeResults);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_viewModel.errorMessage ?? 'Failed to generate.')));
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RotationTransition(
              turns: _controller,
              child: const Icon(Icons.auto_awesome, size: 64, color: Colors.deepPurple),
            ),
            const SizedBox(height: 24),
            Text(
              'Simulating Parallel Universes...',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Analyzing profile, skills, and market dynamics...'),
          ],
        ),
      ),
    );
  }
}
