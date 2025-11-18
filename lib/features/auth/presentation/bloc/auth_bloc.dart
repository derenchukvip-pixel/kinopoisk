import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/auth_user.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';

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
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;

  AuthBloc({required this.loginUseCase, required this.logoutUseCase}) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
          final user = await loginUseCase.login(event.email, event.password);
        if (user != null) {
          emit(Authenticated(user));
        } else {
          emit(AuthError('Invalid credentials'));
        }
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
    on<LogoutRequested>((event, emit) async {
  await logoutUseCase.logout();
      emit(Unauthenticated());
    });
  }
}
