import 'package:flutter/material.dart';
import 'package:parallel_universe/core/di/dependency_injection.dart';
import 'package:parallel_universe/core/routing/app_router.dart';
import 'package:parallel_universe/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:parallel_universe/features/auth/presentation/widgets/primary_auth_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _viewModel = DI.authViewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTextField(
                    label: 'Name',
                    prefixIcon: Icons.person,
                    controller: _nameController,
                    validator: (val) => val == null || val.isEmpty ? 'Enter name' : null,
                  ),
                  const SizedBox(height: 16),
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
                  const SizedBox(height: 32),
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
                            text: 'Sign Up',
                            isLoading: _viewModel.isLoading,
                            onPressed: () async {
                              if (_formKey.currentState?.validate() ?? false) {
                                final success = await _viewModel.register(
                                  _nameController.text,
                                  _emailController.text,
                                  _passwordController.text,
                                );
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
                                final success = await _viewModel.signInWithGoogle();
                                if (success && mounted) {
                                  Navigator.pushReplacementNamed(context, AppRouter.home);
                                }
                              },
                              icon: const Icon(Icons.g_mobiledata, size: 28),
                              label: const Text('Sign up with Google'),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
