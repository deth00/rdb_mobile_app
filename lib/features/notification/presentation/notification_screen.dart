import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:moblie_banking/core/utils/app_colors.dart';
import 'package:moblie_banking/features/notification/logic/notification_provider.dart';
import 'package:moblie_banking/features/deposit/transaction/logic/transaction_provider.dart';
import 'package:moblie_banking/widgets/appbar.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      // Load notifications
      ref.read(notificationNotifierProvider.notifier).getNotifications();
      // Load transactions to sync with notifications
      ref.read(transactionNotifierProvider.notifier).fetchTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double fixedSize = size.width + size.height;

    // Watch both notification and transaction states
    final notificationState = ref.watch(notificationNotifierProvider);
    final transactionState = ref.watch(transactionNotifierProvider);

    // Sync transaction data with notifications when transactions are loaded
    if (transactionState.transactions.isNotEmpty &&
        !notificationState.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(notificationNotifierProvider.notifier)
            .syncTransactionNotifications(transactionState.transactions);
      });
    }

    // Calculate transaction statistics
    final transactionNotifications = notificationState.notifications
        .where((n) => n.type == 'transaction')
        .toList();
    final totalTransactions = transactionNotifications.length;
    final unreadTransactions = transactionNotifications
        .where((n) => !n.isRead)
        .length;

    return Scaffold(
      appBar: GradientAppBar(
        title: 'ການແຈ້ງເຕືອນ',
        actions: [
          if (notificationState.unreadCount > 0)
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'mark_all_read') {
                  ref
                      .read(notificationNotifierProvider.notifier)
                      .markAllAsRead();
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'mark_all_read',
                  child: Row(
                    children: [
                      Icon(Icons.mark_email_read, color: AppColors.color1),
                      SizedBox(width: 8),
                      Text('ມາກທັງໝົດວ່າອ່ານແລ້ວ'),
                    ],
                  ),
                ),
              ],
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Icon(Icons.more_vert, color: Colors.white),
              ),
            ),
        ],
      ),
      body: notificationState.isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.color1),
                  SizedBox(height: fixedSize * 0.01),
                  Text('ກຳລັງໂຫຼດການແຈ້ງເຕືອນ...'),
                ],
              ),
            )
          : notificationState.errorMessage != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red),
                  SizedBox(height: fixedSize * 0.01),
                  Text(
                    notificationState.errorMessage!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red),
                  ),
                  SizedBox(height: fixedSize * 0.01),
                  ElevatedButton(
                    onPressed: () {
                      ref
                          .read(notificationNotifierProvider.notifier)
                          .clearError();
                      ref
                          .read(notificationNotifierProvider.notifier)
                          .getNotifications();
                    },
                    child: Text('ລອງໃໝ່'),
                  ),
                ],
              ),
            )
          : notificationState.notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_none, size: 64, color: Colors.grey),
                  SizedBox(height: fixedSize * 0.01),
                  Text(
                    'ບໍ່ມີການແຈ້ງເຕືອນ',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                await ref
                    .read(notificationNotifierProvider.notifier)
                    .getNotifications();
                await ref
                    .read(transactionNotifierProvider.notifier)
                    .fetchTransactions();
              },
              child: Column(
                children: [
                  // Transaction summary section
                  // if (totalTransactions > 0)
                  //   Container(
                  //     margin: EdgeInsets.all(fixedSize * 0.01),
                  //     padding: EdgeInsets.all(fixedSize * 0.015),
                  //     decoration: BoxDecoration(
                  //       gradient: AppColors.main,
                  //       borderRadius: BorderRadius.circular(12),
                  //     ),
                  //     child: Row(
                  //       children: [
                  //         Icon(
                  //           Icons.account_balance_wallet,
                  //           color: Colors.white,
                  //           size: fixedSize * 0.025,
                  //         ),
                  //         SizedBox(width: fixedSize * 0.01),
                  //         Expanded(
                  //           child: Column(
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             children: [
                  //               Text(
                  //                 'ສະຫຼຸບການເຄື່ອນໄຫວ',
                  //                 style: TextStyle(
                  //                   color: Colors.white,
                  //                   fontWeight: FontWeight.bold,
                  //                   fontSize: fixedSize * 0.013,
                  //                 ),
                  //               ),
                  //               Text(
                  //                 'ທັງໝົດ: $totalTransactions | ບໍ່ອ່ານ: $unreadTransactions',
                  //                 style: TextStyle(
                  //                   color: Colors.white70,
                  //                   fontSize: fixedSize * 0.011,
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //         IconButton(
                  //           onPressed: () {
                  //             context.pushNamed('transactions');
                  //           },
                  //           icon: Icon(
                  //             Icons.arrow_forward_ios,
                  //             color: Colors.white,
                  //             size: fixedSize * 0.02,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // // Notifications list
                  Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(
                        horizontal: fixedSize * 0.01,
                      ),
                      separatorBuilder: (context, index) => Divider(height: 1),
                      itemCount: notificationState.notifications.length,
                      itemBuilder: (context, index) {
                        final notification =
                            notificationState.notifications[index];
                        return _buildNotificationTile(notification, fixedSize);
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildNotificationTile(notification, double fixedSize) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        color: Colors.red,
        child: Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        ref
            .read(notificationNotifierProvider.notifier)
            .deleteNotification(notification.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('ລຶບການແຈ້ງເຕືອນແລ້ວ'),
            action: SnackBarAction(
              label: 'ຍົກເລີກ',
              onPressed: () {
                // TODO: Implement undo delete
              },
            ),
          ),
        );
      },
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: fixedSize * 0.01,
          vertical: fixedSize * 0.005,
        ),
        leading: Container(
          width: fixedSize * 0.04,
          height: fixedSize * 0.04,
          decoration: BoxDecoration(
            color: _getNotificationColor(notification.type),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getNotificationIcon(notification.type),
            color: Colors.white,
            size: fixedSize * 0.02,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                notification.title,
                style: TextStyle(
                  fontWeight: notification.isRead
                      ? FontWeight.normal
                      : FontWeight.bold,
                  fontSize: fixedSize * 0.012,
                ),
              ),
            ),
            if (!notification.isRead)
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.color1,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: fixedSize * 0.003),
            Text(
              notification.message,
              style: TextStyle(
                fontSize: fixedSize * 0.011,
                color: Colors.grey[600],
              ),
            ),
            // Show additional transaction details for transaction notifications
            if (notification.type == 'transaction' &&
                notification.metadata != null) ...[
              SizedBox(height: fixedSize * 0.002),
              Text(
                'ເລກອ້າງອີງ: ${notification.metadata!['transaction_id']}',
                style: TextStyle(
                  fontSize: fixedSize * 0.010,
                  color: Colors.grey[500],
                ),
              ),
              if (notification.metadata!['description'] != null &&
                  notification.metadata!['description'].toString().isNotEmpty)
                Text(
                  'ລາຍລະອຽດ: ${notification.metadata!['description']}',
                  style: TextStyle(
                    fontSize: fixedSize * 0.010,
                    color: Colors.grey[500],
                  ),
                ),
            ],
            SizedBox(height: fixedSize * 0.003),
            Text(
              _formatDateTime(notification.createdAt),
              style: TextStyle(
                fontSize: fixedSize * 0.010,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
        onTap: () {
          if (!notification.isRead) {
            ref
                .read(notificationNotifierProvider.notifier)
                .markAsRead(notification.id);
          }
          // Handle notification action based on type and actionUrl
          _handleNotificationAction(notification);
        },
      ),
    );
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'transaction':
        return Colors.green;
      case 'security':
        return Colors.red;
      case 'promotion':
        return Colors.orange;
      case 'system':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'transaction':
        return Icons.account_balance_wallet;
      case 'security':
        return Icons.security;
      case 'promotion':
        return Icons.local_offer;
      case 'system':
        return Icons.system_update;
      default:
        return Icons.notifications;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'ຫຼັງສັດ';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} ນາທີກ່ອນ';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ຊົ່ວໂມງກ່ອນ';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ມື້ກ່ອນ';
    } else {
      return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
    }
  }

  void _handleNotificationAction(notification) {
    // Handle different notification actions based on type and actionUrl
    if (notification.actionUrl != null) {
      // Navigate to specific screen or open URL
      if (notification.actionUrl!.startsWith('http')) {
        context.pushNamed(
          'webview',
          queryParameters: {'url': notification.actionUrl},
        );
      } else {
        // Handle internal navigation
        switch (notification.type) {
          case 'transaction':
            // Show transaction details dialog for transaction notifications
            _showTransactionDetailsDialog(notification);
            break;
          case 'promotion':
            context.pushNamed('services');
            break;
          default:
            // Do nothing or show a snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('ການແຈ້ງເຕືອນ: ${notification.title}')),
            );
        }
      }
    }
  }

  void _showTransactionDetailsDialog(notification) {
    final metadata = notification.metadata;
    if (metadata == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('ລາຍລະອຽດການເຄື່ອນໄຫວ'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('ປະເພດ', notification.title),
            _buildDetailRow('ເລກອ້າງອີງ', metadata['transaction_id'] ?? ''),
            _buildDetailRow(
              'ຈຳນວນເງິນ',
              NumberFormat.currency(
                locale: 'en_US',
                symbol: 'ກີບ',
                decimalDigits: 2,
              ).format(metadata['amount'] ?? 0),
            ),
            _buildDetailRow('ບັນຊີ', metadata['account'] ?? ''),
            if (metadata['description'] != null &&
                metadata['description'].toString().isNotEmpty)
              _buildDetailRow('ລາຍລະອຽດ', metadata['description']),
            _buildDetailRow(
              'ລະຫັດການເຄື່ອນໄຫວ',
              metadata['transaction_code'] ?? '',
            ),
            _buildDetailRow(
              'ວັນທີ',
              DateFormat('dd/MM/yyyy HH:mm').format(notification.createdAt),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('ປິດ'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.pushNamed('transactions');
            },
            child: Text('ເບິ່ງທັງໝົດ'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
