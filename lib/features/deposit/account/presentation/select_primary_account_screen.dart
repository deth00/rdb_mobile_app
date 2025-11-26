import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moblie_banking/core/utils/app_colors.dart';
import 'package:moblie_banking/core/utils/app_image.dart';
import 'package:moblie_banking/widgets/appbar.dart';
import 'package:go_router/go_router.dart';
import 'package:moblie_banking/features/deposit/account/logic/select_primary_account_provider.dart';
import 'package:moblie_banking/features/deposit/account/logic/select_primary_account_state.dart';

class SelectPrimaryAccountScreen extends ConsumerStatefulWidget {
  final String? currentAcno;

  const SelectPrimaryAccountScreen({super.key, this.currentAcno});

  @override
  ConsumerState<SelectPrimaryAccountScreen> createState() =>
      _SelectPrimaryAccountScreenState();
}

class _SelectPrimaryAccountScreenState
    extends ConsumerState<SelectPrimaryAccountScreen> {
  @override
  void initState() {
    super.initState();
    // Clear any previous errors when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(selectPrimaryAccountNotifierProvider.notifier).clearError();
    });
  }

  void _selectAccount(DepositAccount account) {
    ref
        .read(selectPrimaryAccountNotifierProvider.notifier)
        .selectAccount(account);
  }

  void _goToTransactions(DepositAccount account) {
    Navigator.pop(context, account);
  }

  void _showConfirmModal(DepositAccount account) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Row(
            children: [
              Icon(Icons.credit_card, color: AppColors.color1, size: 24.sp),
              SizedBox(width: 8.w),
              Text(
                'ຢືນຢັນການເລືອກບັນຊີຫຼັກ',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ທ່ານຕ້ອງການເລືອກບັນຊີນີ້ເປັນບັນຊີຫຼັກບໍ?',
                style: TextStyle(fontSize: 16.sp, color: Colors.black87),
              ),
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ຊື່ບັນຊີ:',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      account.accountName,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'ເລກບັນຊີ:',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      account.accountNumber,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'ຍອດເງິນ:',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${_formatBalance(account.balance)} ${account.currency}',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'ຍົກເລີກ',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _selectAccount(account);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.color1,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              ),
              child: Text(
                'ຢືນຢັນ',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
              ),
            ),
          ],
          actionsPadding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final accounts = ref.watch(selectPrimaryAccountAccountsProvider);
    final selectedAccount = ref.watch(selectPrimaryAccountSelectedProvider);
    final isLoading = ref.watch(selectPrimaryAccountIsLoadingProvider);
    final isUpdating = ref.watch(selectPrimaryAccountIsUpdatingProvider);
    final errorMessage = ref.watch(selectPrimaryAccountErrorMessageProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildCustomAppBar(),
      body: Column(
        children: [
          // Error message display
          if (errorMessage != null) _buildErrorMessage(errorMessage),

          Expanded(
            child: isLoading
                ? _buildLoadingIndicator()
                : RefreshIndicator(
                    onRefresh: () async {
                      await ref
                          .read(selectPrimaryAccountNotifierProvider.notifier)
                          .refreshAccounts();
                    },
                    child: ListView.builder(
                      padding: EdgeInsets.all(16.w),
                      itemCount: accounts.length,
                      itemBuilder: (context, index) {
                        final account = accounts[index];
                        return _buildAccountCard(account, selectedAccount);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountCard(
    DepositAccount account,
    DepositAccount? selectedAccount,
  ) {
    final isSelected = selectedAccount?.accountNumber == account.accountNumber;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isSelected ? AppColors.color1 : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _goToTransactions(account),
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Account Type
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'ປະເພດ: ${account.accountType}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  // Primary Account Indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '(ບັນຊີຫຼັກ)',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: isSelected
                              ? AppColors.color1
                              : Colors.grey[500],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Checkbox(
                        value: isSelected,
                        onChanged: (bool? value) {
                          if (value == true) {
                            _selectAccount(account);
                          }
                        },
                        activeColor: AppColors.color1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        side: BorderSide(
                          color: isSelected
                              ? AppColors.color1
                              : Colors.grey.shade400,
                          width: 2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Account Name
              Text(
                'ຊື່ບັນຊີ: ${account.accountName}',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),

              // Account Number
              Text(
                'ເລກບັນຊີ: ${account.accountNumber}',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),

              // Balance
              Text(
                'ຍອດເງິນ: ${_formatBalance(account.balance)} ${account.currency}',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatBalance(double balance) {
    return balance
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  Widget _buildErrorMessage(String errorMessage) {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red.shade600,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red.shade700, fontSize: 14.sp),
                ),
              ),
              GestureDetector(
                onTap: () => ref
                    .read(selectPrimaryAccountNotifierProvider.notifier)
                    .clearError(),
                child: Icon(
                  Icons.close,
                  color: Colors.red.shade600,
                  size: 20.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: () async {
                  await ref
                      .read(selectPrimaryAccountNotifierProvider.notifier)
                      .refreshAccounts();
                },
                icon: Icon(
                  Icons.refresh,
                  color: Colors.red.shade600,
                  size: 16.sp,
                ),
                label: Text(
                  'ລອງໃໝ່',
                  style: TextStyle(color: Colors.red.shade600, fontSize: 12.sp),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.color1),
          ),
          SizedBox(height: 16.h),
          Text(
            'ກຳລັງໂຫຼດຂໍ້ມູນ...',
            style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildCustomAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.close, color: Colors.white, size: 24.sp),
              Text(
                'ຍົກເລີກ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.credit_card, color: Colors.white, size: 24.sp),
          SizedBox(width: 8.w),
          Text(
            'ຂໍ້ມູນບັນຊີເງິນຝາກ',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
            ),
          ),
        ],
      ),
      actions: [
        GestureDetector(
          onTap: () => context.goNamed('login'),
          child: Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.logout, color: Colors.white, size: 24.sp),
                Text(
                  'ອອກລະບົບ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
      flexibleSpace: Container(
        decoration: BoxDecoration(gradient: AppColors.main),
      ),
    );
  }
}
