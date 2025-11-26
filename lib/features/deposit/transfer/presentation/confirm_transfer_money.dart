import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moblie_banking/core/services/biometric_auth.dart';
import 'package:moblie_banking/core/utils/app_colors.dart';
import 'package:moblie_banking/core/utils/app_image.dart';
import 'package:moblie_banking/core/utils/snackbar_helper.dart';
import 'package:moblie_banking/features/deposit/transfer/logic/transfer_provider.dart';
import 'package:moblie_banking/features/deposit/transfer/logic/transfer_state.dart';
import 'package:moblie_banking/features/deposit/transfer/presentation/detali_transfer_money.dart';
import 'package:moblie_banking/widgets/appbar.dart';

class ConfirmTransferMoneyScreen extends ConsumerStatefulWidget {
  const ConfirmTransferMoneyScreen({super.key});

  @override
  ConsumerState<ConfirmTransferMoneyScreen> createState() =>
      _ConfirmTransferMoneyScreenState();
}

class _ConfirmTransferMoneyScreenState
    extends ConsumerState<ConfirmTransferMoneyScreen> {
  bool _obscureText = true;
  bool _isProcessing = false;
  bool _isBiometricAvailable = false;
  final TextEditingController _passwordController = TextEditingController();
  final BiometricAuth _biometricAuth = BiometricAuth();

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
  }

  Future<void> _checkBiometricAvailability() async {
    try {
      // Check if biometric is available without triggering authentication
      final canAuthenticate = await _biometricAuth.isBiometricAvailable();
      if (mounted) {
        setState(() {
          _isBiometricAvailable = canAuthenticate;
        });
      }
    } catch (e) {
      // Biometric not available, will use password only
      if (mounted) {
        setState(() {
          _isBiometricAvailable = false;
        });
      }
    }
  }

  Future<void> _confirmWithPassword() async {
    if (_passwordController.text.trim().isEmpty) {
      showCustomSnackBar(context, 'ກະລຸນາປ້ອນລະຫັດຜ່ານ', isError: true);
      return;
    }

    await _performTransfer();
  }

  Future<void> _confirmWithBiometric() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      final isAuthenticated = await _biometricAuth.authenticate();
      if (isAuthenticated) {
        await _performTransfer();
      } else {
        if (mounted) {
          showCustomSnackBar(
            context,
            'ການຢືນຢັນດ້ວຍລາຍນິ້ວມືລົ້ມເຫລວ ກະລຸນາລອງໃໝ່',
            isError: true,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        showCustomSnackBar(
          context,
          'ເກີດຂໍ້ຜິດພາດໃນການຢືນຢັນດ້ວຍລາຍນິ້ວມື',
          isError: true,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _performTransfer() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      // Get transfer data from the previous screen
      final transferState = ref.read(transferNotifierProvider);
      final receiverAccount = transferState.receiverAccount;

      if (receiverAccount == null) {
        showCustomSnackBar(context, 'ບໍ່ພົບຂໍ້ມູນບັນຊີປາຍທາງ', isError: true);
        return;
      }

      // Get amount and details from the previous screen
      // Note: You'll need to pass this data through navigation or use a provider
      // For now, I'll create a mock transfer request
      // TODO: Get actual amount and details from previous screen

      // Navigate to detail screen for now
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const DetailTransferMoneyScreen(),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        showCustomSnackBar(
          context,
          'ເກີດຂໍ້ຜິດພາດໃນການໂອນເງິນ: $e',
          isError: true,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final transferState = ref.watch(transferNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GradientAppBar(title: "ຢືນຢັນການໂອນເງິນ"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Transfer summary
            // Container(
            //   padding: const EdgeInsets.all(16),
            //   decoration: BoxDecoration(
            //     color: Colors.grey.shade50,
            //     borderRadius: BorderRadius.circular(12),
            //     border: Border.all(color: Colors.grey.shade200),
            //   ),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       const Text(
            //         'ລາຍລະອຽດການໂອນເງິນ',
            //         style: TextStyle(
            //           fontSize: 18,
            //           fontWeight: FontWeight.bold,
            //           color: Colors.black87,
            //         ),
            //       ),
            //       const SizedBox(height: 12),
            //       _buildTransferInfo('ຈາກບັນຊີ', 'ບັນຊີເງິນຝາກ'),
            //       _buildTransferInfo(
            //         'ໄປບັນຊີ',
            //         transferState.receiverAccount?.accountName ?? '',
            //       ),
            //       _buildTransferInfo(
            //         'ເລກບັນຊີ',
            //         transferState.receiverAccount?.accountNumber ?? '',
            //       ),
            //       _buildTransferInfo(
            //         'ຈຳນວນເງິນ',
            //         _formatCurrency(transferState.transferAmount ?? 0),
            //       ),
            //       _buildTransferInfo(
            //         'ລາຍລະອຽດ',
            //         transferState.transferDetails ?? '',
            //       ),
            //     ],
            //   ),
            // ),
            // const SizedBox(height: 30),

            // Password section
            const Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: 'ລະຫັດຜ່ານ'),
                  TextSpan(
                    text: ' *',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscureText,
              keyboardType: TextInputType.number,
              enabled: !_isProcessing,
              decoration: InputDecoration(
                hintText: 'ໃສ່ລະຫັດຜ່ານ',
                hintStyle: TextStyle(color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: AppColors.color1.withOpacity(0.5),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: AppColors.color1.withOpacity(0.5),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: AppColors.color1, width: 2.0),
                ),
                suffixIcon: IconButton(
                  icon: SvgPicture.asset(
                    AppImage.show,
                    height: 24,
                    width: 24,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Biometric section
            if (_isBiometricAvailable) ...[
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _isProcessing ? null : _confirmWithBiometric,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _isProcessing
                              ? Colors.grey.withOpacity(0.1)
                              : AppColors.color1.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _isProcessing
                                ? Colors.grey.withOpacity(0.3)
                                : AppColors.color1.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            _isProcessing
                                ? SizedBox(
                                    width: 60.w,
                                    height: 60.w,
                                    child: CircularProgressIndicator(
                                      color: AppColors.color1,
                                      strokeWidth: 3,
                                    ),
                                  )
                                : SvgPicture.asset(
                                    AppImage.finger,
                                    width: 60.w,
                                  ),
                            const SizedBox(height: 8),
                            Text(
                              _isProcessing
                                  ? 'ກຳລັງປະມວນຜົນ...'
                                  : 'ກົດເພື່ອຢືນຢັນດ້ວຍລາຍນິ້ວມື',
                              style: TextStyle(
                                fontSize: 14,
                                color: _isProcessing
                                    ? Colors.grey
                                    : Colors.black54,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Password confirm button
              ElevatedButton(
                onPressed: _isProcessing ? null : _confirmWithPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.color1,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: _isProcessing
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'ກຳລັງປະມວນຜົນ...',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'ຢືນຢັນດ້ວຍລະຫັດຜ່ານ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.lock, color: Colors.white, size: 20),
                        ],
                      ),
              ),

              // Biometric button
              // if (_isBiometricAvailable) ...[
              //   const SizedBox(height: 12),
              //   OutlinedButton(
              //     onPressed: _isProcessing ? null : _confirmWithBiometric,
              //     style: OutlinedButton.styleFrom(
              //       padding: const EdgeInsets.symmetric(vertical: 16),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //       minimumSize: const Size(double.infinity, 50),
              //       side: BorderSide(color: AppColors.color1),
              //     ),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Text(
              //           'ກົດເພື່ອຢືນຢັນດ້ວຍລາຍນິ້ວມື',
              //           style: TextStyle(
              //             fontSize: 18,
              //             fontWeight: FontWeight.bold,
              //             color: AppColors.color1,
              //           ),
              //         ),
              //         const SizedBox(width: 8),
              //         Icon(
              //           Icons.fingerprint,
              //           color: AppColors.color1,
              //           size: 20,
              //         ),
              //       ],
              //     ),
              //   ),
              // ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransferInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double amount) {
    return amount
        .toStringAsFixed(2)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match match) => '${match[1]},',
        );
  }
}
