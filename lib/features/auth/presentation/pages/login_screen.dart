import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:parallel_universe/core/di/dependency_injection.dart';
import 'package:parallel_universe/core/routing/app_router.dart';
import 'package:parallel_universe/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:parallel_universe/features/auth/presentation/widgets/primary_auth_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _viewModel = DI.authViewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_outline, size: 80, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(height: 32),
                  Text('Welcome Back', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 32),
                  CustomTextField(
                    label: 'Email',
                    prefixIcon: Icons.email,
                    controller: _emailController,
                    validator: (val) => val == null || val.isEmpty ? 'Enter email' : null,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'Password',
                    prefixIcon: Icons.lock,
                    obscureText: true,
                    controller: _passwordController,
                    validator: (val) => val == null || val.isEmpty ? 'Enter password' : null,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.pushNamed(context, AppRouter.forgotPassword),
                      child: const Text('Forgot Password?'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ListenableBuilder(
                    listenable: _viewModel,
                    builder: (context, _) {
                      return Column(
                        children: [
                          if (_viewModel.errorMessage != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Text(_viewModel.errorMessage!, style: const TextStyle(color: Colors.red)),
                            ),
                          PrimaryAuthButton(
                            text: 'Login',
                            isLoading: _viewModel.isLoading,
                            onPressed: () async {
                              if (_formKey.currentState?.validate() ?? false) {
                                debugPrint('[LoginScreen] Login button pressed, calling ViewModel.login()');
                                final success = await _viewModel.login(_emailController.text, _passwordController.text);
                                if (success && mounted) {
                                  Navigator.pushReplacementNamed(context, AppRouter.home);
                                }
                              }
                            },
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: _viewModel.isLoading ? null : () async {
                                if (kIsWeb) {
                                  // Mock Google Account Chooser for Web Prototype
                                  final chosenEmail = await showDialog<String>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Choose an account\nto continue to Parallel Universe', style: TextStyle(fontSize: 18)),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ListTile(
                                            leading: const CircleAvatar(backgroundColor: Colors.blue, child: Text('G', style: TextStyle(color: Colors.white))),
                                            title: const Text('Google Test 1', style: TextStyle(fontWeight: FontWeight.bold)),
                                            subtitle: const Text('google1@paralleluniverse.com'),
                                            onTap: () => Navigator.pop(context, 'google1@paralleluniverse.com'),
                                          ),
                                          const Divider(),
                                          ListTile(
                                            leading: const CircleAvatar(backgroundColor: Colors.orange, child: Text('G', style: TextStyle(color: Colors.white))),
                                            title: const Text('Google Test 2', style: TextStyle(fontWeight: FontWeight.bold)),
                                            subtitle: const Text('google2@paralleluniverse.com'),
                                            onTap: () => Navigator.pop(context, 'google2@paralleluniverse.com'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );

                                  if (chosenEmail != null && mounted) {
                                    // Use the fallback logic to mock authentication
                                    final success = await _viewModel.login(chosenEmail, 'password123');
                                    if (!success && mounted) {
                                      // If login fails (user not found), register them
                                      final regSuccess = await _viewModel.register(chosenEmail.split('@').first, chosenEmail, 'password123');
                                      if (regSuccess && mounted) {
                                        Navigator.pushReplacementNamed(context, AppRouter.home);
                                      }
                                    } else if (success && mounted) {
                                      Navigator.pushReplacementNamed(context, AppRouter.home);
                                    }
                                  }
                                } else {
                                  // Normal Google Sign In for Mobile
                                  final success = await _viewModel.signInWithGoogle();
                                  if (success && mounted) {
                                    Navigator.pushReplacementNamed(context, AppRouter.home);
                                  }
                                }
                              },
                              icon: const Icon(Icons.g_mobiledata, size: 28),
                              label: const Text('Sign in with Google'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(context, AppRouter.register),
                        child: const Text('Sign Up'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
