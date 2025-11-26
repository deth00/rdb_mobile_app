import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moblie_banking/core/utils/app_colors.dart';
import 'package:moblie_banking/core/utils/app_image.dart';
import 'package:moblie_banking/widgets/appbar.dart';

class NotificationDetailScreen extends StatelessWidget {
  final String? notificationId;

  const NotificationDetailScreen({super.key, this.notificationId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GradientAppBar(title: ''),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date and Time Section
          _buildDateTimeSection(),
          SizedBox(height: 24.h),

          // Account Information Section
          _buildAccountSection(),
          SizedBox(height: 24.h),

          // Transaction Summary Section
          _buildTransactionSummary(),
        ],
      ),
    );
  }

  Widget _buildDateTimeSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        children: [
          Text(
            '15/02/2024 10:02 AM',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'ເລກທີອ້າງອີງ',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                '0201HO021224',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Source Account
          _buildAccountItem(
            logo: 'BCEL',
            accountName: 'BCEL-PHONGSAVANH BOUBP...',
            accountNumber: 'LAK 2211-XXXX-XXXX-5001',
            label: 'ຕົ້ນທາງ',
          ),

          SizedBox(height: 16.h),

          // Destination Account
          _buildAccountItem(
            logo: 'RDB',
            accountName: 'PHONGSAVANH BOUBPHACHANH MR',
            accountNumber: 'LAK 2211-XXXX-XXXX-5001',
            label: 'ປາຍທາງ',
          ),
        ],
      ),
    );
  }

  Widget _buildAccountItem({
    required String logo,
    required String accountName,
    required String accountNumber,
    required String label,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          // Logo Circle
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue.shade100,
            ),
            child: Center(
              child: Text(
                logo,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
            ),
          ),

          SizedBox(width: 16.w),

          // Account Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  accountName,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  accountNumber,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Label
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: Colors.blue.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionSummary() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ສະຫຼຸບການເຄື່ອນໄຫວ',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 20.h),

          // Amount
          _buildSummaryRow(
            label: 'ຈໍານວນເງິນ',
            value: '200,000,000.00 Kip',
            valueColor: Colors.green.shade600,
            isAmount: true,
          ),

          Divider(height: 24.h, color: Colors.grey.shade300),

          // Fee
          _buildSummaryRow(
            label: 'ຄ່າທໍານຽມ',
            value: '0.00 Kip',
            valueColor: Colors.grey.shade600,
          ),

          Divider(height: 24.h, color: Colors.grey.shade300),

          // Description
          _buildSummaryRow(
            label: 'ລາຍລະອຽດ',
            value: 'ເງິນຕິບ',
            valueColor: Colors.black87,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow({
    required String label,
    required String value,
    required Color valueColor,
    bool isAmount = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isAmount ? 18.sp : 16.sp,
            color: valueColor,
            fontWeight: isAmount ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
