import '../models/tv_show.dart';

abstract class TVShowRepository {
  Future<List<TVShow>> getAiringToday();
  Future<List<TVShow>> getPopular();
  Future<List<TVShow>> getTopRated();
  Future<List<TVShow>> getOnTheAir();
  Future<TVShow> getTvShowDetails(int id);
}
