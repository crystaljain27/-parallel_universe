import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:parallel_universe/features/auth/domain/entities/user_entity.dart';
import 'package:parallel_universe/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:parallel_universe/features/auth/data/datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  UserEntity _mapUser(User user) {
    return UserEntity(
      id: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? 'Explorer',
    );
  }

  @override
  Stream<UserEntity?> get authStateChanges {
    return _remoteDataSource.authStateChanges.map((user) {
      if (user == null) return null;
      return _mapUser(user);
    });
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final user = _remoteDataSource.currentUser;
    if (user == null) return null;
    return _mapUser(user);
  }

  @override
  Future<UserEntity> login(String email, String password) async {
    debugPrint('[AuthRepositoryImpl] login called');
    try {
      final user = await _remoteDataSource.login(email, password);
      return _mapUser(user);
    } on FirebaseAuthException catch (e, stackTrace) {
      debugPrint('[AuthRepositoryImpl] FirebaseAuthException caught!');
      debugPrint('Code: ${e.code}');
      debugPrint('Message: ${e.message}');
      debugPrint('Plugin: ${e.plugin}');
      debugPrint('Stack Trace: $stackTrace');
      rethrow;
    } catch (e, stackTrace) {
      debugPrint('[AuthRepositoryImpl] Generic exception caught!');
      debugPrint('Type: ${e.runtimeType}');
      debugPrint('Message: $e');
      debugPrint('Stack Trace: $stackTrace');
      throw Exception('Failed to login: $e');
    }
  }

  @override
  Future<UserEntity> register(String name, String email, String password) async {
    try {
      final user = await _remoteDataSource.register(name, email, password);
      return _mapUser(user);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? e.toString());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<UserEntity> signInWithGoogle() async {
    try {
      final user = await _remoteDataSource.signInWithGoogle();
      return _mapUser(user);
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseError(e));
    } catch (e) {
      throw Exception('Google Sign-In failed: $e');
    }
  }

  @override
  Future<void> sendPasswordReset(String email) async {
    try {
      await _remoteDataSource.sendPasswordReset(email);
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseError(e));
    }
  }

  @override
  Future<bool> verifyOtp(String email, String otp) async {
    return await _remoteDataSource.verifyOtp(email, otp);
  }

  @override
  Future<void> logout() async {
    await _remoteDataSource.logout();
  }

  String _mapFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'email-already-in-use':
        return 'An account already exists for this email.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'The password provided is too weak.';
      default:
        return e.message ?? 'An unknown authentication error occurred.';
    }
  }
}
