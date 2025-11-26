import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:moblie_banking/core/models/notification_model.dart';
import 'package:moblie_banking/core/models/transaction_model.dart';
import 'package:moblie_banking/core/services/api_service.dart';
import 'package:moblie_banking/features/notification/logic/notification_state.dart';

class NotificationNotifier extends StateNotifier<NotificationState> {
  final DioClient _apiService;

  NotificationNotifier(this._apiService) : super(const NotificationState());

  // Method to create notifications from transaction data
  List<NotificationModel> _createTransactionNotifications(
    List<Transaction> transactions,
  ) {
    return transactions.map((tx) {
      final isIncome = tx.amt >= 0;
      final title = isIncome ? 'ໄດ້ຮັບເງິນ' : 'ໂອນເງິນອອກ';
      final message = isIncome
          ? 'ໄດ້ຮັບເງິນຈຳນວນ ${NumberFormat.currency(locale: 'en_US', symbol: 'ກີບ', decimalDigits: 2).format(tx.amt)} ຈາກ ${tx.usrname}'
          : 'ໂອນເງິນຈຳນວນ ${NumberFormat.currency(locale: 'en_US', symbol: 'ກີບ', decimalDigits: 2).format(tx.amt.abs())} ໄປຫາ ${tx.usrname}';

      return NotificationModel(
        id: 'tx_${tx.txrefid}',
        title: title,
        message: message,
        type: 'transaction',
        createdAt: DateFormat('dd/MM/yyyy HH:mm').parse(tx.valuedt),
        isRead: false,
        actionUrl: 'transactions',
        metadata: {
          'transaction_id': tx.txrefid,
          'amount': tx.amt,
          'account': tx.usrname,
          'description': tx.descr,
          'transaction_code': tx.txcode,
        },
      );
    }).toList();
  }

  // Method to sync transaction data with notifications
  Future<void> syncTransactionNotifications(
    List<Transaction> transactions,
  ) async {
    try {
      // Only create notifications if there are real transactions
      if (transactions.isEmpty) {
        // If no transactions, clear any existing transaction notifications
        final nonTransactionNotifications = state.notifications
            .where((n) => !n.id.startsWith('tx_'))
            .toList();

        final unreadCount = nonTransactionNotifications
            .where((n) => !n.isRead)
            .length;

        state = state.copyWith(
          notifications: nonTransactionNotifications,
          unreadCount: unreadCount,
        );
        return;
      }

      // Get existing notifications (excluding transaction notifications)
      final existingNotifications = state.notifications
          .where((n) => !n.id.startsWith('tx_'))
          .toList();

      // Create transaction notifications only from real transaction data
      final transactionNotifications = _createTransactionNotifications(
        transactions,
      );

      // Combine and sort all notifications
      final allNotifications = [
        ...transactionNotifications,
        ...existingNotifications,
      ];
      allNotifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      final unreadCount = allNotifications.where((n) => !n.isRead).length;

      state = state.copyWith(
        notifications: allNotifications,
        unreadCount: unreadCount,
      );
    } catch (e) {
      // Handle error silently or log it
      print('Error syncing transaction notifications: $e');
    }
  }

  // Future<void> getNotifications() async {
  //   try {
  //     state = state.copyWith(isLoading: true, errorMessage: null);

  //     // Simulate API call - replace with actual API endpoint
  //     await Future.delayed(Duration(seconds: 1));

  //     // Mock transaction data for demonstration
  //     final mockTransactions = [
  //       Transaction(
  //         txcode: 'DPT_CFM',
  //         defacno: '1234567890',
  //         stdt: '15/12/2024 14:30',
  //         txrefid: 'TX001',
  //         amt: 500000.0,
  //         descs: 'ໂອນເງິນ',
  //         valuedt: '15/12/2024 14:30',
  //         usrname: 'ທ. ສົມສະໄໝ',
  //         descr: 'ໂອນເງິນສຳລັບຊື້ສິນຄ້າ',
  //       ),
  //     ];

  //     // Create transaction-based notifications
  //     final transactionNotifications = _createTransactionNotifications(
  //       mockTransactions,
  //     );

  //     // Mock data for other notifications
  //     final mockNotifications = [
  //       NotificationModel(
  //         id: '1',
  //         title: 'ການເຂົ້າສູ່ລະບົບ',
  //         message: 'ມີການເຂົ້າສູ່ລະບົບຈາກອຸປະກອນໃໝ່',
  //         type: 'security',
  //         createdAt: DateTime.now().subtract(Duration(hours: 2)),
  //         isRead: true,
  //       ),
  //       NotificationModel(
  //         id: '2',
  //         title: 'ຂໍ້ສະເໜີພິເສດ',
  //         message: 'ຮັບສ່ວນຫຼຸດພິເສດ 10% ສຳລັບການໂອນເງິນຄັ້ງທຳອິດ',
  //         type: 'promotion',
  //         createdAt: DateTime.now().subtract(Duration(days: 1)),
  //         isRead: false,
  //       ),
  //       NotificationModel(
  //         id: '3',
  //         title: 'ການບຳລຸງລະບົບ',
  //         message: 'ລະບົບຈະບຳລຸງຕອນກາງຄືນ ຈາກ 02:00-04:00',
  //         type: 'system',
  //         createdAt: DateTime.now().subtract(Duration(days: 2)),
  //         isRead: true,
  //       ),
  //     ];

  //     // Combine all notifications and sort by creation date
  //     final allNotifications = [
  //       ...transactionNotifications,
  //       ...mockNotifications,
  //     ];
  //     allNotifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));

  //     final unreadCount = allNotifications.where((n) => !n.isRead).length;

  //     state = state.copyWith(
  //       isLoading: false,
  //       notifications: allNotifications,
  //       unreadCount: unreadCount,
  //     );
  //   } catch (e) {
  //     state = state.copyWith(
  //       isLoading: false,
  //       errorMessage: 'ເກີດຂໍ້ຜິດພາດໃນການໂຫຼດການແຈ້ງເຕືອນ: ${e.toString()}',
  //     );
  //   }
  // }

  Future<void> markAsRead(String notificationId) async {
    try {
      final updatedNotifications = state.notifications.map((notification) {
        if (notification.id == notificationId) {
          return notification.copyWith(isRead: true);
        }
        return notification;
      }).toList();

      final unreadCount = updatedNotifications.where((n) => !n.isRead).length;

      state = state.copyWith(
        notifications: updatedNotifications,
        unreadCount: unreadCount,
      );

      // TODO: Call API to mark notification as read
      // await _apiService.markNotificationAsRead(notificationId);
    } catch (e) {
      // Handle error silently or show snackbar
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final updatedNotifications = state.notifications
          .map((notification) => notification.copyWith(isRead: true))
          .toList();

      state = state.copyWith(
        notifications: updatedNotifications,
        unreadCount: 0,
      );

      // TODO: Call API to mark all notifications as read
      // await _apiService.markAllNotificationsAsRead();
    } catch (e) {
      // Handle error silently or show snackbar
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    try {
      final updatedNotifications = state.notifications
          .where((notification) => notification.id != notificationId)
          .toList();

      final unreadCount = updatedNotifications.where((n) => !n.isRead).length;

      state = state.copyWith(
        notifications: updatedNotifications,
        unreadCount: unreadCount,
      );

      // TODO: Call API to delete notification
      // await _apiService.deleteNotification(notificationId);
    } catch (e) {
      // Handle error silently or show snackbar
    }
  }

  void clearError() {
    state = state.clearError();
  }

  // Method to clear all notifications
  void clearAllNotifications() {
    state = state.copyWith(notifications: [], unreadCount: 0);
  }

  // Method to check if there are any real notifications (not mock data)
  bool hasRealNotifications() {
    return state.notifications.isNotEmpty;
  }
}
