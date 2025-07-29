import 'package:moblie_banking/core/models/transaction_model.dart';

class TransactionState {
  final bool isLoading;
  final String? error;
  final List<Transaction> transactions;
  final int offset;
  final bool hasMoreData;
  final bool isRefreshing;

  TransactionState({
    this.isLoading = false,
    this.error,
    this.transactions = const [],
    this.offset = 0,
    this.hasMoreData = true,
    this.isRefreshing = false,
  });

  TransactionState copyWith({
    bool? isLoading,
    String? error,
    List<Transaction>? transactions,
    int? offset,
    bool? hasMoreData,
    bool? isRefreshing,
  }) {
    return TransactionState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      transactions: transactions ?? this.transactions,
      offset: offset ?? this.offset,
      hasMoreData: hasMoreData ?? this.hasMoreData,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }
}
