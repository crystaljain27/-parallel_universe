import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

class AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRemoteDataSource(this._firebaseAuth, this._googleSignIn);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  User? get currentUser => _firebaseAuth.currentUser;

  Future<User> login(String email, String password) async {
    debugPrint('[AuthRemoteDataSource] login called');
    try {
      debugPrint('[AuthRemoteDataSource] Calling _firebaseAuth.signInWithEmailAndPassword...');
      final result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (result.user == null) {
        debugPrint('[AuthRemoteDataSource] result.user is null');
        throw Exception('Login failed');
      }
      return result.user!;
    } on FirebaseAuthException catch (e, stackTrace) {
      debugPrint('[AuthRemoteDataSource] FirebaseAuthException caught!');
      debugPrint('Code: ${e.code}');
      debugPrint('Message: ${e.message}');
      debugPrint('Stack Trace: $stackTrace');
      rethrow;
    } catch (e, stackTrace) {
      debugPrint('[AuthRemoteDataSource] Generic exception caught!');
      debugPrint('Type: ${e.runtimeType}');
      debugPrint('Message: $e');
      debugPrint('Stack Trace: $stackTrace');
      rethrow;
    }
  }

  Future<User> register(String name, String email, String password) async {
    final result = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (result.user == null) throw Exception('Registration failed');
    await result.user!.updateDisplayName(name);
    return result.user!;
  }

  Future<User> signInWithGoogle() async {
    if (kIsWeb) {
      debugPrint('[AuthRemoteDataSource] Mocking Google Sign-In for Web');
      await Future.delayed(const Duration(seconds: 1));
      try {
        return await login('crystaljain2711@gmail.com', 'password123');
      } catch (_) {
        return await register('Crystal', 'crystaljain2711@gmail.com', 'password123');
      }
    }

    final GoogleSignInAccount? googleUser = await _googleSignIn.authenticate();
    
    if (googleUser == null) {
      throw Exception('Google Sign-In canceled');
    }
    
    // In v7, authentication is synchronous
    final googleAuth = googleUser.authentication;
    
    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );
    
    final result = await _firebaseAuth.signInWithCredential(credential);
    if (result.user == null) throw Exception('Google Sign-In failed');
    return result.user!;
  }

  String? _lastOtp;

  Future<void> sendPasswordReset(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<bool> verifyOtp(String email, String otp) async {
    await Future.delayed(const Duration(seconds: 1));
    return _lastOtp != null && otp == _lastOtp;
  }

  Future<void> logout() async {
    debugPrint('[AuthRemoteDataSource] Executing Firebase signOut');
    try {
      await _firebaseAuth.signOut();
      debugPrint('[AuthRemoteDataSource] Firebase signOut complete');
    } catch (e) {
      debugPrint('[AuthRemoteDataSource] Firebase signOut error: $e');
    }

    debugPrint('[AuthRemoteDataSource] Executing Google signOut');
    try {
      await _googleSignIn.signOut().timeout(const Duration(seconds: 2));
      debugPrint('[AuthRemoteDataSource] Google signOut complete');
    } catch (e) {
      debugPrint('[AuthRemoteDataSource] Google signOut error/timeout: $e');
    }
  }
}
