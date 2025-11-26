import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import 'package:moblie_banking/core/utils/app_colors.dart';
import 'package:moblie_banking/core/utils/app_image.dart';
import 'package:moblie_banking/features/deposit/transfer/logic/transfer_provider.dart';
import 'package:moblie_banking/features/deposit/้home/logic/fund_account_provider.dart';
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
  bool _isInitialized = false;
  bool _isInitializing = false;
  bool _hasNavigatedAway =
      false; // Add flag to track if user has navigated away
  TransferState? _previousTransferState;

  @override
  void initState() {
    super.initState();
    // Use Future.microtask to avoid modifying providers during widget lifecycle
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_hasNavigatedAway) {
        _initializeData();
      }
    });
  }

  Future<void> _initializeData() async {
    if (_isInitializing || _hasNavigatedAway)
      return; // Prevent multiple initialization calls

    try {
      _isInitializing = true;

      // Clear any previous state to prevent stale data
      ref.read(transferNotifierProvider.notifier).clearError();
      ref.read(transferNotifierProvider.notifier).clearSuccess();

      // Validate account number from QR scan
      if (widget.acno.isEmpty || widget.acno.trim().isEmpty) {
        if (mounted && !_hasNavigatedAway) {
          _showErrorDialog('ເລກບັນຊີບໍ່ຖືກຕ້ອງ', 'ກະລຸນາສະແກນ QR Code ໃໝ່');
        }
        return;
      }

      // Clean the account number (remove any non-digit characters)
      final cleanAcno = widget.acno.replaceAll(RegExp(r'[^\d]'), '');

      if (cleanAcno.length < 8 || cleanAcno.length > 20) {
        if (mounted && !_hasNavigatedAway) {
          _showErrorDialog('ເລກບັນຊີບໍ່ຖືກຕ້ອງ', 'ກະລຸນາສະແກນ QR Code ໃໝ່');
        }
        return;
      }

      // Load initial data
      if (!mounted || _hasNavigatedAway) return;
      final state = ref.read(homeNotifierProvider);

      try {
        // Get account details and user limit with timeout

        await Future.wait([
          ref
              .read(transferNotifierProvider.notifier)
              .getAccountDetail(cleanAcno),
          ref.read(transferNotifierProvider.notifier).getUserLimit(),
        ]).timeout(
          const Duration(seconds: 30),
          onTimeout: () {
            throw TimeoutException(
              'Request timeout',
              const Duration(seconds: 30),
            );
          },
        );

        // Check if account details were loaded successfully
        final transferState = ref.read(transferNotifierProvider);
        if (transferState.receiverAccount == null &&
            transferState.errorMessage != null) {
          if (mounted && !_hasNavigatedAway) {
            _showErrorDialog(
              'ບໍ່ພົບເລກບັນຊີ',
              'ກະລຸນາກວດສອບເລກບັນຊີ ຫຼື ສະແກນ QR Code ໃໝ່',
            );
          }
          return;
        }

        // Get fund account details if available
        if (state.accountDpt.isNotEmpty && mounted && !_hasNavigatedAway) {
          try {
            await ref
                .read(fundAccountNotifierProvider.notifier)
                .getFundAccountDetail(state.accountDpt.first.linkValue)
                .timeout(
                  const Duration(seconds: 10),
                  onTimeout: () {
                    throw TimeoutException(
                      'Fund account timeout',
                      const Duration(seconds: 10),
                    );
                  },
                );
          } catch (e) {
            // Don't fail the entire initialization if fund account fails
            print('Warning: Failed to load fund account details: $e');
          }
        }

        if (mounted && !_hasNavigatedAway) {
          setState(() {
            _isInitialized = true;
          });
        }
      } catch (e) {
        if (mounted && !_hasNavigatedAway) {
          if (e is TimeoutException) {
            _showErrorDialog(
              'ເວລາໂຫຼດຂໍ້ມູນຊ້າເກີນໄປ',
              'ກະລຸນາກວດສອບການເຊື່ອມຕໍ່ອິນເຕີເນັດ ແລະ ລອງໃໝ່',
            );
          } else {
            _showErrorDialog(
              'ເກີດຂໍ້ຜິດພາດໃນການໂຫຼດຂໍ້ມູນ',
              'ກະລຸນາລອງໃໝ່ອີກຄັ້ງ',
            );
          }
        }
      }
    } catch (e) {
      if (mounted && !_hasNavigatedAway) {
        _showErrorDialog('ເກີດຂໍ້ຜິດພາດໃນການໂຫຼດຂໍ້ມູນ', 'ກະລຸນາລອງໃໝ່ອີກຄັ້ງ');
      }
    } finally {
      _isInitializing = false;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh user limit when screen becomes active - use Future.microtask
    if (_isInitialized && mounted && !_hasNavigatedAway) {
      Future.microtask(() {
        if (mounted && !_hasNavigatedAway) {
          ref.read(transferNotifierProvider.notifier).getUserLimit();
        }
      });
    }
  }

  @override
  void dispose() {
    _hasNavigatedAway = true; // Mark as navigated away
    _amountController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  void _handleNavigationAway() {
    if (!_hasNavigatedAway) {
      setState(() {
        _hasNavigatedAway = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final fixedSize = size.width + size.height;
    final fundAccountState = ref.watch(fundAccountNotifierProvider);
    final receiverAcno = ref.watch(transferNotifierProvider);
    // Handle transfer state changes after build is complete
    // SchedulerBinding.instance.addPostFrameCallback((_) {
    //   if (mounted) {
    //     _handleTransferStateChanges(receiverAcno, context);
    //   }
    // });

    // Show loading screen if not initialized
    if (!_isInitialized) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: GradientAppBar(title: 'ໂອນເງິນ'),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: fixedSize * 0.02),
              Text(
                'ກຳລັງໂຫຼດຂໍ້ມູນ...',
                style: TextStyle(fontSize: fixedSize * 0.012),
              ),
            ],
          ),
        ),
      );
    }

    // Show error screen if account details failed to load
    if (receiverAcno.errorMessage != null &&
        receiverAcno.receiverAccount == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: GradientAppBar(title: 'ໂອນເງິນ'),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red),
              SizedBox(height: fixedSize * 0.02),
              Text(
                'ບໍ່ສາມາດໂຫຼດຂໍ້ມູນບັນຊີໄດ້',
                style: TextStyle(
                  fontSize: fixedSize * 0.014,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: fixedSize * 0.01),
              Text(
                receiverAcno.errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: fixedSize * 0.01),
              ),
              SizedBox(height: fixedSize * 0.02),
              ElevatedButton(
                onPressed: () => _initializeData(),
                child: Text('ລອງໃໝ່'),
              ),
            ],
          ),
        ),
      );
    }

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
                        fundAccountState.fundAccountDetail?.acName ??
                        '', // Use fund account name
                    accountNumber: _maskAccount(
                      fundAccountState.fundAccountDetail?.acNo ?? '',
                    ),
                  ),
                  SizedBox(height: fixedSize * 0.01),
                  _buildAccountInfo(
                    fixedSize,
                    title: 'ປາຍທາງ',
                    icon: AppImage.cop,
                    bankName: 'ທະນາຄານ ພັດທະນາ ຊົນນະບົດ',
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

        // Set transfer data before navigation
        final transferAmount = double.tryParse(_amountController.text) ?? 0.0;
        final transferDetails = _detailsController.text.trim();

        ref
            .read(transferNotifierProvider.notifier)
            .setTransferData(transferAmount, transferDetails);

        _handleNavigationAway();
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

  // void _handleTransferStateChanges(
  //   TransferState currentState,
  //   BuildContext context,
  // ) {
  //   // Don't handle state changes if navigated away
  //   if (_hasNavigatedAway) return;

  //   // Handle limit updates
  //   if (_previousTransferState?.userLimit?.transferLimit !=
  //       currentState.userLimit?.transferLimit) {
  //     if (mounted && !_hasNavigatedAway) {
  //       setState(() {});
  //     }
  //   }

  //   // Handle errors - only show if it's a new error
  //   if (currentState.errorMessage != null &&
  //       currentState.errorMessage != _previousTransferState?.errorMessage) {
  //     final isServerError =
  //         currentState.errorMessage!.contains('500') ||
  //         currentState.errorMessage!.contains('ເກີດຂໍ້ຜິດພາດທາງເຊີເວີ');

  //     // Show snackbar immediately since we're already in post-frame callback
  //     if (mounted && !_hasNavigatedAway) {
  //       showCustomSnackBar(context, currentState.errorMessage!, isError: true);
  //     }

  //     // Show retry dialog for server errors or account not found
  //     if (isServerError ||
  //         currentState.errorMessage!.contains('ບໍ່ພົບເລກບັນຊີ')) {
  //       Future.delayed(const Duration(seconds: 2), () {
  //         if (mounted && !_hasNavigatedAway) {
  //           _showRetryDialog();
  //         }
  //       });
  //     }

  //     // Clear error after showing message
  //     Future.delayed(const Duration(seconds: 3), () {
  //       if (mounted && !_hasNavigatedAway) {
  //         ref.read(transferNotifierProvider.notifier).clearError();
  //       }
  //     });
  //   }
  //   _previousTransferState = currentState;
  // }

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
              _handleNavigationAway();
            },
            child: const Text('ຍົກເລີກ'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Retry initialization with clean account number
              if (mounted && !_hasNavigatedAway) {
                final cleanAcno = widget.acno.replaceAll(RegExp(r'[^\d]'), '');
                // Clear state before retry
                ref.read(transferNotifierProvider.notifier).clearError();
                ref.read(transferNotifierProvider.notifier).clearSuccess();
                // Retry the API calls
                ref
                    .read(transferNotifierProvider.notifier)
                    .getAccountDetail(cleanAcno);
                ref.read(transferNotifierProvider.notifier).getUserLimit();
              }
            },
            child: const Text('ລອງໃໝ່'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _handleNavigationAway();
              // Navigate back to scan QR page
              context.goNamed('scanQR');
            },
            child: const Text('ຍົກເລີກ'),
          ),
        ],
      ),
    );
  }
}
