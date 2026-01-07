import 'package:kinopoisk/features/auth/domain/usecases/auth_usecase.dart';
import 'package:kinopoisk/core/config/localization_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kinopoisk/l10n/app_localizations.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:kinopoisk/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:kinopoisk/features/auth/data/tmdb_auth_repository.dart';


class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    const apiKey = '5e213c62695f37261e304ffc00a254bb';
    final authRepository = TMDBAuthRepository(apiKey);
    return RepositoryProvider.value(
      value: authRepository,
      child: BlocProvider(
        create: (_) => AuthBloc(
          authUseCase: AuthUseCase(authRepository),
        ),
        child: LocalizationProvider(
          child: MaterialApp.router(
            title: 'Kinopoisk',
            theme: ThemeData.dark(useMaterial3: true).copyWith(
              primaryColor: Colors.white,
              scaffoldBackgroundColor: Colors.black,
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                iconTheme: IconThemeData(color: Colors.white),
                titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              iconTheme: const IconThemeData(color: Colors.white),
              textTheme: const TextTheme(
                headlineMedium: TextStyle(color: Colors.white),
                titleMedium: TextStyle(color: Colors.white),
                bodyMedium: TextStyle(color: Colors.white70),
              ),
              cardColor: Colors.black,
              canvasColor: Colors.black,
            ),
            routeInformationParser: Modular.routeInformationParser,
            routerDelegate: Modular.routerDelegate,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('ru'),
            ],
          ),
        ),
      ),
    );
  }
}