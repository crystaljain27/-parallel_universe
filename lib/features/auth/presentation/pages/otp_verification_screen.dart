import 'package:flutter/material.dart';
import 'package:parallel_universe/core/di/dependency_injection.dart';
import 'package:parallel_universe/core/routing/app_router.dart';
import 'package:parallel_universe/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:parallel_universe/features/auth/presentation/widgets/primary_auth_button.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;
  const OtpVerificationScreen({super.key, required this.email});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _viewModel = DI.authViewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Enter the 4-digit code sent to\n${widget.email}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(
                    label: 'OTP Code',
                    prefixIcon: Icons.lock_clock,
                    controller: _otpController,
                    validator: (val) => val == null || val.length != 4 ? 'Enter 4-digit code' : null,
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
                            text: 'Verify',
                            isLoading: _viewModel.isLoading,
                            onPressed: () async {
                              if (_formKey.currentState?.validate() ?? false) {
                                final success = await _viewModel.verifyOtp(widget.email, _otpController.text);
                                if (success && mounted) {
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    AppRouter.login,
                                    (route) => false,
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
