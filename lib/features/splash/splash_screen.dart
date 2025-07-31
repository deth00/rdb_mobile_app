import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:moblie_banking/core/utils/app_colors.dart';
import 'package:moblie_banking/core/utils/app_image.dart';
import 'package:moblie_banking/core/utils/svg_icons.dart';
import 'package:moblie_banking/features/auth/logic/auth_provider.dart';
import 'package:moblie_banking/features/splash/splash_controller.dart';
import 'package:moblie_banking/widgets/svg_icon_widget.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Add a small delay to ensure router is initialized
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _checkAuth();
      }
    });
  }

  Future<void> _checkAuth() async {
    try {
      final authNotifier = ref.read(authNotifierProvider.notifier);
      await authNotifier.load(); // ต้องเรียกเสมอ

      final isLoggedIn = await SplashController.isLoggedIn();
      final useBiometric = await SplashController.isUseBiometric();
      if (!mounted) return;

      if (isLoggedIn && useBiometric) {
        final biometricSuccess = await SplashController.authenticateBiometric();
        if (!mounted) return;

        if (biometricSuccess) {
          // ✅ Refresh token และเปลี่ยน state เป็น logged in
          await authNotifier.refreshToken();

          // ✅ ไปหน้า home
          if (mounted) {
            context.goNamed('home');
          }
          return;
        }
      }

      if (isLoggedIn) {
        if (mounted) {
          context.goNamed('login');
        }
      } else {
        if (mounted) {
          context.goNamed('loginNever');
        }
      }
    } catch (e) {
      // If there's an error, go to login as fallback
      if (mounted) {
        context.goNamed('login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double fixedSize = size.width + size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: fixedSize * 0.01),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 1.h),
                SvgPicture.asset(SvgIcons.logoApp, height: 200.h),

                // BankingIcons.logo(width: fixedSize * 0.3, height: fixedSize * 0.3),
                Column(
                  children: [
                    Text(
                      'ທະນາຄານພັດທະນາຊົນນະບົດ',
                      style: TextStyle(
                        fontSize: fixedSize * 0.018,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'RDB BANK',
                      style: TextStyle(
                        fontSize: fixedSize * 0.018,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
