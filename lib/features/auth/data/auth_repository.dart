import 'models/auth_user.dart';

abstract class AuthRepository {
  Future<AuthUser?> login(String email, String password);
  Future<void> logout();
  Future<AuthUser?> getCurrentUser();
}
