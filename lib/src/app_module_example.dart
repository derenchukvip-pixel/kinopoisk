import 'package:flutter_modular/flutter_modular.dart';
import 'package:kinopoisk/data/repositories/movie_repository.dart';
import 'package:kinopoisk/data/repositories/movie_repository_impl.dart';
import 'package:kinopoisk/pages/home_page.dart';
// Импортируй остальные репозитории и реализации по аналогии

class AppModule extends Module {
  @override
  void binds(i) {
    // Здесь нужно передать параметры в конструктор MovieRepositoryImpl
    i.addLazySingleton<MovieRepository>(() => MovieRepositoryImpl(
      dio: Modular.get(),
      baseUrl: 'https://api.themoviedb.org/3',
      apiKey: '5e213c62695f37261e304ffc00a254bb',
    ));
    // i.addLazySingleton<TVShowRepository>(TVShowRepositoryImpl.new);
    // i.addLazySingleton<UserRepository>(UserRepositoryImpl.new);
    // ...
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (_) => const HomePage());
    // Добавляй остальные маршруты по мере необходимости
  }
}
