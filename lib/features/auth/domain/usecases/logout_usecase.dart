import 'package:kinopoisk/features/auth/data/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository repository;
  LogoutUseCase(this.repository);

  Future<void> logout() {
    return repository.logout();
  }
}
