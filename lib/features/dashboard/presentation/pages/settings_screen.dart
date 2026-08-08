import 'package:flutter/material.dart';
import 'package:parallel_universe/core/di/dependency_injection.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Account Details'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Account Details'),
                  content: const Text('Email: crystaljain2711@gmail.com\nPlan: Parallel Free Tier'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    )
                  ],
                ),
              );
            },
          ),
          ListenableBuilder(
            listenable: DI.settingsViewModel,
            builder: (context, _) {
              final isDark = DI.settingsViewModel.themeMode == ThemeMode.dark;
              final notifsEnabled = DI.settingsViewModel.notificationsEnabled;

              return Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.notifications),
                    title: const Text('Notifications'),
                    trailing: Switch(
                      value: notifsEnabled, 
                      onChanged: (v) {
                        DI.settingsViewModel.toggleNotifications(v);
                      },
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.dark_mode),
                    title: const Text('Dark Mode'),
                    trailing: Switch(
                      value: isDark, 
                      onChanged: (v) {
                        DI.settingsViewModel.toggleTheme(v);
                      },
                    ),
                  ),
                ],
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About Parallel Universe'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Parallel Universe',
                applicationVersion: '1.0.0',
                applicationLegalese: '© 2026 Parallel Inc.',
                children: [
                  const SizedBox(height: 16),
                  const Text('Discover what could have been.'),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
