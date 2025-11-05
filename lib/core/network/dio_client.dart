import 'package:dio/dio.dart';
import '../config/api_config.dart';

class CloudClient {
  CloudClient({Dio? client, String? baseUrl, String? apiKey})
      : _client = client ?? Dio(),
        _baseUrl = baseUrl ?? ApiConfig.baseUrl,
        _apiKey = apiKey ?? ApiConfig.apiKey {
    _setupClient();
  }

  final Dio _client;
  final String _baseUrl;
  final String _apiKey;

  void _setupClient() {
    _client.options = BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json',
      },
    );
  }

  Future<Response> get(String path, {Map<String, dynamic>? query}) async {
    return _client.get(path, queryParameters: query);
  }

  // Пример метода для получения списка фильмов
  Future<Response> getMoviesList(String category, {int page = 1}) async {
    return get('/movie/$category', query: {'page': page});
  }
}