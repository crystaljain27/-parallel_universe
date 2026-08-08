import 'package:flutter/material.dart';
import 'package:parallel_universe/core/di/dependency_injection.dart';
import 'package:parallel_universe/core/routing/app_router.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const CircleAvatar(
          radius: 50,
          backgroundColor: Colors.deepPurple,
          child: Icon(Icons.person, size: 50, color: Colors.white),
        ),
        const SizedBox(height: 16),
        const Text(
          'Parallel Explorer',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 32),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Settings'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.pushNamed(context, AppRouter.settings);
          },
        ),
        ListTile(
          leading: const Icon(Icons.history),
          title: const Text('Travel History'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.pushNamed(context, AppRouter.travelHistory);
          },
        ),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text('Logout', style: TextStyle(color: Colors.red)),
          onTap: () async {
            debugPrint('[ProfileTab] Logout button tapped');
            await DI.authViewModel.logout();
            if (context.mounted) {
              Navigator.pushReplacementNamed(context, AppRouter.login);
            }
          },
        ),
      ],
    );
  }
}
