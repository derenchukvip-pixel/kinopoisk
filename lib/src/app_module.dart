import 'package:kinopoisk/l10n/app_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:kinopoisk/pages/home_page.dart';
import 'package:kinopoisk/pages/movie_details_page.dart';
import 'package:kinopoisk/data/repositories/movie_repository.dart';
import 'package:kinopoisk/data/repositories/movie_repository_impl.dart';
import 'package:kinopoisk/domain/usecases/get_top_rated_movies_usecase.dart';
import 'package:kinopoisk/domain/usecases/get_now_playing_movies_usecase.dart';
import 'package:kinopoisk/domain/usecases/get_upcoming_movies_usecase.dart';
import 'package:kinopoisk/core/storage/favorite_service.dart';
import 'package:kinopoisk/domain/usecases/get_popular_movies_usecase.dart';
import 'package:kinopoisk/domain/usecases/get_movie_details_usecase.dart';
import 'package:kinopoisk/domain/usecases/get_keywords_usecase.dart';
import 'package:kinopoisk/pages/search_page.dart';
import 'package:kinopoisk/features/auth/presentation/login_page.dart';
import 'package:kinopoisk/features/auth/presentation/profile_page.dart';
import 'package:kinopoisk/data/repositories/search_repository_impl.dart';
import 'package:kinopoisk/data/repositories/search_repository.dart';
import 'package:kinopoisk/data/network/tmdb_api_service.dart';

class AppModule extends Module {
  @override
  void binds(i) {
    // TMDB API сервис для фильтров
    i.addLazySingleton<TmdbApiService>(() => TmdbApiService(
      dio: Modular.get<Dio>(),
      apiKey: '5e213c62695f37261e304ffc00a254bb',
      baseUrl: 'https://api.themoviedb.org/3',
    ));
    // Избранное
    i.addLazySingleton<FavoriteService>(() => FavoriteService());
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
    // Регистрируем SearchRepositoryImpl с Dio
    i.addLazySingleton<SearchRepository>(
      () => SearchRepositoryImpl(
        dio: Modular.get<Dio>(),
        baseUrl: 'https://api.themoviedb.org/3',
        apiKey: '5e213c62695f37261e304ffc00a254bb',
      ),
    );
    // Регистрируем GetPopularMoviesUseCase
    i.addLazySingleton<GetPopularMoviesUseCase>(
      () => GetPopularMoviesUseCase(Modular.get<MovieRepository>()),
    );
    i.addLazySingleton<GetTopRatedMoviesUseCase>(
      () => GetTopRatedMoviesUseCase(Modular.get<MovieRepository>()),
    );
    i.addLazySingleton<GetUpcomingMoviesUseCase>(
      () => GetUpcomingMoviesUseCase(Modular.get<MovieRepository>()),
    );
    i.addLazySingleton<GetNowPlayingMoviesUseCase>(
      () => GetNowPlayingMoviesUseCase(Modular.get<MovieRepository>()),
    );
    i.addLazySingleton<GetMovieDetailsUseCase>(
      () => GetMovieDetailsUseCase(Modular.get<MovieRepository>()),
    );
    i.addLazySingleton<GetKeywordsUseCase>(
      () => GetKeywordsUseCase(Modular.get<MovieRepository>()),
    );
  }

  @override
  void routes(RouteManager r) {
    r.child(
      '/profile',
      child: (_) => const ProfilePage(),
    );
  r.child('/', child: (_) => LoginPage());
    r.child(
      '/details',
      child: (context) {
        final movieId = Modular.args.data as int?;
        if (movieId == null) {
          return Scaffold(
            body: Center(
              child: Text(
                AppLocalizations.of(context)?.movieIdNotFound ?? 'Movie ID not found',
              ),
            ),
          );
        }
        return MovieDetailsPage(movieId: movieId);
      },
    );
    r.child(
      '/search',
      child: (_) {
        final args = Modular.args.data as Map<String, dynamic>?;
        return SearchPage(
          initialQuery: args?['initialQuery'],
          initialCategory: args?['initialCategory'],
        );
      },
    );
    r.child(
      '/home',
      child: (_) => const HomePage(),
    );
  }
}
