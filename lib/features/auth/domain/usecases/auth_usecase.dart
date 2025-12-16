import 'package:kinopoisk/features/auth/data/auth_repository.dart';
import 'package:kinopoisk/features/auth/data/models/auth_user.dart';

class AuthUseCase {
  final AuthRepository repository;
  AuthUseCase(this.repository);

  Future<AuthUser?> login(String email, String password) {
    return repository.login(email, password);
  }

  Future<void> logout() {
    return repository.logout();
  }
}
