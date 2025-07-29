import 'package:moblie_banking/core/models/account_model.dart';

class DptState {
  final bool isLoading;
  final String? errorMessage;
  final AccountDetail? accountDetail;

  DptState({this.isLoading = false, this.errorMessage, this.accountDetail});

  DptState copyWith({
    bool? isLoading,
    String? errorMessage,
    AccountDetail? accountDetail,
  }) {
    return DptState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      accountDetail: accountDetail ?? this.accountDetail,
    );
  }
}
