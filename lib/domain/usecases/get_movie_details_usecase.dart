import 'package:kinopoisk/data/models/movie_details.dart';

import 'package:kinopoisk/data/repositories/movie_repository.dart';

class GetMovieDetailsUseCase {
  final MovieRepository repository;

  GetMovieDetailsUseCase(this.repository);

  Future<MovieDetails> movieRepository(int id) async {
    return await repository.getMovieDetails(id);
  }
}