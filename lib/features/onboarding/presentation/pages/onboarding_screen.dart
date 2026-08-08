import 'package:flutter/material.dart';
import 'package:parallel_universe/core/routing/app_router.dart';
import 'package:parallel_universe/features/onboarding/presentation/widgets/dot_indicator.dart';
import 'package:parallel_universe/features/onboarding/presentation/widgets/onboarding_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      "icon": Icons.language,
      "title": "Discover New Realities",
      "description": "Step through the portal and explore infinite dimensions tailored to your imagination.",
    },
    {
      "icon": Icons.people_alt,
      "title": "Connect Across Worlds",
      "description": "Find and interact with alternate versions of yourself across the multiverse.",
    },
    {
      "icon": Icons.speed,
      "title": "Seamless Travel",
      "description": "Experience zero-latency shifts between parallel universes with our quantum routing.",
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  return OnboardingPage(
                    icon: _onboardingData[index]["icon"],
                    title: _onboardingData[index]["title"],
                    description: _onboardingData[index]["description"],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: List.generate(
                      _onboardingData.length,
                      (index) => DotIndicator(isActive: index == _currentPage),
                    ),
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _currentPage == _onboardingData.length - 1
                        ? ElevatedButton(
                            key: const ValueKey('start'),
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, AppRouter.login);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                            ),
                            child: const Text('Get Started'),
                          )
                        : TextButton(
                            key: const ValueKey('next'),
                            onPressed: () {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeIn,
                              );
                            },
                            child: const Text('Next'),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
