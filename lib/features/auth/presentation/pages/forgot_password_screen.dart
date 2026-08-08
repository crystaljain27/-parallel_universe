import 'package:flutter/material.dart';
import 'package:parallel_universe/core/di/dependency_injection.dart';
import 'package:parallel_universe/core/routing/app_router.dart';
import 'package:parallel_universe/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:parallel_universe/features/auth/presentation/widgets/primary_auth_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _viewModel = DI.authViewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Enter your email to receive a password reset code.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(
                    label: 'Email',
                    prefixIcon: Icons.email,
                    controller: _emailController,
                    validator: (val) => val == null || val.isEmpty ? 'Enter email' : null,
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
                            text: 'Send Reset Code',
                            isLoading: _viewModel.isLoading,
                              onPressed: () async {
                                if (_formKey.currentState?.validate() ?? false) {
                                  final success = await _viewModel.sendPasswordReset(_emailController.text);
                                  if (success && mounted) {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Email Sent'),
                                        content: const Text(
                                          'A password reset link has been sent to your email. Please check your inbox and click the link to reset your password.',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context); // Close dialog
                                              Navigator.pop(context); // Go back to login
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                }
                              },
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
