import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moblie_banking/core/services/api_service.dart';
import 'package:moblie_banking/features/auth/logic/auth_provider.dart';
import 'package:moblie_banking/features/deposit/transaction/logic/transaction_provider.dart';
import 'package:moblie_banking/features/notification/logic/notification_notifier.dart';
import 'package:moblie_banking/features/notification/logic/notification_state.dart';

final notificationNotifierProvider =
    StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
      final apiService = ref.watch(dioClientProvider);
      return NotificationNotifier(apiService);
    });

final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient();
});

// Provider that combines transaction and notification data
final combinedNotificationProvider = Provider<NotificationState>((ref) {
  final notificationState = ref.watch(notificationNotifierProvider);
  final transactionState = ref.watch(transactionNotifierProvider);

  // If transactions are loaded, sync them with notifications
  if (transactionState.transactions.isNotEmpty &&
      !notificationState.isLoading) {
    // This will be handled in the notification screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(notificationNotifierProvider.notifier)
          .syncTransactionNotifications(transactionState.transactions);
    });
  }

  return notificationState;
});
