import '../../data/repositories/movie_repository.dart';
import '../../data/models/movie.dart';

class GetNowPlayingMoviesUseCase {
  final MovieRepository repository;

  GetNowPlayingMoviesUseCase(this.repository);

  Future<List<Movie>> call() async {
    return await repository.getNowPlaying();
  }
}