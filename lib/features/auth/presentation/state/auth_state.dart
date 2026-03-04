import 'package:equatable/equatable.dart';

enum AuthStatus {
  initial,
  loading,
  success,
  error,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final String? errorMessage;
  final String? successMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.errorMessage,
    this.successMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? errorMessage,
    String? successMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, successMessage];
}

// Added loading substates
