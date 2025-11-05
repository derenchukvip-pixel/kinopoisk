import '../models/user.dart';

abstract class UserRepository {
  Future<User> getUserInfo();
  Future<User> login(String username, String password);
  Future<void> logout();
}
