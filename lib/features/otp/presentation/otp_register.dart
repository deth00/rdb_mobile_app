import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moblie_banking/core/utils/app_colors.dart';
import 'package:moblie_banking/core/utils/snackbar_helper.dart';
import 'package:moblie_banking/features/auth/logic/auth_provider.dart';
import 'package:moblie_banking/features/otp/logic/otp_provider.dart';
import 'package:moblie_banking/features/otp/logic/otp_state.dart';
import 'package:moblie_banking/widgets/appbar.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpRegister extends ConsumerStatefulWidget {
  const OtpRegister({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OtpRegisterState();
}

class _OtpRegisterState extends ConsumerState<OtpRegister> {
  final codecontroller = TextEditingController();
  String? phone;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final storage = ref.read(secureStorageProvider);
      final storedPhone = await storage.getPhone();
      if (mounted) {
        setState(() {
          phone = storedPhone;
        });
      }
    });
    Future.microtask(() {
      ref.read(otpNotifierProvider.notifier).startOtpExpireTimer(240);
    });
  }

  @override
  void dispose() {
    // codecontroller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!mounted) return;
    final code = codecontroller.text.trim();
    if (code.isEmpty) {
      showCustomSnackBar(context, 'ກະລຸນາໃສ່ OTP', isError: true);
      return;
    }
    showDialog(
      context: context,
      barrierDismissible: false, // กดนอก dialog ไม่ให้ปิด
      builder: (context) => const Center(
        child: CircularProgressIndicator(), // หรือ Lottie ก็ได้
      ),
    );
    await ref.read(otpNotifierProvider.notifier).vertifyOTP(code);
    if (!mounted) return;
    Navigator.of(context).pop();
    final otpstate = ref.watch(otpNotifierProvider);

    if (otpstate.status == OtpStatus.success) {
      if (mounted) {
        context.pushReplacement('/register');
      }
    } else {
      showCustomSnackBar(context, 'OTP ບໍ່ຖືກຕ້ອງ', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double fixedSize = size.width + size.height;
    final otpState = ref.watch(otpNotifierProvider);
    // final otpNotifier = ref.read(otpNotifierProvider.notifier);

    String formatTime(int seconds) {
      final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
      final secs = (seconds % 60).toString().padLeft(2, '0');
      return '$minutes:$secs';
    }

    return Scaffold(
      appBar: GradientAppBar(title: 'ຢືນຢັນ OTP'),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: fixedSize * 0.05,
            horizontal: fixedSize * 0.01,
          ),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Center(
                child: Text(
                  'ລະຫັດ OTP ໄດ້ຖືກສົ່ງຫາ  ',
                  style: TextStyle(fontSize: fixedSize * 0.015),
                ),
              ),

              SizedBox(height: fixedSize * 0.02),
              PinCodeTextField(
                appContext: context,
                length: 6,
                controller: codecontroller,
                keyboardType: TextInputType.number,
                autoFocus: true,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(8),
                  fieldHeight: 50,
                  fieldWidth: 40,
                  activeColor: Colors.teal,
                  selectedColor: Colors.teal.shade700,
                  inactiveColor: Colors.grey.shade400,
                ),
                animationDuration: const Duration(milliseconds: 300),
              ),
              Text(
                'OTP ຈະໝົດອາຍຸໃນ ${formatTime(otpState.otpExpiresIn)}',
                style: const TextStyle(fontSize: 16, color: Colors.red),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: FloatingActionButton.extended(
            onPressed: () {
              _submit();
            },
            label: Center(
              child: Text(
                'ຕໍ່ໄປ',
                style: TextStyle(
                  fontSize: fixedSize * 0.015,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            backgroundColor: Color.fromARGB(255, 1, 189, 136),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
