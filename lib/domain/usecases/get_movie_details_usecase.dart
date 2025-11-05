import 'package:kinopoisk/data/models/movie_details.dart';

import '../../data/repositories/movie_repository.dart';

class GetMovieDetailsUseCase {
  final MovieRepository repository;

  GetMovieDetailsUseCase(this.repository);

  Future<MovieDetails> call(int id) async {
    return await repository.getMovieDetails(id);
  }
}