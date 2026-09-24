  import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc({
    required this.repository,
  }) : super(const AuthState()) {
    on<RequestPatientOtp>(_requestPatientOtp);
    on<VerifyPatientOtp>(_verifyPatientOtp);
    on<DoctorLogin>(_doctorLogin);
    on<LogoutRequested>(_logout);
  }

  Future<void> _requestPatientOtp(
    RequestPatientOtp event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        status: AuthStatus.loading,
        clearError: true,
      ),
    );

    try {
      final demoOtp = await repository.requestPatientOtp(
        email: event.email,
      );

      emit(
        state.copyWith(
          status: AuthStatus.otpSent,
          demoOtp: demoOtp,
          clearError: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: _getErrorMessage(error),
        ),
      );
    }
  }

  Future<void> _verifyPatientOtp(
    VerifyPatientOtp event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        status: AuthStatus.loading,
        clearError: true,
      ),
    );

    try {
      final user = await repository.verifyPatientOtp(
        email: event.email,
        otp: event.otp,
      );

      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          clearError: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: _getErrorMessage(error),
        ),
      );
    }
  }

  Future<void> _doctorLogin(
    DoctorLogin event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        status: AuthStatus.loading,
        clearError: true,
      ),
    );

    try {
      final user = await repository.doctorLogin(
        username: event.username,
        password: event.password,
      );

      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          clearError: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: _getErrorMessage(error),
        ),
      );
    }
  }

  Future<void> _logout(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await repository.logout();

    emit(
      const AuthState(
        status: AuthStatus.unauthenticated,
      ),
    );
  }

  String _getErrorMessage(Object error) {
    return error.toString().replaceFirst(
          'Exception: ',
          '',
        );
  }
}