import 'package:flutter/material.dart';
import 'package:parallel_universe/core/routing/app_router.dart';
import 'package:parallel_universe/features/auth/presentation/widgets/primary_auth_button.dart';

class AuthSuccessScreen extends StatelessWidget {
  const AuthSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, size: 100, color: Colors.green),
              const SizedBox(height: 24),
              Text(
                'Authentication Successful',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text('Welcome to Parallel Universe. You are now logged in.'),
              const SizedBox(height: 48),
              PrimaryAuthButton(
                text: 'Go to Dashboard',
                onPressed: () {
                  Navigator.pushReplacementNamed(context, AppRouter.home);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
