import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:moblie_banking/core/utils/app_colors.dart';
import 'package:moblie_banking/core/utils/app_image.dart';
import 'package:moblie_banking/features/deposit/transfer/logic/transfer_provider.dart';
import 'package:moblie_banking/features/deposit/้home/logic/dpt_provider.dart';
import 'package:moblie_banking/features/deposit/transfer/presentation/confirm_transfer_money.dart';
import 'package:moblie_banking/features/home/logic/home_provider.dart';
import 'package:moblie_banking/widgets/appbar.dart';
import 'package:moblie_banking/core/utils/snackbar_helper.dart';
import 'package:moblie_banking/features/deposit/transfer/logic/transfer_state.dart';

class AddTransferMoney extends ConsumerStatefulWidget {
  final String acno;
  const AddTransferMoney({super.key, required this.acno});

  @override
  ConsumerState<AddTransferMoney> createState() => _AddTransferMoneyState();
}

class _AddTransferMoneyState extends ConsumerState<AddTransferMoney> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final state = ref.read(homeNotifierProvider);
      ref.read(transferNotifierProvider.notifier).getAccountDetail(widget.acno);
      ref.read(transferNotifierProvider.notifier).getUserLimit();
      if (state.accountDpt.isNotEmpty) {
        ref
            .read(dptNotifierProvider.notifier)
            .getAccountDetail(state.accountDpt.first.linkValue);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh user limit when screen becomes active
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(transferNotifierProvider.notifier).getUserLimit();
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final fixedSize = size.width + size.height;
    final acno = ref.watch(dptNotifierProvider);
    final receiverAcno = ref.watch(transferNotifierProvider);

    // Listen for limit updates and refresh when returning from add balance screen
    ref.listen<TransferState>(transferNotifierProvider, (previous, next) {
      if (previous?.userLimit?.transferLimit != next.userLimit?.transferLimit) {
        // Limit was updated, refresh the display
        setState(() {});
      }

      // Handle errors
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
      appBar: GradientAppBar(title: 'ໂອນເງິນ'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(fixedSize * 0.01),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(fixedSize * 0.02),
                  topRight: Radius.circular(fixedSize * 0.02),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAccountInfo(
                    fixedSize,
                    title: 'ຕົ້ນທາງ',
                    icon: AppImage.logoRDB,
                    bankName: 'ທະນາຄານ ພັດທະນາ ຊົນນະບົດ',
                    accountHolder:
                        'ບັນຊີເງິນຝາກ', // Default account holder name
                    accountNumber: _maskAccount(acno.accountDetail?.acNo ?? ''),
                  ),
                  SizedBox(height: fixedSize * 0.01),
                  _buildAccountInfo(
                    fixedSize,
                    title: 'ປາຍທາງ',
                    icon: AppImage.cop,
                    bankName: 'ທະນາຄານ ພັດທະນາລາວ',
                    accountHolder:
                        receiverAcno.receiverAccount?.accountName ?? '',
                    accountNumber: _maskAccount(
                      receiverAcno.receiverAccount?.accountNumber ?? '',
                    ),
                  ),
                  SizedBox(height: fixedSize * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'ວົງເງິນໂອນສູງສຸດ ${_formatCurrency(receiverAcno.userLimit?.transferLimit ?? 150000000)} LAK',
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontSize: fixedSize * 0.01,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.pushNamed('addBalance');
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: fixedSize * 0.015,
                            vertical: fixedSize * 0.008,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.color1,
                            borderRadius: BorderRadius.circular(
                              fixedSize * 0.01,
                            ),
                          ),
                          child: Text(
                            'ເພີ່ມລິມິດ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: fixedSize * 0.009,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: fixedSize * 0.01),
                  _buildAmountField(fixedSize),
                  SizedBox(height: fixedSize * 0.01),
                  _buildDetailsField(fixedSize),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildContinueButton(context, fixedSize),
    );
  }

  Widget _buildAccountInfo(
    double fixedSize, {
    required String title,
    required String icon,
    required String bankName,
    required String accountHolder,
    required String accountNumber,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontSize: fixedSize * 0.014,
            fontWeight: FontWeight.bold,
          ),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: fixedSize * 0.02,
            child: SvgPicture.asset(icon),
          ),
          title: Text(
            bankName,
            style: TextStyle(
              color: Colors.black,
              fontSize: fixedSize * 0.011,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                accountHolder,
                style: TextStyle(
                  fontSize: fixedSize * 0.01,
                  color: Colors.black87,
                ),
              ),
              Text(
                accountNumber,
                style: TextStyle(
                  fontSize: fixedSize * 0.01,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildAmountField(double fixedSize) {
    final transferState = ref.watch(transferNotifierProvider);
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    final userLimit = transferState.userLimit?.transferLimit ?? 150000000;
    final isAmountValid = amount > 0 && amount <= userLimit;
    final showError = _amountController.text.isNotEmpty && !isAmountValid;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'ຈຳນວນເງິນ ',
            style: TextStyle(
              fontSize: fixedSize * 0.012,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
            children: const <TextSpan>[
              TextSpan(
                text: '*',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
        SizedBox(height: fixedSize * 0.005),
        Row(
          children: [
            Expanded(
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
                    borderSide: BorderSide(
                      color: showError ? Colors.red : Colors.grey[400]!,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(fixedSize * 0.01),
                    borderSide: BorderSide(
                      color: showError ? Colors.red : Colors.grey[400]!,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(fixedSize * 0.01),
                    borderSide: BorderSide(
                      color: showError ? Colors.red : AppColors.color1,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: fixedSize * 0.01,
                    vertical: fixedSize * 0.01,
                  ),
                ),
              ),
            ),
            SizedBox(width: fixedSize * 0.005),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: fixedSize * 0.015,
                vertical: fixedSize * 0.012,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[400]!),
                borderRadius: BorderRadius.circular(fixedSize * 0.01),
              ),
              child: Text(
                '.00',
                style: TextStyle(
                  fontSize: fixedSize * 0.012,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
        if (showError) ...[
          SizedBox(height: fixedSize * 0.005),
          Text(
            amount > userLimit
                ? 'ຈຳນວນເງິນເກີນລິມິດທີ່ອະນຸຍາດ (${_formatCurrency(userLimit)} LAK)'
                : 'ກະລຸນາປ້ອນຈຳນວນເງິນທີ່ຖືກຕ້ອງ',
            style: TextStyle(color: Colors.red, fontSize: fixedSize * 0.009),
          ),
        ],
      ],
    );
  }

  Widget _buildDetailsField(double fixedSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'ລາຍລະອຽດ ',
            style: TextStyle(
              fontSize: fixedSize * 0.012,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
            children: const <TextSpan>[
              TextSpan(
                text: '*',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
        SizedBox(height: fixedSize * 0.005),
        TextField(
          controller: _detailsController,
          decoration: InputDecoration(
            hintText: 'ລາຍລະອຽດ',
            hintStyle: TextStyle(
              fontSize: fixedSize * 0.012,
              color: Colors.grey[400],
            ),
            prefixIcon: Padding(
              padding: EdgeInsets.all(fixedSize * 0.008),
              child: SvgPicture.asset(AppImage.feedback, width: 20.w),
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
              horizontal: fixedSize * 0.01,
              vertical: fixedSize * 0.01,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContinueButton(BuildContext context, double fixedSize) {
    final transferState = ref.watch(transferNotifierProvider);
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    final userLimit = transferState.userLimit?.transferLimit ?? 150000000;
    final isAmountValid = amount > 0 && amount <= userLimit;
    final isDetailsValid = _detailsController.text.trim().isNotEmpty;

    return GestureDetector(
      onTap: () {
        if (!isAmountValid) {
          if (amount <= 0) {
            showCustomSnackBar(
              context,
              'ກະລຸນາປ້ອນຈຳນວນເງິນທີ່ຖືກຕ້ອງ',
              isError: true,
            );
          } else if (amount > userLimit) {
            showCustomSnackBar(
              context,
              'ຈຳນວນເງິນເກີນລິມິດທີ່ອະນຸຍາດ (${_formatCurrency(userLimit)} LAK)',
              isError: true,
            );
          }
          return;
        }

        if (!isDetailsValid) {
          showCustomSnackBar(context, 'ກະລຸນາປ້ອນລາຍລະອຽດ', isError: true);
          return;
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ConfirmTransferMoneyScreen(),
          ),
        );
      },
      child: Container(
        height: fixedSize * 0.06,
        width: double.infinity,
        color: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: fixedSize * 0.02,
          vertical: fixedSize * 0.01,
        ),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isAmountValid && isDetailsValid
                ? AppColors.color1
                : Colors.grey,
            borderRadius: BorderRadius.circular(fixedSize * 0.03),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'ຕໍ່ໄປ',
                style: TextStyle(
                  fontSize: fixedSize * 0.014,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: fixedSize * 0.02,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _maskAccount(String acNo) {
    if (acNo.length < 10) return 'xxxx';
    return '${acNo.substring(0, 3)} xxxx xxxx ${acNo.substring(acNo.length - 3)}';
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
              // Retry getting account details and user limit
              ref
                  .read(transferNotifierProvider.notifier)
                  .getAccountDetail(widget.acno);
              ref.read(transferNotifierProvider.notifier).getUserLimit();
            },
            child: const Text('ລອງໃໝ່'),
          ),
        ],
      ),
    );
  }
}
