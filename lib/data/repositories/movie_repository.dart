import 'package:kinopoisk/data/models/movie_details.dart';

import '../models/movie.dart';

abstract class MovieRepository {
  Future<List<Movie>> getNowPlaying();
  Future<List<Movie>> getPopular();
  Future<List<Movie>> getTopRated();
  Future<List<Movie>> getUpcoming();
  Future<MovieDetails> getMovieDetails(int id);
}
