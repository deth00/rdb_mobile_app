import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moblie_banking/core/utils/app_colors.dart';
import 'package:moblie_banking/features/splash/splash_controller.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final isLoggedIn = await SplashController.isLoggedIn();
    final useBiometric = await SplashController.isUseBiometric();

    if (!mounted) return;

    if (isLoggedIn && useBiometric) {
      final biometricSuccess = await SplashController.authenticateBiometric();
      if (!mounted) return;

      if (biometricSuccess) {
        context.go('/login');
      } else {
        context.go('/login');
      }
    } else if (isLoggedIn) {
      context.go('/login');
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color1,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Image.asset('assets/icons/logo.png', width: 120, height: 120),
            SizedBox(height: 30),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
