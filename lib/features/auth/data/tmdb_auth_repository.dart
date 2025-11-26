import 'dart:convert';
import 'package:dio/dio.dart';
import 'models/auth_user.dart';
import 'auth_repository.dart';

class TMDBAuthRepository implements AuthRepository {
  final String apiKey;
  static const _baseUrl = 'https://api.themoviedb.org/3';
  final Dio _dio = Dio();

  TMDBAuthRepository(this.apiKey);

  String? _sessionId;
  AuthUser? _currentUser;

  @override
  Future<AuthUser?> login(String username, String password) async {
    // 1. Get request token
    final tokenResp = await _dio.get('$_baseUrl/authentication/token/new?api_key=$apiKey');
    if (tokenResp.statusCode != 200) throw Exception('Failed to get request token');
    final requestToken = jsonDecode(tokenResp.data)['request_token'];

    // 2. Validate token with login
    final validateResp = await _dio.post(
      '$_baseUrl/authentication/token/validate_with_login?api_key=$apiKey',
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: jsonEncode({
        'username': username,
        'password': password,
        'request_token': requestToken,
      }),
    );
    if (validateResp.statusCode != 200) throw Exception('Invalid credentials');

    // 3. Create session
    final sessionResp = await _dio.post(
      '$_baseUrl/authentication/session/new?api_key=$apiKey',
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: jsonEncode({'request_token': requestToken}),
    );
    if (sessionResp.statusCode != 200) throw Exception('Failed to create session');
    _sessionId = jsonDecode(sessionResp.data)['session_id'];

    // 4. Get account details
    final accountResp = await _dio.get(
      '$_baseUrl/account?api_key=$apiKey&session_id=$_sessionId',
    );
    if (accountResp.statusCode != 200) throw Exception('Failed to get account details');
    final data = jsonDecode(accountResp.data);
    String? avatarUrl;
    if (data['avatar'] != null && data['avatar']['tmdb'] != null && data['avatar']['tmdb']['avatar_path'] != null) {
      final path = data['avatar']['tmdb']['avatar_path'] as String?;
      if (path != null && path.isNotEmpty) {
        avatarUrl = 'https://image.tmdb.org/t/p/w185$path';
      }
    }
    _currentUser = AuthUser(
      id: data['id'].toString(),
      email: data['username'],
      name: data['name'],
      token: _sessionId,
      avatarUrl: avatarUrl,
    );
    return _currentUser;
  }

  @override
  Future<void> logout() async {
    if (_sessionId == null) return;
    await _dio.delete(
      '$_baseUrl/authentication/session?api_key=$apiKey',
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: jsonEncode({'session_id': _sessionId}),
    );
    _sessionId = null;
    _currentUser = null;
  }

  @override
  Future<AuthUser?> getCurrentUser() async {
    return _currentUser;
  }
}
