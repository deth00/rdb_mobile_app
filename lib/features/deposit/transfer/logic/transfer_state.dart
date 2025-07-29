import 'package:moblie_banking/core/models/transfer_model.dart';
import 'package:moblie_banking/core/models/user_limit_model.dart';

class TransferState {
  final bool isLoading;
  final String? errorMessage;
  final ReceiverAccount? receiverAccount;
  final bool isTransferSuccess;
  final UserLimit? userLimit;
  final bool isLimitUpdateSuccess;
  final String? successMessage;

  TransferState({
    this.isLoading = false,
    this.errorMessage,
    this.receiverAccount,
    this.isTransferSuccess = false,
    this.userLimit,
    this.isLimitUpdateSuccess = false,
    this.successMessage,
  });

  TransferState copyWith({
    bool? isLoading,
    String? errorMessage,
    ReceiverAccount? receiverAccount,
    bool? isTransferSuccess,
    UserLimit? userLimit,
    bool? isLimitUpdateSuccess,
    String? successMessage,
  }) {
    return TransferState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      receiverAccount: receiverAccount ?? this.receiverAccount,
      isTransferSuccess: isTransferSuccess ?? this.isTransferSuccess,
      userLimit: userLimit ?? this.userLimit,
      isLimitUpdateSuccess: isLimitUpdateSuccess ?? this.isLimitUpdateSuccess,
      successMessage: successMessage ?? this.successMessage,
    );
  }
}
