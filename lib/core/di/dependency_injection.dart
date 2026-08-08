import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:parallel_universe/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:parallel_universe/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:parallel_universe/features/auth/presentation/manager/auth_view_model.dart';
import 'package:parallel_universe/features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:parallel_universe/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:parallel_universe/features/dashboard/presentation/manager/dashboard_view_model.dart';
import 'package:parallel_universe/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:parallel_universe/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:parallel_universe/features/chat/presentation/manager/chat_list_view_model.dart';
import 'package:parallel_universe/features/chat/presentation/manager/chat_view_model.dart';
import 'package:parallel_universe/features/universe_generation/data/datasources/universe_remote_data_source.dart';
import 'package:parallel_universe/features/universe_generation/data/repositories/universe_repository_impl.dart';
import 'package:parallel_universe/features/universe_generation/presentation/manager/universe_generation_view_model.dart';
import 'package:parallel_universe/features/universe_generation/data/datasources/universe_local_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:parallel_universe/features/dashboard/presentation/manager/travel_history_view_model.dart';
import 'package:parallel_universe/features/future_self/data/datasources/future_chat_remote_data_source.dart';
import 'package:parallel_universe/features/future_self/data/datasources/future_chat_local_data_source.dart';
import 'package:parallel_universe/features/future_self/data/repositories/future_chat_repository_impl.dart';
import 'package:parallel_universe/features/future_self/presentation/manager/future_chat_view_model.dart';
import 'package:parallel_universe/features/dashboard/presentation/manager/settings_view_model.dart';
import 'package:parallel_universe/features/life_interview/presentation/manager/life_interview_view_model.dart';
import 'package:parallel_universe/features/life_interview/data/datasources/smart_memory_local_data_source.dart';
import 'package:parallel_universe/features/life_interview/data/datasources/life_interview_remote_data_source.dart';
import 'package:parallel_universe/features/life_interview/data/repositories/life_interview_repository_impl.dart';

class DI {
  static late final AuthViewModel authViewModel;
  static late final DashboardViewModel dashboardViewModel;
  static late final ChatListViewModel chatListViewModel;
  static late final ChatViewModel chatViewModel;
  static late final UniverseGenerationViewModel universeGenerationViewModel;
  static late final FutureChatViewModel futureChatViewModel;
  static late final SettingsViewModel settingsViewModel;
  static late final TravelHistoryViewModel travelHistoryViewModel;
  static late final LifeInterviewViewModel lifeInterviewViewModel;

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Auth
    final authRemoteDataSource = AuthRemoteDataSource(FirebaseAuth.instance, GoogleSignIn.instance);
    final authRepository = AuthRepositoryImpl(authRemoteDataSource);
    authViewModel = AuthViewModel(authRepository);

    // Dashboard
    final dashboardRemoteDataSource = DashboardRemoteDataSource();
    final dashboardRepository = DashboardRepositoryImpl(dashboardRemoteDataSource);
    dashboardViewModel = DashboardViewModel(dashboardRepository);

    // Chat
    final chatRemoteDataSource = ChatRemoteDataSource();
    final chatRepository = ChatRepositoryImpl(chatRemoteDataSource);
    chatListViewModel = ChatListViewModel(chatRepository);
    chatViewModel = ChatViewModel(chatRepository);

    // Life Interview
    final smartMemoryLocalDataSource = SmartMemoryLocalDataSource(prefs);
    final lifeInterviewRemoteDataSource = LifeInterviewRemoteDataSource();
    final lifeInterviewRepository = LifeInterviewRepositoryImpl(lifeInterviewRemoteDataSource, smartMemoryLocalDataSource);
    lifeInterviewViewModel = LifeInterviewViewModel(lifeInterviewRepository);

    // Universe Generation
    final universeRemoteDataSource = UniverseRemoteDataSource();
    final universeLocalDataSource = UniverseLocalDataSourceImpl(prefs);
    final universeRepository = UniverseRepositoryImpl(universeRemoteDataSource, universeLocalDataSource);
    universeGenerationViewModel = UniverseGenerationViewModel(universeRepository, lifeInterviewRepository);
    travelHistoryViewModel = TravelHistoryViewModel(universeRepository);

    // Future Self Chat
    final futureRemoteDataSource = FutureChatRemoteDataSource();
    final futureLocalDataSource = FutureChatLocalDataSource(prefs);
    final futureRepository = FutureChatRepositoryImpl(futureRemoteDataSource, futureLocalDataSource);
    futureChatViewModel = FutureChatViewModel(futureRepository, lifeInterviewRepository);

    // Settings
    settingsViewModel = SettingsViewModel(prefs);
  }
}
