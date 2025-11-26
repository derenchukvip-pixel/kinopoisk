import 'package:kinopoisk/features/auth/data/auth_repository.dart';
import 'package:kinopoisk/features/auth/data/models/auth_user.dart';

class LoginUseCase {
  final AuthRepository repository;
  LoginUseCase(this.repository);

  Future<AuthUser?> login(String email, String password) {
    return repository.login(email, password);
  }
}
