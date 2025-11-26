import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:moblie_banking/core/utils/app_colors.dart';
import 'package:moblie_banking/core/utils/snackbar_helper.dart';
import 'package:moblie_banking/features/auth/logic/auth_provider.dart';
import 'package:moblie_banking/features/otp/logic/otp_provider.dart';
import 'package:moblie_banking/features/otp/logic/otp_state.dart';
import 'package:moblie_banking/widgets/appbar.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpForgotPW extends ConsumerStatefulWidget {
  const OtpForgotPW({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpForgotPW> {
  late final TextEditingController codecontroller;
  String? phone;

  @override
  void initState() {
    super.initState();
    codecontroller = TextEditingController();
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
      Future.microtask(() {
        if (mounted) {
          context.pushReplacement('/createPW');
        }
      });
    } else {
      showCustomSnackBar(context, 'OTP ບໍ່ຖືກຕ້ອງ', isError: true);
    }
  }

  // Future<void> _submit() async {
  //   final code = codecontroller.text.trim();
  //   if (code.length < 4) {
  //     showCustomSnackBar(context, '⚠️ ກະລຸນາໃສ່ OTP ໃຫ້ຄົບ');
  //     return;
  //   }

  //   await ref.read(otpNotifierProvider.notifier).vertifyOTPForgot(code);
  // }

  @override
  Widget build(BuildContext context) {
    final otpState = ref.watch(otpNotifierProvider);
    // final otpNotifier = ref.read(otpNotifierProvider.notifier);
    // ref.listen<OtpState>(otpNotifierProvider, (prev, next) {
    //   if (next.status == OtpStatus.success) {
    //     showCustomSnackBar(context, '✅ ຢືນຢັນ OTP ສຳເລັດ!');
    //     context.go('/createPW');
    //   } else if (next.status == OtpStatus.error) {
    //     showCustomSnackBar(
    //       context,
    //       next.errorMessage ?? '❌ ເກີດຂໍ້ຜິດພາດ',
    //       isError: true,
    //     );
    //   }
    // });
    String formatTime(int seconds) {
      final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
      final secs = (seconds % 60).toString().padLeft(2, '0');
      return '$minutes:$secs';
    }

    return Scaffold(
      appBar: GradientAppBar(title: 'ຢືນຢັນ OTP'),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Center(
                child: Text(
                  'ລະຫັດ OTP ໄດ້ຖືກສົ່ງຫາ ${phone} ',
                  style: TextStyle(fontSize: 16.sp),
                ),
              ),

              SizedBox(height: 20.h),
              PinCodeTextField(
                appContext: context,
                length: 6,
                controller: codecontroller,
                keyboardType: TextInputType.number,
                autoFocus: true,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(8.r),
                  fieldHeight: 50.h,
                  fieldWidth: 40.w,
                  activeColor: Colors.teal,
                  selectedColor: Colors.teal.shade700,
                  inactiveColor: Colors.grey.shade400,
                ),

                animationDuration: const Duration(milliseconds: 300),
              ),
              // TextField(
              //   controller: codecontroller,
              //   keyboardType: TextInputType.phone,
              //   maxLength: 11,
              //   decoration: InputDecoration(
              //     labelText: ' OTP',
              //     // prefixIcon: Icon(Icons.phone),
              //     counterText: '',
              //     contentPadding: EdgeInsets.symmetric(
              //       vertical: 14,
              //       horizontal: 20,
              //     ),
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(
              //         fixedSize * 0.01,
              //       ), // วงมน
              //       borderSide: BorderSide(color: AppColors.color1),
              //     ),
              //     focusedBorder: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(fixedSize * 0.01),
              //       borderSide: BorderSide(color: AppColors.color1, width: 2),
              //     ),
              //   ),
              // ),
              Text(
                'OTP ຈະໝົດອາຍຸໃນ ${formatTime(otpState.otpExpiresIn)}',
                style: const TextStyle(fontSize: 16, color: Colors.red),
              ),
              // TextButton(
              //   onPressed: otpState.resendSecondsLeft > 0
              //       ? null
              //       : () {
              //           otpNotifier.startCooldown(60);
              //           // ส่ง OTP ใหม่ (เรียก API ด้วยก็ได้)
              //         },
              //   child: Text(
              //     otpState.resendSecondsLeft > 0
              //         ? 'ສາມາດສົ່ງໃໝ່ໄດ້ໃນ ${otpState.resendSecondsLeft} ວິ'
              //         : '📩 ສົ່ງ OTP ໃໝ່',
              //   ),
              // ),
            ],
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Container(
            decoration: BoxDecoration(gradient: AppColors.main),
            child: FloatingActionButton.extended(
              onPressed: () {
                _submit();
              },
              label: Center(
                child: Text(
                  'ຕໍ່ໄປ',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
