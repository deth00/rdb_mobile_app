import 'package:moblie_banking/core/models/user_model.dart';

class AuthState {
  final bool isLoading;
  final bool isLoggedIn;
  final User? user;
  final String? successMessage;
  final String? errorMessage;
  final bool canUseBiometric;
  final bool isBiometricEnabled;

  AuthState({
    this.isLoading = false,
    this.isLoggedIn = false,
    this.user,
    this.successMessage,
    this.errorMessage,
    this.canUseBiometric = false,
    this.isBiometricEnabled = false,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isLoggedIn,
    User? user,
    String? successMessage,
    String? errorMessage,
    String? type,
    bool? canUseBiometric,
    bool? isBiometricEnabled,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      user: user ?? this.user,
      successMessage: successMessage,
      errorMessage: errorMessage,
      canUseBiometric: canUseBiometric ?? this.canUseBiometric,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
    );
  }
}
