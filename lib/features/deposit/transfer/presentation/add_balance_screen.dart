import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    // Load current user limit
    Future.microtask(() {
      ref.read(transferNotifierProvider.notifier).getUserLimit();
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final fixedSize = size.width + size.height;
    final transferState = ref.watch(transferNotifierProvider);

    // Listen for success state
    ref.listen<TransferState>(transferNotifierProvider, (previous, next) {
      if (next.isLimitUpdateSuccess && next.successMessage != null) {
        showCustomSnackBar(context, next.successMessage!, isError: false);
        // Reset success state after showing message
        Future.delayed(const Duration(milliseconds: 500), () {
          ref.read(transferNotifierProvider.notifier).clearSuccess();
        });
        Navigator.of(context).pop();
      }
      if (next.errorMessage != null) {
        final isServerError =
            next.errorMessage!.contains('500') ||
            next.errorMessage!.contains('ເກີດຂໍ້ຜິດພາດທາງເຊີເວີ');

        showCustomSnackBar(context, next.errorMessage!, isError: true);

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
          ref.read(transferNotifierProvider.notifier).clearError();
        });
      }
    });

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
              margin: EdgeInsets.symmetric(horizontal: fixedSize * 0.02),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(fixedSize * 0.02),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'ລິມິດປັດຈຸບັນ',
                    style: TextStyle(
                      fontSize: fixedSize * 0.014,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: fixedSize * 0.005),
                  Container(
                    height: 50.h,
                    width: double.infinity,
                    padding: EdgeInsets.all(fixedSize * 0.008),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(fixedSize * 0.01),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Text(
                      '${_formatCurrency(transferState.userLimit?.transferLimit ?? 0)} LAK',
                      style: TextStyle(
                        fontSize: fixedSize * 0.016,
                        fontWeight: FontWeight.bold,
                        color: AppColors.color1,
                      ),
                    ),
                  ),
                  SizedBox(height: fixedSize * 0.008),
                  // New limit input
                  Text(
                    'ລິມິດໃໝ່',
                    style: TextStyle(
                      fontSize: fixedSize * 0.014,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: fixedSize * 0.005),
                  Container(
                    height: 50.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(fixedSize * 0.01),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'ປ້ອນຈຳນວນເງິນ',
                        hintStyle: TextStyle(
                          fontSize: fixedSize * 0.012,
                          color: Colors.grey[400],
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(fixedSize * 0.01),
                          borderSide: BorderSide(color: Colors.grey[400]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(fixedSize * 0.01),
                          borderSide: BorderSide(color: Colors.grey[400]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(fixedSize * 0.01),
                          borderSide: BorderSide(color: AppColors.color1),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: fixedSize * 0.015,
                          vertical: fixedSize * 0.015,
                        ),
                        suffixText: 'LAK',
                      ),
                    ),
                  ),
                  SizedBox(height: fixedSize * 0.005),
                  Text(
                    'ສາມາດເພີ່ມໄດ້ສູງສຸດ ${_formatCurrency(2000000000 - (transferState.userLimit?.transferLimit ?? 0))} LAK',
                    style: TextStyle(
                      fontSize: fixedSize * 0.009,
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
              padding: EdgeInsets.all(fixedSize * 0.02),
              margin: EdgeInsets.all(fixedSize * 0.02),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(fixedSize * 0.02),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
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
                      fontSize: fixedSize * 0.014,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: fixedSize * 0.01),
                  _buildServiceDetail(
                    'ວົງເງິນການໂອນສູງສຸດ/ມື້',
                    '2,000,000,000 LAK',
                    fixedSize,
                  ),
                  SizedBox(height: fixedSize * 0.01),
                  _buildServiceDetail(
                    'ຄ່າທໍານຽມ/ເດືອນ',
                    '20,000 LAK',
                    fixedSize,
                  ),
                  SizedBox(height: fixedSize * 0.01),
                  _buildServiceDetail(
                    'ໄລຍະເວລາທີ່ນໍາໃຊ້ຂັ້ນຕໍ່າ',
                    '2 ເດືອນ',
                    fixedSize,
                  ),
                ],
              ),
            ),

            // Terms and conditions
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(fixedSize * 0.02),
              margin: EdgeInsets.all(fixedSize * 0.02),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5DC), // Light beige background
                borderRadius: BorderRadius.circular(fixedSize * 0.02),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ຂໍ້ກຳນົດ ແລະ ເງື່ອນໄຂ',
                    style: TextStyle(
                      fontSize: fixedSize * 0.014,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: fixedSize * 0.01),
                  _buildTermItem(
                    'ວົງເງິນການໂອນເພີ່ມເຕີມ 2,000,000,000 LAK/ມື້',
                    fixedSize,
                  ),
                  _buildTermItem(
                    'ຄ່າທໍານຽມເພີ່ມລິມິດ 20,000 LAK/ເດືອນ ຈະຖືກຫັກອັດຕະໂນມັດຫຼັງຈາກສະໝັກ ແລະ ເດືອນຕໍ່ໄປຈົນກວ່າຈະຍົກເລີກ',
                    fixedSize,
                  ),
                  _buildTermItem(
                    'ລູກຄ້າສາມາດຍົກເລີກໄດ້ຫຼັງຈາກໃຊ້ງານຂັ້ນຕໍ່າສຸດ 2 ເດືອນ',
                    fixedSize,
                  ),
                  _buildTermItem(
                    'ຄ່າທໍານຽມການໂອນຈະຖືກຫັກຕາມປົກກະຕິ ຖ້າຈຳນວນເງິນໂອນສະສົມເກີນ 15,000,000 LAK/ເດືອນ',
                    fixedSize,
                  ),
                  SizedBox(height: fixedSize * 0.015),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _acceptedTerms = !_acceptedTerms;
                          });
                        },
                        child: Container(
                          width: fixedSize * 0.025,
                          height: fixedSize * 0.025,
                          decoration: BoxDecoration(
                            color: _acceptedTerms
                                ? AppColors.color1
                                : Colors.white,
                            borderRadius: BorderRadius.circular(4),
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
                                  size: fixedSize * 0.015,
                                )
                              : null,
                        ),
                      ),
                      SizedBox(width: fixedSize * 0.01),
                      Expanded(
                        child: Text(
                          'ຍອມຮັບຂໍ້ກໍານົດ ແລະ ເງື່ອນໄຂ',
                          style: TextStyle(
                            fontSize: fixedSize * 0.012,
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
      bottomNavigationBar: _buildSubmitButton(
        context,
        fixedSize,
        transferState,
      ),
    );
  }

  Widget _buildServiceDetail(String label, String value, double fixedSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: fixedSize * 0.011,
              color: Colors.black87,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: fixedSize * 0.011,
            fontWeight: FontWeight.bold,
            color: AppColors.color1,
          ),
        ),
      ],
    );
  }

  Widget _buildTermItem(String text, double fixedSize) {
    return Padding(
      padding: EdgeInsets.only(bottom: fixedSize * 0.008),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(
              fontSize: fixedSize * 0.011,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: fixedSize * 0.011,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(
    BuildContext context,
    double fixedSize,
    transferState,
  ) {
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    final currentLimit = transferState.userLimit?.transferLimit ?? 0;
    final maxLimit = 2000000000.0; // 2,000,000,000 LAK maximum
    final isValid =
        amount > 0 &&
        amount > currentLimit &&
        amount <= maxLimit &&
        _acceptedTerms &&
        !transferState.isLoading;

    return Container(
      padding: EdgeInsets.all(fixedSize * 0.02),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: fixedSize * 0.06,
        child: ElevatedButton(
          onPressed: isValid ? () => _handleSubmit() : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: isValid ? AppColors.color1 : Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(fixedSize * 0.03),
            ),
          ),
          child: transferState.isLoading
              ? SizedBox(
                  width: fixedSize * 0.025,
                  height: fixedSize * 0.025,
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  'ສະໝັກເພີ່ມລິມິດ',
                  style: TextStyle(
                    fontSize: fixedSize * 0.014,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }

  void _handleSubmit() {
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

    ref.read(transferNotifierProvider.notifier).updateTransferLimit(amount);
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
        title: const Text('ເກີດຂໍ້ຜິດພາດທາງເຊີເວີ'),
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
              _handleSubmit(); // Retry the operation
            },
            child: const Text('ລອງໃໝ່'),
          ),
        ],
      ),
    );
  }
}
