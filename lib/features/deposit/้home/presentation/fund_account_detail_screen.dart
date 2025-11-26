import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:moblie_banking/core/utils/app_colors.dart';
import 'package:moblie_banking/core/utils/app_image.dart';
import 'package:moblie_banking/features/deposit/้home/logic/fund_account_provider.dart';
import 'package:moblie_banking/widgets/appbar.dart';

class FundAccountDetailScreen extends ConsumerStatefulWidget {
  final String acno;

  const FundAccountDetailScreen({super.key, required this.acno});

  @override
  ConsumerState<FundAccountDetailScreen> createState() =>
      _FundAccountDetailScreenState();
}

class _FundAccountDetailScreenState
    extends ConsumerState<FundAccountDetailScreen> {
  bool isVisible = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(fundAccountNotifierProvider.notifier)
          .getFundAccountDetail(widget.acno);
    });
  }

  /// ບໍ່ໃຫ້ເຫັນໂຕເລກບາງສ່ວນ
  String _maskAccount(String acNo) {
    if (acNo.length < 10) return 'xxxx';
    return '${acNo.substring(0, 3)} xxxx xxxx ${acNo.substring(acNo.length - 3)}';
  }

  @override
  Widget build(BuildContext context) {
    final fundAccountState = ref.watch(fundAccountNotifierProvider);

    return Scaffold(
      appBar: GradientAppBar(title: 'ລາຍລະອຽດບັນຊີ', isLogout: false),
      body: SafeArea(
        child: fundAccountState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : fundAccountState.errorMessage != null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 64.sp),
                    SizedBox(height: 20.h),
                    Text(
                      fundAccountState.errorMessage!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red, fontSize: 16.sp),
                    ),
                    SizedBox(height: 20.h),
                    ElevatedButton(
                      onPressed: () {
                        ref
                            .read(fundAccountNotifierProvider.notifier)
                            .clearError();
                        ref
                            .read(fundAccountNotifierProvider.notifier)
                            .getFundAccountDetail(widget.acno);
                      },
                      child: Text('ລອງໃໝ່', style: TextStyle(fontSize: 16.sp)),
                    ),
                  ],
                ),
              )
            : fundAccountState.fundAccountDetail != null
            ? SingleChildScrollView(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAccountCard(fundAccountState.fundAccountDetail!),
                    SizedBox(height: 20.h),
                    _buildDetailsCard(fundAccountState.fundAccountDetail!),
                    SizedBox(height: 20.h),
                    _buildContactCard(fundAccountState.fundAccountDetail!),
                  ],
                ),
              )
            : Center(
                child: Text(
                  'ບໍ່ມີຂໍ້ມູນບັນຊີ',
                  style: TextStyle(fontSize: 16.sp),
                ),
              ),
      ),
    );
  }

  Widget _buildAccountCard(dynamic fundAccount) {
    final currencyFormat = NumberFormat.currency(locale: 'lo_LA', symbol: '₭');

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: AppColors.main,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8.r,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ບັນຊີເງິນຝາກ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15.h),
          Text(
            fundAccount.acName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10.h),
          // 🔒 ເລກບັນຊີ with show/hide functionality
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isVisible ? fundAccount.acNo : _maskAccount(fundAccount.acNo),
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isVisible = !isVisible;
                  });
                },
                child: Container(
                  height: 30.h,
                  width: 60.w,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Center(
                    child: Text(
                      isVisible ? 'ປິດ' : 'ສະແດງ',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ຍອດເງິນ',
                    style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                  ),
                  Row(
                    children: [
                      SizedBox(width: 5.w),
                      Text(
                        isVisible
                            ? currencyFormat.format(fundAccount.balance)
                            : 'xxxxx',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'ດອກເບ້ຍ',
                    style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(width: 5.w),
                      Text(
                        isVisible
                            ? currencyFormat.format(fundAccount.intpbl)
                            : 'xxxxx',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard(dynamic fundAccount) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8.r,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ລາຍລະອຽດບັນຊີ',
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20.h),
          _buildDetailRow('ປະເພດບັນຊີ', fundAccount.catname),
          SizedBox(height: 15.h),
          _buildDetailRow('ຍອດເງິນຕ່ຳສຸດ', '${fundAccount.minAmt} ₭'),
        ],
      ),
    );
  }

  Widget _buildContactCard(dynamic fundAccount) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8.r,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ຂໍ້ມູນຕິດຕໍ່',
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20.h),
          if (fundAccount.mphone.hp.isNotEmpty)
            _buildDetailRow('ເບີໂທລະສັບ', fundAccount.mphone.hp),
          if (fundAccount.mphone.hp.isNotEmpty) SizedBox(height: 15.h),
          if (fundAccount.mphone.fp.isNotEmpty)
            _buildDetailRow('ເບີແຟັກ', fundAccount.mphone.fp),
          if (fundAccount.mphone.fp.isNotEmpty) SizedBox(height: 15.h),
          if (fundAccount.mphone.cp.isNotEmpty)
            _buildDetailRow('ເບີມືຖື', fundAccount.mphone.cp),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100.w,
          child: Text(
            label,
            style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
