import 'package:parallel_universe/features/auth/domain/entities/user_entity.dart';

abstract class IAuthRepository {
  Stream<UserEntity?> get authStateChanges;
  Future<UserEntity?> getCurrentUser();
  Future<UserEntity> login(String email, String password);
  Future<UserEntity> register(String name, String email, String password);
  Future<UserEntity> signInWithGoogle();
  Future<void> sendPasswordReset(String email);
  Future<bool> verifyOtp(String email, String otp);
  Future<void> logout();
}
