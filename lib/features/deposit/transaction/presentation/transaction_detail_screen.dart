import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:moblie_banking/core/utils/app_colors.dart';
import 'package:moblie_banking/core/models/transaction_model.dart';
import 'package:moblie_banking/core/utils/app_image.dart';
import 'package:moblie_banking/widgets/appbar.dart';

class TransactionDetailScreen extends ConsumerWidget {
  final Transaction transaction;
  final String title;

  const TransactionDetailScreen({
    super.key,
    required this.transaction,
    required this.title,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GradientAppBar(title: title, isLogout: false),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            // Bank Header Section
            _buildBankHeader(),
            SizedBox(height: 24.h),

            // Transaction Date and Time
            _buildTransactionDateTime(),
            SizedBox(height: 16.h),

            // Reference Number
            _buildReferenceNumber(),
            SizedBox(height: 24.h),

            // Account Details Section
            _buildAccountDetails(),
            SizedBox(height: 24.h),

            // Transaction Summary
            _buildTransactionSummary(),
            SizedBox(height: 80.h),

            Divider(height: 24.h, color: AppColors.color1),
            SizedBox(height: 80.h),
            _buildActionButtons(),

            // Action Buttons
          ],
        ),
      ),
    );
  }

  Widget _buildBankHeader() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.color1, width: 2)),
      ),
      child: Row(
        children: [
          // Bank Logo
          Container(
            width: 100.w,
            height: 100.w,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppImage.logordb),
                fit: BoxFit.cover,
              ),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 16.w),

          // Bank Name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ທະນາຄານ ພັດທະນາ ຊົນນະບົດ',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Rural Development Bank',
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionDateTime() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.white),
      child: Center(
        child: Text(
          DateFormat(
            'dd/MM/yyyy hh:mm a',
          ).format(DateFormat('dd/MM/yyyy HH:mm').parse(transaction.valuedt)),
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildReferenceNumber() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.white),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ເລກທີອ້າງອີງ:',
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
            ),
            SizedBox(width: 4.w),
            Text(
              transaction.txrefid,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountDetails() {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        children: [
          // From Account
          _buildAccountRow(
            logo: AppImage.logordb,
            name: 'BCEL-PHONGSAVANH BOUBPHACHANH',
            accountId: 'LAK 2211-XXXX-XXXX-5001',
            isFrom: true,
          ),
          SizedBox(height: 10.h),
          // To Account
          _buildAccountRow(
            logo: AppImage.logordb,
            name: 'PHONGSAVANH BOUBPHACHANH MR',
            accountId: 'LAK 2211-XXXX-XXXX-5001',
            isFrom: false,
          ),
        ],
      ),
    );
  }

  Widget _buildAccountRow({
    required String logo,

    required String name,
    required String accountId,
    required bool isFrom,
  }) {
    return Row(
      children: [
        // Logo
        Container(
          width: 50.w,
          height: 50.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: AssetImage(logo)),
          ),
        ),
        SizedBox(width: 16.w),

        // Account Details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4.h),
              Text(
                accountId,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionSummary() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        children: [
          _buildSummaryRow(
            label: 'ຈຳນວນເງິນ',
            value: NumberFormat.currency(
              locale: 'en_US',
              symbol: '',
              decimalDigits: 2,
            ).format(transaction.amt.abs()),
            valueColor: Colors.green[700]!,
            suffix: ' Kip',
          ),
          // Divider(height: 24.h),
          _buildSummaryRow(
            label: 'ຄ່າທຳນຽມ',
            value: '0.00',
            valueColor: Colors.grey[600]!,
            suffix: ' Kip',
          ),
          // Divider(height: 24.h),
          _buildSummaryRow(
            label: 'ລາຍລະອຽດ',
            value: transaction.descr.isNotEmpty ? transaction.descr : 'ເງິນ',
            valueColor: Colors.grey[600]!,
            suffix: '',
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow({
    required String label,
    required String value,
    required Color valueColor,
    required String suffix,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        Row(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 16.sp,
                color: valueColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (suffix.isNotEmpty)
              Text(
                suffix,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: valueColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Save Button
        Container(
          height: 70.h,
          width: 70.w,
          padding: EdgeInsets.symmetric(vertical: 5.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.color1),
          ),
          child: Column(
            children: [
              Icon(Icons.download, color: AppColors.color1, size: 24.sp),
              SizedBox(height: 8.h),
              Text(
                'ບັນທຶກ',
                style: TextStyle(
                  color: AppColors.color1,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        SizedBox(width: 16.w),

        // Share Button
        Container(
          height: 70.h,
          width: 70.w,
          padding: EdgeInsets.symmetric(vertical: 5.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.color1),
          ),
          child: Column(
            children: [
              Icon(Icons.share, color: AppColors.color1, size: 24.sp),
              SizedBox(height: 8.h),
              Text(
                'ແບ່ງປັນ',
                style: TextStyle(
                  color: AppColors.color1,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
