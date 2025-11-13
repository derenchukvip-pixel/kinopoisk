import 'package:dio/dio.dart';
import '../models/sort_option.dart';
import '../models/genre.dart';

// The SortOption enum and SortOptionExt extension have been moved to sort_option.dart

class TmdbApiService {
  final Dio dio;
  final String apiKey;
  final String baseUrl;

  TmdbApiService({required this.dio, required this.apiKey, this.baseUrl = 'https://api.themoviedb.org/3'}) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Добавляем baseUrl, если путь относительный
          if (!options.path.startsWith('http')) {
            options.path = baseUrl + options.path;
          }
          // Добавляем api_key ко всем запросам
          options.queryParameters['api_key'] = apiKey;
          handler.next(options);
        },
      ),
    );
  }

  Future<List<Genre>> getGenres() async {
    final response = await dio.get('/genre/movie/list');
    final genres = response.data['genres'] as List?;
    if (genres == null) return [];
    return genres.map((g) => Genre.fromJson(g)).toList();
  }

  Future<List<String>> getCountries() async {
    final response = await dio.get('/configuration/countries');
    final countries = response.data as List?;
    if (countries == null) return [];
    return countries.map<String>((c) => c['english_name'] as String).toList();
  }

  Future<List<String>> getLanguages() async {
    final response = await dio.get('/configuration/languages');
    final languages = response.data as List?;
    if (languages == null) return [];
    return languages.map<String>((l) => l['english_name'] as String).toList();
  }

  List<SortOption> getSortOptions() {
    return [
      SortOption.popularityDesc,
      SortOption.popularityAsc,
      SortOption.releaseDateDesc,
      SortOption.releaseDateAsc,
      SortOption.voteAverageDesc,
      SortOption.voteAverageAsc,
    ];
  }
}
