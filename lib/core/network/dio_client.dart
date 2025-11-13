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
      queryParameters: {}
    );
  }


  // Пример метода для получения списка фильмов
  Future<Response> getMoviesList(String category, {int page = 1}) async {
    return _client.get('/movie/$category', queryParameters: {'page': page});
  }
}