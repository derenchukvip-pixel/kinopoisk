import '../../data/repositories/movie_repository.dart';
import '../../data/models/movie.dart';

class GetPopularMoviesUseCase {
  final MovieRepository repository;

  GetPopularMoviesUseCase(this.repository);

  Future<List<Movie>> movieRepository() async {
    return await repository.getPopular();
  }
}