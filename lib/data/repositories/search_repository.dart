import 'package:kinopoisk/data/models/tv_show.dart';
import '../models/movie.dart';
import '../models/keyword.dart';

abstract class MovieRepository {
  Future<List<Movie>> searchMovies(String query);
  Future<List<TVShow>> searchTVShows(String query);
  Future<List<Keyword>> searchKeywords(String query);
}
