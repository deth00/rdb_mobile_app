import 'package:moblie_banking/core/models/account_model.dart';
import 'package:moblie_banking/core/models/user_limit_model.dart';
import 'package:moblie_banking/core/models/transfer_model.dart';

class TransferState {
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;
  final ReceiverAccount? receiverAccount;
  final UserLimit? userLimit;
  final bool status;
  final bool isTransferSuccess;
  final bool isLimitUpdateSuccess;
  final double? transferAmount;
  final String? transferDetails;

  TransferState({
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
    this.receiverAccount,
    this.userLimit,
    this.status = false,
    this.isTransferSuccess = false,
    this.isLimitUpdateSuccess = false,
    this.transferAmount,
    this.transferDetails,
  });

  TransferState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
    ReceiverAccount? receiverAccount,
    UserLimit? userLimit,
    bool? status,
    bool? isTransferSuccess,
    bool? isLimitUpdateSuccess,
    double? transferAmount,
    String? transferDetails,
  }) {
    return TransferState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
      receiverAccount: receiverAccount ?? this.receiverAccount,
      userLimit: userLimit ?? this.userLimit,
      status: status ?? this.status,
      isTransferSuccess: isTransferSuccess ?? this.isTransferSuccess,
      isLimitUpdateSuccess: isLimitUpdateSuccess ?? this.isLimitUpdateSuccess,
      transferAmount: transferAmount ?? this.transferAmount,
      transferDetails: transferDetails ?? this.transferDetails,
    );
  }
}
