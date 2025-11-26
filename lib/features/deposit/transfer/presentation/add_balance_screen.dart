import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moblie_banking/core/utils/app_colors.dart';
import 'package:moblie_banking/features/deposit/transfer/logic/transfer_provider.dart';
import 'package:moblie_banking/features/deposit/transfer/logic/transfer_state.dart';
import 'package:moblie_banking/core/utils/snackbar_helper.dart';
import 'package:moblie_banking/widgets/appbar.dart';

class AddBalanceScreen extends ConsumerStatefulWidget {
  const AddBalanceScreen({super.key});

  @override
  ConsumerState<AddBalanceScreen> createState() => _AddBalanceScreenState();
}

class _AddBalanceScreenState extends ConsumerState<AddBalanceScreen> {
  final TextEditingController _amountController = TextEditingController();
  bool _acceptedTerms = false;
  bool _isSubmitting = false;
  TransferState? _previousState;

  @override
  void initState() {
    super.initState();
    // Load current user limit
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(transferNotifierProvider.notifier).getUserLimit();
      }
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final transferState = ref.watch(transferNotifierProvider);

    // Handle state changes
    _handleStateChanges(transferState);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GradientAppBar(title: 'ເພີ່ມວົງເງິນການໂອນ'),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // Current limit info
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 10.h),
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'ລິມິດປັດຈຸບັນ',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    height: 50.h,
                    width: double.infinity,
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(15.r),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Text(
                      '${_formatCurrency(transferState.userLimit?.transferLimit ?? 0)} LAK',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.color1,
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  // New limit input
                  Text(
                    'ລິມິດໃໝ່',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    height: 50.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.r),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'ປ້ອນຈຳນວນເງິນ',
                        hintStyle: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[400],
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.r),
                          borderSide: BorderSide(color: Colors.grey[400]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.r),
                          borderSide: BorderSide(color: Colors.grey[400]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.r),
                          borderSide: BorderSide(color: AppColors.color1),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 15.w,
                          vertical: 15.h,
                        ),
                        suffixText: 'LAK',
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'ສາມາດເພີ່ມໄດ້ສູງສຸດ ${_formatCurrency(2000000000 - (transferState.userLimit?.transferLimit ?? 0))} LAK',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

            // Service details
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              margin: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5.r,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ລາຍລະອຽດບໍລິການ',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 15.h),
                  _buildServiceDetail(
                    'ວົງເງິນການໂອນສູງສຸດ/ມື້',
                    '2,000,000,000 LAK',
                  ),
                  SizedBox(height: 15.h),
                  _buildServiceDetail('ຄ່າທໍານຽມ/ເດືອນ', '20,000 LAK'),
                  SizedBox(height: 15.h),
                  _buildServiceDetail('ໄລຍະເວລາທີ່ນໍາໃຊ້ຂັ້ນຕໍ່າ', '2 ເດືອນ'),
                ],
              ),
            ),

            // Terms and conditions
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              margin: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5DC), // Light beige background
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ຂໍ້ກຳນົດ ແລະ ເງື່ອນໄຂ',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 15.h),
                  _buildTermItem(
                    'ວົງເງິນການໂອນເພີ່ມເຕີມ 2,000,000,000 LAK/ມື້',
                  ),
                  _buildTermItem(
                    'ຄ່າທໍານຽມເພີ່ມລິມິດ 20,000 LAK/ເດືອນ ຈະຖືກຫັກອັດຕະໂນມັດຫຼັງຈາກສະໝັກ ແລະ ເດືອນຕໍ່ໄປຈະຍົກເລີກ',
                  ),
                  _buildTermItem(
                    'ລູກຄ້າສາມາດຍົກເລີກໄດ້ຫຼັງຈາກໃຊ້ງານຂັ້ນຕໍ່າສຸດ 2 ເດືອນ',
                  ),
                  _buildTermItem(
                    'ຄ່າທໍານຽມການໂອນຈະຖືກຫັກຕາມປົກກະຕິ ຖ້າຈຳນວນເງິນໂອນສະສົມເກີນ 15,000,000 LAK/ເດືອນ',
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _acceptedTerms = !_acceptedTerms;
                          });
                        },
                        child: Container(
                          width: 30.w,
                          height: 30.h,
                          decoration: BoxDecoration(
                            color: _acceptedTerms
                                ? AppColors.color1
                                : Colors.white,
                            borderRadius: BorderRadius.circular(4.r),
                            border: Border.all(
                              color: _acceptedTerms
                                  ? AppColors.color1
                                  : Colors.grey,
                            ),
                          ),
                          child: _acceptedTerms
                              ? Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 20.sp,
                                )
                              : null,
                        ),
                      ),
                      SizedBox(width: 15.w),
                      Expanded(
                        child: Text(
                          'ຍອມຮັບຂໍ້ກໍານົດ ແລະ ເງື່ອນໄຂ',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildSubmitButton(context, transferState),
    );
  }

  void _handleStateChanges(TransferState currentState) {
    // Check if this is a new state (not the initial build)
    if (_previousState != null) {
      // Handle success state
      if (currentState.isLimitUpdateSuccess &&
          currentState.successMessage != null &&
          !_previousState!.isLimitUpdateSuccess) {
        // Schedule snackbar to show after build is complete
        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            showCustomSnackBar(
              context,
              currentState.successMessage!,
              isError: false,
            );
            setState(() {
              _isSubmitting = false;
            });
          }
        });
        // Reset success state after showing message
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            ref.read(transferNotifierProvider.notifier).clearSuccess();
          }
        });
        if (mounted) {
          Navigator.of(context).pop();
        }
      }

      // Handle error state
      if (currentState.errorMessage != null &&
          currentState.errorMessage != _previousState!.errorMessage) {
        final isServerError =
            currentState.errorMessage!.contains('500') ||
            currentState.errorMessage!.contains('ເກີດຂໍ້ຜິດພາດທາງເຊີເວີ');

        // Schedule snackbar to show after build is complete
        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            showCustomSnackBar(
              context,
              currentState.errorMessage!,
              isError: true,
            );
            setState(() {
              _isSubmitting = false;
            });
          }
        });

        // Show retry dialog for server errors
        if (isServerError) {
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              _showRetryDialog();
            }
          });
        }

        // Clear error after showing message
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            ref.read(transferNotifierProvider.notifier).clearError();
          }
        });
      }
    }

    // Update previous state
    _previousState = currentState;
  }

  Widget _buildServiceDetail(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: 14.sp, color: Colors.black87),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.color1,
          ),
        ),
      ],
    );
  }

  Widget _buildTermItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(fontSize: 14.sp, color: Colors.black87),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14.sp, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context, transferState) {
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    final currentLimit = transferState.userLimit?.transferLimit ?? 0;
    final maxLimit = 2000000000.0; // 2,000,000,000 LAK maximum
    final isValid =
        amount > 0 &&
        amount > currentLimit &&
        amount <= maxLimit &&
        _acceptedTerms &&
        !transferState.isLoading &&
        !_isSubmitting;

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5.r,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 60.h,
        child: ElevatedButton(
          onPressed: isValid ? () => _handleSubmit() : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: isValid ? AppColors.color1 : Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.r),
            ),
          ),
          child: transferState.isLoading
              ? SizedBox(
                  width: 30.w,
                  height: 30.h,
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  'ສະໝັກເພີ່ມລິມິດ',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }

  void _handleSubmit() {
    if (!mounted || _isSubmitting) return;

    final amount = double.tryParse(_amountController.text) ?? 0.0;
    final currentLimit =
        ref.read(transferNotifierProvider).userLimit?.transferLimit ?? 0;
    final maxLimit = 2000000000.0; // 2,000,000,000 LAK maximum

    // Check if amount is valid
    if (amount <= 0) {
      showCustomSnackBar(
        context,
        'ກະລຸນາປ້ອນຈຳນວນເງິນທີ່ຖືກຕ້ອງ',
        isError: true,
      );
      return;
    }

    // Check if amount exceeds maximum limit
    if (amount > maxLimit) {
      showCustomSnackBar(
        context,
        'ລິມິດສູງສຸດທີ່ອະນຸຍາດແມ່ນ ${_formatCurrency(maxLimit)} LAK',
        isError: true,
      );
      return;
    }

    // Check if new amount is less than or equal to current limit
    if (amount <= currentLimit) {
      showCustomSnackBar(
        context,
        'ລິມິດໃໝ່ຕ້ອງຫຼາຍກວ່າລິມິດປັດຈຸບັນ (${_formatCurrency(currentLimit)} LAK)',
        isError: true,
      );
      return;
    }

    if (!_acceptedTerms) {
      showCustomSnackBar(
        context,
        'ກະລຸນາຍອມຮັບຂໍ້ກໍານົດ ແລະ ເງື່ອນໄຂ',
        isError: true,
      );
      return;
    }

    if (mounted) {
      setState(() {
        _isSubmitting = true;
      });
      ref.read(transferNotifierProvider.notifier).updateTransferLimit(amount);
    }
  }

  String _formatCurrency(double amount) {
    return amount
        .toStringAsFixed(2)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match match) => '${match[1]},',
        );
  }

  void _showRetryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ເກີດຂໍ້ຜິດພາດທາງເຊີເວີ123'),
        content: const Text('ກະລຸນາລອງໃໝ່ອີກຄັ້ງ ຫຼື ຕິດຕໍ່ຜູ້ໃຫ້ບໍລິການ'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('ຍົກເລີກ'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (mounted) {
                _handleSubmit(); // Retry the operation
              }
            },
            child: const Text('ລອງໃໝ່'),
          ),
        ],
      ),
    );
  }
}
