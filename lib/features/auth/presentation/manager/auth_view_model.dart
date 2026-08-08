import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:parallel_universe/features/auth/domain/entities/user_entity.dart';
import 'package:parallel_universe/features/auth/domain/repositories/i_auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final IAuthRepository _repository;
  StreamSubscription? _authSubscription;

  AuthViewModel(this._repository) {
    _authSubscription = _repository.authStateChanges.listen((user) {
      _currentUser = user;
      notifyListeners();
    });
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  UserEntity? _currentUser;
  UserEntity? get currentUser => _currentUser;

  bool get isAuthenticated => _currentUser != null;

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    if (value) _errorMessage = null;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    debugPrint('[AuthViewModel] login called with email: $email');
    _setLoading(true);
    try {
      await _repository.login(email, password);
      _setLoading(false);
      return true;
    } catch (e, stackTrace) {
      debugPrint('[AuthViewModel] login exception caught!');
      debugPrint('Type: ${e.runtimeType}');
      debugPrint('Message: $e');
      debugPrint('Stack Trace: $stackTrace');
      if (e is FirebaseAuthException) {
        debugPrint('Firebase Code: ${e.code}');
        debugPrint('Firebase Message: ${e.message}');
        debugPrint('Firebase Plugin: ${e.plugin}');
      }
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _setLoading(true);
    try {
      await _repository.register(name, email, password);
      _setLoading(false);
      return true;
    } catch (e, stackTrace) {
      debugPrint('Registration Error: $e');
      debugPrint('Stack Trace: $stackTrace');
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    _setLoading(true);
    try {
      await _repository.signInWithGoogle();
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> sendPasswordReset(String email) async {
    _setLoading(true);
    try {
      await _repository.sendPasswordReset(email);
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> verifyOtp(String email, String otp) async {
    _setLoading(true);
    try {
      final success = await _repository.verifyOtp(email, otp);
      _setLoading(false);
      return success;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _setLoading(false);
      return false;
    }
  }

  Future<void> logout() async {
    await _repository.logout();
  }
}
