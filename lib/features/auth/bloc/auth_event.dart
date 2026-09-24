import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class RequestPatientOtp extends AuthEvent {
  final String email;

  const RequestPatientOtp({
    required this.email,
  });

  @override
  List<Object?> get props => [email];
}

class VerifyPatientOtp extends AuthEvent {
  final String email;
  final String otp;

  const VerifyPatientOtp({
    required this.email,
    required this.otp,
  });

  @override
  List<Object?> get props => [
        email,
        otp,
      ];
}

class DoctorLogin extends AuthEvent {
  final String username;
  final String password;

  const DoctorLogin({
    required this.username,
    required this.password,
  });

  @override
  List<Object?> get props => [
        username,
        password,
      ];
}

class LogoutRequested extends AuthEvent {}