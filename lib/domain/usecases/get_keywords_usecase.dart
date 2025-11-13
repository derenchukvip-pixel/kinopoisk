import 'package:kinopoisk/data/models/movie_details.dart';

import '../../data/repositories/movie_repository.dart';

class GetKeywordsUseCase {
  final MovieRepository repository;

  GetKeywordsUseCase(this.repository);

  Future<List<Keyword>> movieRepository(int id) async {
    return await repository.getKeywords(id);
  }
}