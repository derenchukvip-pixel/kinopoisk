
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:kinopoisk/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:kinopoisk/features/auth/data/tmdb_auth_repository.dart';
import 'package:kinopoisk/features/auth/domain/usecases/login_usecase.dart';
import 'package:kinopoisk/features/auth/domain/usecases/logout_usecase.dart';


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
          loginUseCase: LoginUseCase(authRepository),
          logoutUseCase: LogoutUseCase(authRepository),
        ),
        child: MaterialApp.router(
          title: 'Kinopoisk',
          theme: ThemeData.dark(useMaterial3: true),
          routeInformationParser: Modular.routeInformationParser,
          routerDelegate: Modular.routerDelegate,
        ),
      ),
    );
  }
}