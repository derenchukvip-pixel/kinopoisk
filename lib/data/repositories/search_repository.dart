import 'package:kinopoisk/data/models/filter_options.dart';
import 'package:kinopoisk/data/models/tv_show.dart';
import 'package:kinopoisk/data/models/movie.dart';
import 'package:kinopoisk/data/models/keyword.dart';

abstract class SearchRepository {
  Future<List<Movie>> searchMovies(String query, {int page, FilterOptions? filters});
  Future<List<TVShow>> searchTVShows(String query, {int page});
  Future<List<Keyword>> searchKeywords(String query, {int page});
}
