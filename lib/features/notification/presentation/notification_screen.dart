import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:moblie_banking/core/utils/app_colors.dart';
import 'package:moblie_banking/core/utils/route_constants.dart';
import 'package:moblie_banking/features/notification/logic/notification_provider.dart';
import 'package:moblie_banking/features/deposit/transaction/logic/transaction_provider.dart';
import 'package:moblie_banking/features/deposit/้home/logic/dpt_provider.dart';
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
      // Clear any existing notifications to ensure no mock data is shown
      ref.read(notificationNotifierProvider.notifier).clearAllNotifications();

      // Load transactions to sync with notifications (only real data)
      final dptState = ref.read(dptNotifierProvider);
      final acno = dptState.accountDetail?.acNo;

      if (acno != null && acno.isNotEmpty) {
        ref
            .read(transactionNotifierProvider.notifier)
            .fetchTransactions(acno: acno);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      SizedBox(width: 8.w),
                      Text('ມາກທັງໝົດວ່າອ່ານແລ້ວ'),
                    ],
                  ),
                ),
              ],
              child: Padding(
                padding: EdgeInsets.all(16.r),
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
                  SizedBox(height: 20.h),
                  Text('ກຳລັງໂຫຼດການແຈ້ງເຕືອນ...'),
                ],
              ),
            )
          : notificationState.errorMessage != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64.sp, color: Colors.red),
                  SizedBox(height: 20.h),
                  Text(
                    notificationState.errorMessage!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red),
                  ),
                  SizedBox(height: 20.h),
                  ElevatedButton(
                    onPressed: () {
                      ref
                          .read(notificationNotifierProvider.notifier)
                          .clearError();
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
                  Icon(
                    Icons.notifications_none,
                    size: 64.sp,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    'ບໍ່ມີການແຈ້ງເຕືອນໃໝ່',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'ການແຈ້ງເຕືອນຈະປາກົດເມື່ອມີການເຄື່ອນໄຫວໃໝ່',
                    style: TextStyle(color: Colors.grey[500], fontSize: 10.sp),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                final dptState = ref.read(dptNotifierProvider);
                final acno = dptState.accountDetail?.acNo;

                if (acno != null && acno.isNotEmpty) {
                  await ref
                      .read(transactionNotifierProvider.notifier)
                      .fetchTransactions(acno: acno);
                }
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
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      separatorBuilder: (context, index) =>
                          Divider(height: 1.h),
                      itemCount: notificationState.notifications.length,
                      itemBuilder: (context, index) {
                        final notification =
                            notificationState.notifications[index];
                        return _buildNotificationTile(notification, 15.w);
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildNotificationTile(notification, double width) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.w),
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
        contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        leading: Container(
          width: 50.w,
          height: 50.h,
          decoration: BoxDecoration(
            color: _getNotificationColor(notification.type),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getNotificationIcon(notification.type),
            color: Colors.white,
            size: 35.sp,
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
                  fontSize: 16.sp,
                ),
              ),
            ),
            if (!notification.isRead)
              Container(
                width: 8.w,
                height: 8.h,
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
            SizedBox(height: 5.h),
            Text(
              notification.message,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
            ),
            // Show additional transaction details for transaction notifications
            if (notification.type == 'transaction' &&
                notification.metadata != null) ...[
              SizedBox(height: 5.h),
              Text(
                'ເລກອ້າງອີງ: ${notification.metadata!['transaction_id']}',
                style: TextStyle(fontSize: 12.sp, color: Colors.grey[500]),
              ),
              if (notification.metadata!['description'] != null &&
                  notification.metadata!['description'].toString().isNotEmpty)
                Text(
                  'ລາຍລະອຽດ: ${notification.metadata!['description']}',
                  style: TextStyle(fontSize: 10.sp, color: Colors.grey[500]),
                ),
            ],
            SizedBox(height: 5.h),
            Text(
              _formatDateTime(notification.createdAt),
              style: TextStyle(fontSize: 10.sp, color: Colors.grey[500]),
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
    // Navigate to notification detail screen
    context.pushNamed(
      RouteConstants.notificationDetail,
      pathParameters: {'id': notification.id},
    );
  }
}
