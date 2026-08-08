import 'package:parallel_universe/core/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:parallel_universe/core/di/dependency_injection.dart';
import 'tabs/explore_tab.dart';
import 'tabs/home_feed_tab.dart';
import 'tabs/profile_tab.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _viewModel = DI.dashboardViewModel;

  @override
  void initState() {
    super.initState();
    // Fetch initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.setTabIndex(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Parallel Universe'),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications), 
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                    builder: (context) {
                      return const SizedBox(
                        height: 200,
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            'Your future selves have no new messages for you.',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
          body: IndexedStack(
            index: _viewModel.currentIndex,
            children: [
              HomeFeedTab(viewModel: _viewModel),
              ExploreTab(viewModel: _viewModel),
              const ProfileTab(),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              debugPrint('[DashboardScreen] Start Chat FAB pressed');
              Navigator.pushNamed(context, AppRouter.chatList);
            },
            icon: const Icon(Icons.chat_bubble),
            label: const Text('Start Chat'),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _viewModel.currentIndex,
            onTap: _viewModel.setTabIndex,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Feed'),
              BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            ],
          ),
        );
      },
    );
  }
}
