import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/login_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  
  AuthBloc({required this.loginUseCase}) : super(AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthCheckRequested>(_onCheckRequested);
  }
  
  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emitter,
  ) async {
    emitter(AuthLoading());
    try {
      final success = await loginUseCase(event.email, event.password);
      if (success) {
        emitter(AuthAuthenticated(event.email));
      } else {
        emitter(const AuthError('Invalid credentials'));
      }
    } catch (e) {
      emitter(AuthError(e.toString()));
    }
  }
  
  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emitter,
  ) async {
    emitter(AuthUnauthenticated());
  }
  
  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emitter,
  ) async {
    // Implementation would check if user is already logged in
    emitter(AuthUnauthenticated());
  }
}