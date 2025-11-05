import 'package:dio/dio.dart';
import '../models/movie.dart';
import 'movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  final Dio dio;
  final String baseUrl;
  final String apiKey;

  MovieRepositoryImpl({required this.dio, required this.baseUrl, required this.apiKey});

  @override
  Future<List<Movie>> getNowPlaying() async {
    final response = await dio.get('$baseUrl/movie/now_playing', queryParameters: {'api_key': apiKey});
    final results = response.data['results'] as List;
    return results.map((json) => Movie.fromJson(json)).toList();
  }

  @override
  Future<List<Movie>> getPopular() async {
    final response = await dio.get('$baseUrl/movie/popular', queryParameters: {'api_key': apiKey});
    final results = response.data['results'] as List;
    return results.map((json) => Movie.fromJson(json)).toList();
  }

  @override
  Future<List<Movie>> getTopRated() async {
    final response = await dio.get('$baseUrl/movie/top_rated', queryParameters: {'api_key': apiKey});
    final results = response.data['results'] as List;
    return results.map((json) => Movie.fromJson(json)).toList();
  }

  @override
  Future<List<Movie>> getUpcoming() async {
    final response = await dio.get('$baseUrl/movie/upcoming', queryParameters: {'api_key': apiKey});
    final results = response.data['results'] as List;
    return results.map((json) => Movie.fromJson(json)).toList();
  }

  @override
  Future<Movie> getMovieDetails(int id) async {
    final response = await dio.get('$baseUrl/movie/$id', queryParameters: {'api_key': apiKey});
    return Movie.fromJson(response.data);
  }
}
