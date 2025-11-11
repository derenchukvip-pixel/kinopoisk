import 'package:dio/dio.dart';
import 'package:kinopoisk/data/models/movie.dart';
import 'package:kinopoisk/data/models/tv_show.dart';
import 'package:kinopoisk/data/models/keyword.dart';
import 'search_repository.dart';
import 'package:kinopoisk/data/models/filter_options.dart';

class SearchRepositoryImpl implements SearchRepository {
  final Dio dio;
  final String baseUrl;
  final String apiKey;

  SearchRepositoryImpl({required this.dio, required this.baseUrl, required this.apiKey});

  @override
  Future<List<Movie>> searchMovies(String query, {int page = 1, FilterOptions? filters}) async {
    final params = {
      'api_key': apiKey,
      'page': page,
      'include_adult': false,
    };
    if (query.isNotEmpty) {
      params['query'] = query;
    }
    // Если есть фильтры, используем discover/movie
    bool hasFilters = filters != null && (
      (filters.genreIds.isNotEmpty) ||
      filters.year != null ||
      filters.minRating != null ||
      filters.maxRating != null ||
      filters.country != null ||
      filters.language != null ||
      filters.sortBy != null
    );
    if (filters != null) {
      if (filters.genreIds.isNotEmpty) params['with_genres'] = filters.genreIds.join(',');
      if (filters.year != null) params['year'] = filters.year.toString();
      if (filters.minRating != null) params['vote_average.gte'] = filters.minRating.toString();
      if (filters.maxRating != null) params['vote_average.lte'] = filters.maxRating.toString();
      if (filters.country != null) params['region'] = filters.country!;
      if (filters.language != null) params['with_original_language'] = filters.language!;
      if (filters.sortBy != null) params['sort_by'] = filters.sortBy!;
    }
    final endpoint = hasFilters ? '/discover/movie' : '/search/movie';
    if (query.isNotEmpty && !hasFilters) {
      params['query'] = query;
    }
    final response = await dio.get(
      '$baseUrl$endpoint',
      queryParameters: params,
    );
    final results = response.data['results'] as List;
    return results.map((json) => Movie.fromJson(json)).toList();
  }


  @override
  Future<List<TVShow>> searchTVShows(String query, {int page = 1}) async {
    final response = await dio.get(
      '$baseUrl/search/tv',
      queryParameters: {
        'api_key': apiKey,
        'query': query,
        'page': page,
      },
    );
    final results = response.data['results'] as List;
    return results.map((json) => TVShow.fromJson(json)).toList();
  }

  @override
  Future<List<Keyword>> searchKeywords(String query, {int page = 1}) async {
    final response = await dio.get(
      '$baseUrl/search/keyword',
      queryParameters: {
        'api_key': apiKey,
        'query': query,
        'page': page,
      },
    );
    final results = response.data['results'] as List;
    return results.map((json) => Keyword(
      id: json['id'],
      name: json['name'] ?? '',
    )).toList();
  }
}
