import '../../data/repositories/movie_repository.dart';
import '../../data/models/movie.dart';

class GetUpcomingMoviesUseCase {
  final MovieRepository repository;

  GetUpcomingMoviesUseCase(this.repository);

  Future<List<Movie>> movieRepository() async {
    return await repository.getUpcoming();
  }
}