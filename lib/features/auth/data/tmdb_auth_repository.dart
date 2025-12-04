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
    try {
      // 1. Get request token
      final tokenResp = await _dio.get('$_baseUrl/authentication/token/new?api_key=$apiKey');
      if (tokenResp.statusCode != 200) {
        print('[TMDBAuth] Request token error: status=${tokenResp.statusCode}, body=${tokenResp.data}');
        throw Exception('Failed to get request token: ${tokenResp.data}');
      }
  final tokenData = tokenResp.data is Map ? tokenResp.data : jsonDecode(tokenResp.data);
  final requestToken = tokenData['request_token'];

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
      if (validateResp.statusCode != 200) {
        print('[TMDBAuth] Validate login error: status=${validateResp.statusCode}, body=${validateResp.data}');
        throw Exception('Invalid credentials: ${validateResp.data}');
      }

      // 3. Create session
      final sessionResp = await _dio.post(
        '$_baseUrl/authentication/session/new?api_key=$apiKey',
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: jsonEncode({'request_token': requestToken}),
      );
      if (sessionResp.statusCode != 200) {
        print('[TMDBAuth] Create session error: status=${sessionResp.statusCode}, body=${sessionResp.data}');
        throw Exception('Failed to create session: ${sessionResp.data}');
      }
      final sessionData = sessionResp.data is Map ? sessionResp.data : jsonDecode(sessionResp.data);
      _sessionId = sessionData['session_id'];

      // 4. Get account details
      final accountResp = await _dio.get(
        '$_baseUrl/account?api_key=$apiKey&session_id=$_sessionId',
      );
      if (accountResp.statusCode != 200) {
        print('[TMDBAuth] Account details error: status=${accountResp.statusCode}, body=${accountResp.data}');
        throw Exception('Failed to get account details: ${accountResp.data}');
      }
      final data = accountResp.data is Map ? accountResp.data : jsonDecode(accountResp.data);
      String? avatarUrl;
      if (data['avatar'] != null &&
          data['avatar']['tmdb'] != null &&
          data['avatar']['tmdb']['avatar_path'] != null) {
        final path = data['avatar']['tmdb']['avatar_path'] as String?;
        if (path != null && path.isNotEmpty) {
          avatarUrl = 'https://image.tmdb.org/t/p/w185$path';
        }
      }
      return AuthUser(
        id: data['id'].toString(),
        email: data['username'] ?? username,
        name: data['name'],
        token: _sessionId,
        avatarUrl: avatarUrl,
      );
    } catch (e, stack) {
      print('[TMDBAuth] Exception: $e\n$stack');
      rethrow;
    }
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
