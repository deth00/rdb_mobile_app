import 'package:moblie_banking/core/models/user_model.dart';

class AuthState {
  final bool isLoading;
  final bool isLoggedIn;
  final User? user;
  final String? successMessage;
  final String? errorMessage;

  AuthState({
    this.isLoading = false,
    this.isLoggedIn = false,
    this.user,
    this.successMessage,
    this.errorMessage,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isLoggedIn,
    User? user,
    String? successMessage,
    String? errorMessage,
    String? type,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      user: user ?? this.user,
      successMessage: successMessage,
      errorMessage: errorMessage,
    );
  }
}
