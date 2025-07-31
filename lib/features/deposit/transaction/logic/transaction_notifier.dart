import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moblie_banking/core/models/transaction_model.dart';
import 'package:moblie_banking/core/services/api_service.dart';
import 'transaction_state.dart';

class TransactionNotifier extends StateNotifier<TransactionState> {
  final DioClient dioClient;
  static const int pageSize = 20;

  TransactionNotifier(this.dioClient) : super(TransactionState());

  Future<void> fetchTransactions({String? acno}) async {
    // Don't fetch if already loading or no more data
    if (state.isLoading || !state.hasMoreData) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await dioClient.client.get(
        'v1/act/getAccountStatementCore/',
        queryParameters: {
          'acno': acno ?? '0201010000205444001', // Default account number
          'offset': state.offset,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        final newTransactions = data
            .map((json) => Transaction.fromJson(json))
            .toList();

        // Check if we have more data
        final hasMoreData = newTransactions.length >= pageSize;

        state = state.copyWith(
          isLoading: false,
          transactions: [...state.transactions, ...newTransactions],
          offset: state.offset + newTransactions.length,
          hasMoreData: hasMoreData,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'ເກີດຂໍ້ຜິດພາດໃນການເກັບຂໍ້ມູນ',
        );
      }
    } on DioError catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'ເກີດຂໍ້ຜິດພາດໃນການເຊື່ອມຕໍ່: ${e.message}',
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'ເກີດຂໍ້ຜິດພາດ: $e');
    }
  }

  Future<void> refreshTransactions({String? acno}) async {
    state = state.copyWith(
      isRefreshing: true,
      error: null,
      transactions: [],
      offset: 0,
      hasMoreData: true,
    );

    try {
      final response = await dioClient.client.get(
        'v1/act/getAccountStatementCore/',
        queryParameters: {'acno': acno ?? '0201010000205444001', 'offset': 0},
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        final newTransactions = data
            .map((json) => Transaction.fromJson(json))
            .toList();

        final hasMoreData = newTransactions.length >= pageSize;

        state = state.copyWith(
          isRefreshing: false,
          transactions: newTransactions,
          offset: newTransactions.length,
          hasMoreData: hasMoreData,
        );
      } else {
        state = state.copyWith(
          isRefreshing: false,
          error: 'ເກີດຂໍ້ຜິດພາດໃນການເກັບຂໍ້ມູນ',
        );
      }
    } on DioError catch (e) {
      state = state.copyWith(
        isRefreshing: false,
        error: 'ເກີດຂໍ້ຜິດພາດໃນການເຊື່ອມຕໍ່: ${e.message}',
      );
    } catch (e) {
      state = state.copyWith(isRefreshing: false, error: 'ເກີດຂໍ້ຜິດພາດ: $e');
    }
  }

  void reset() {
    state = TransactionState();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
