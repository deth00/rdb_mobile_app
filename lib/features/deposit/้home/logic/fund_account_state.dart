import 'package:moblie_banking/core/models/account_model.dart';

class FundAccountState {
  final bool isLoading;
  final String? errorMessage;
  final FundAccountDetail? fundAccountDetail;

  FundAccountState({
    this.isLoading = false,
    this.errorMessage,
    this.fundAccountDetail,
  });

  FundAccountState copyWith({
    bool? isLoading,
    String? errorMessage,
    FundAccountDetail? fundAccountDetail,
  }) {
    return FundAccountState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      fundAccountDetail: fundAccountDetail ?? this.fundAccountDetail,
    );
  }
}
