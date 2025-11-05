import '../models/movie.dart';

abstract class MovieRepository {
  Future<List<Movie>> getNowPlaying();
  Future<List<Movie>> getPopular();
  Future<List<Movie>> getTopRated();
  Future<List<Movie>> getUpcoming();
  Future<Movie> getMovieDetails(int id);
}
