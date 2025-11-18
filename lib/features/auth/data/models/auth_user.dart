class AuthUser {
  final String id;
  final String email;
  final String? name;
  final String? token;
  final String? avatarUrl;

  AuthUser({
    required this.id,
    required this.email,
    this.name,
    this.token,
    this.avatarUrl,
  });
}
