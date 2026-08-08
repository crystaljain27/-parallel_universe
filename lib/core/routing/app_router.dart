import 'package:flutter/material.dart';
import 'package:parallel_universe/features/splash/presentation/pages/splash_screen.dart';
import 'package:parallel_universe/features/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:parallel_universe/features/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:parallel_universe/features/auth/presentation/pages/login_screen.dart';
import 'package:parallel_universe/features/auth/presentation/pages/register_screen.dart';
import 'package:parallel_universe/features/auth/presentation/pages/forgot_password_screen.dart';
import 'package:parallel_universe/features/auth/presentation/pages/otp_verification_screen.dart';
import 'package:parallel_universe/features/auth/presentation/pages/auth_success_screen.dart';
import 'package:parallel_universe/features/chat/presentation/pages/chat_list_screen.dart';
import 'package:parallel_universe/features/chat/presentation/pages/chat_screen.dart';
import 'package:parallel_universe/features/universe_generation/domain/entities/generated_universe_entity.dart';
import 'package:parallel_universe/features/universe_generation/presentation/pages/generation_loading_screen.dart';
import 'package:parallel_universe/features/universe_generation/presentation/pages/universe_results_screen.dart';
import 'package:parallel_universe/features/universe_generation/presentation/pages/universe_details_screen.dart';
import 'package:parallel_universe/features/future_self/presentation/pages/future_chat_screen.dart';
import 'package:parallel_universe/features/dashboard/presentation/pages/settings_screen.dart';
import 'package:parallel_universe/features/dashboard/presentation/pages/travel_history_screen.dart';
import 'package:parallel_universe/features/dashboard/domain/entities/universe_entity.dart';
import 'package:parallel_universe/features/dashboard/presentation/pages/explore_details_screen.dart';
import 'package:parallel_universe/features/life_interview/presentation/pages/life_interview_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot_password';
  static const String otp = '/otp';
  static const String authSuccess = '/auth_success';

  static const String chatList = '/chat_list';
  static const String chat = '/chat';

  static const String generateLoading = '/generate_loading';
  static const String universeResults = '/universe_results';
  static const String universeDetails = '/universe_details';

  static const String futureChat = '/future_chat';
  static const String settings = '/settings';
  static const String travelHistory = '/travel_history';
  static const String exploreDetails = '/explore_details';
  static const String lifeInterview = '/life_interview';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case otp:
        final email = settings.arguments as String? ?? '';
        return MaterialPageRoute(builder: (_) => OtpVerificationScreen(email: email));
      case authSuccess:
        return MaterialPageRoute(builder: (_) => const AuthSuccessScreen());
      case chatList:
        return MaterialPageRoute(builder: (_) => const ChatListScreen());
      case chat:
        final sessionId = settings.arguments as String?;
        return MaterialPageRoute(builder: (_) => ChatScreen(sessionId: sessionId));
      case generateLoading:
        final sessionId = settings.arguments as String? ?? 'default';
        return MaterialPageRoute(builder: (_) => GenerationLoadingScreen(sessionId: sessionId));
      case universeResults:
        return MaterialPageRoute(builder: (_) => const UniverseResultsScreen());
      case universeDetails:
        final universe = settings.arguments as GeneratedUniverseEntity;
        return MaterialPageRoute(builder: (_) => UniverseDetailsScreen(universe: universe));
      case futureChat:
        final universe = settings.arguments as GeneratedUniverseEntity;
        return MaterialPageRoute(builder: (_) => FutureChatScreen(universe: universe));
      case AppRouter.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case AppRouter.travelHistory:
        return MaterialPageRoute(builder: (_) => const TravelHistoryScreen());
      case AppRouter.exploreDetails:
        final universe = settings.arguments as UniverseEntity;
        return MaterialPageRoute(builder: (_) => ExploreDetailsScreen(universe: universe));
      case lifeInterview:
        return MaterialPageRoute(builder: (_) => const LifeInterviewScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
