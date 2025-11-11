import 'package:dio/dio.dart';

class TmdbApiService {
  final Dio dio;
  final String apiKey;
  final String baseUrl;

  TmdbApiService({required this.dio, required this.apiKey, this.baseUrl = 'https://api.themoviedb.org/3'});

  Future<List<Map<String, dynamic>>> getGenres() async {
    final response = await dio.get('$baseUrl/genre/movie/list', queryParameters: {'api_key': apiKey});
    final genres = response.data['genres'] as List?;
    if (genres == null) return [];
    return genres.map((g) => {'id': g['id'], 'name': g['name']}).toList();
  }

  Future<List<String>> getCountries() async {
    final response = await dio.get('$baseUrl/configuration/countries', queryParameters: {'api_key': apiKey});
    final countries = response.data as List?;
    if (countries == null) return [];
    return countries.map<String>((c) => c['english_name'] as String).toList();
  }

  Future<List<String>> getLanguages() async {
    final response = await dio.get('$baseUrl/configuration/languages', queryParameters: {'api_key': apiKey});
    final languages = response.data as List?;
    if (languages == null) return [];
    return languages.map<String>((l) => l['english_name'] as String).toList();
  }

  List<String> getSortOptions() {
    return [
      'popularity.desc',
      'popularity.asc',
      'release_date.desc',
      'release_date.asc',
      'vote_average.desc',
      'vote_average.asc',
    ];
  }
}
