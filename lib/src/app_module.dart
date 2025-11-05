import 'package:flutter_modular/flutter_modular.dart';
import 'package:dio/dio.dart';
import 'package:kinopoisk/pages/home_page.dart';
import 'package:kinopoisk/data/repositories/movie_repository.dart';
import 'package:kinopoisk/data/repositories/movie_repository_impl.dart';

class AppModule extends Module {
  @override
  void binds(i) {
    // Регистрируем Dio
    i.addLazySingleton<Dio>(() => Dio());
    // Регистрируем MovieRepositoryImpl с Dio
    i.addLazySingleton<MovieRepository>(
      () => MovieRepositoryImpl(
        dio: Modular.get<Dio>(),
        baseUrl: 'https://api.themoviedb.org/3',
        apiKey: '5e213c62695f37261e304ffc00a254bb',
      ),
    );
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (_) => const HomePage());
  }
}
