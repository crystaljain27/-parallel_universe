import 'package:flutter/material.dart';
import 'package:parallel_universe/core/di/dependency_injection.dart';
import 'package:parallel_universe/core/routing/app_router.dart';
import 'package:parallel_universe/core/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await dotenv.load(fileName: ".env");
    debugPrint("[main.dart] .env file loaded successfully");
  } catch (e) {
    debugPrint("[main.dart] Failed to load .env file: $e");
  }
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase not configured yet: $e");
  }

  await DI.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: DI.authViewModel),
        ChangeNotifierProvider.value(value: DI.dashboardViewModel),
        ChangeNotifierProvider.value(value: DI.chatListViewModel),
        ChangeNotifierProvider.value(value: DI.chatViewModel),
        ChangeNotifierProvider.value(value: DI.universeGenerationViewModel),
        ChangeNotifierProvider.value(value: DI.futureChatViewModel),
        ChangeNotifierProvider.value(value: DI.settingsViewModel),
        ChangeNotifierProvider.value(value: DI.travelHistoryViewModel),
        ChangeNotifierProvider.value(value: DI.lifeInterviewViewModel),
      ],
      child: ListenableBuilder(
        listenable: DI.settingsViewModel,
        builder: (context, child) {
          return MaterialApp(
            title: 'Parallel Universe',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: DI.settingsViewModel.themeMode,
            initialRoute: AppRouter.splash,
            onGenerateRoute: AppRouter.generateRoute,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
