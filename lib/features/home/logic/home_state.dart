import 'package:moblie_banking/core/models/account_linkage_model.dart';

class HomeState {
  final bool isLoading;
  final String? errorMessage;
  final List<AccountLinkage> accountDpt;
  final String? qrCode;
  final String? errorMessageQR;

  HomeState({
    this.isLoading = false,
    this.errorMessage,
    this.accountDpt = const [],
    this.qrCode,
    this.errorMessageQR,
  });

  HomeState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<AccountLinkage>? accountDpt,
    String? qrCode,
    String? errorMessageQR,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      errorMessageQR: errorMessageQR ?? this.errorMessageQR,
      accountDpt: accountDpt ?? this.accountDpt,
      qrCode: qrCode ?? this.qrCode,
    );
  }
}
