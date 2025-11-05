import '../../data/repositories/movie_repository.dart';
import '../../data/models/movie.dart';

class GetTopRatedMoviesUseCase {
  final MovieRepository repository;

  GetTopRatedMoviesUseCase(this.repository);

  Future<List<Movie>> call() async {
    return await repository.getTopRated();
  }
}