import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinopoisk/features/auth/data/models/auth_user.dart';
import 'package:kinopoisk/features/auth/domain/usecases/auth_usecase.dart';

abstract class AuthEvent {}
class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  LoginRequested(this.email, this.password);
}
class LogoutRequested extends AuthEvent {}

abstract class AuthState {}
class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class Authenticated extends AuthState {
  final AuthUser user;
  Authenticated(this.user);
}
class Unauthenticated extends AuthState {}
class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthUseCase authUseCase;

  AuthBloc({required this.authUseCase}) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await authUseCase.login(event.email, event.password);
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(AuthError('Invalid credentials'));
      }
    } catch (e) {
      String errorMsg;
      if (e is Map) {
        errorMsg = e['message']?.toString() ?? e['error']?.toString() ?? 'Unknown error';
      } else {
        errorMsg = e.toString();
      }
      emit(AuthError(errorMsg));
    }
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    await authUseCase.logout();
    emit(Unauthenticated());
  }
}
