import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:moblie_banking/app/app.dart';
import 'package:moblie_banking/core/utils/secure_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  // Initialize Lao locale data
  await initializeDateFormatting('lo');

  // Clear all stored data except preserved keys (_refreshTokenKey, _biometricKey, _name)
  try {
    final secureStorage = SecureStorage();
    await secureStorage.clearAllExceptPreserved();
  } catch (e) {
    // If secure storage fails, log the error but don't crash the app
    print('Failed to clear secure storage on startup: $e');
  }

  // Add error handling for late initialization errors
  // FlutterError.onError = (FlutterErrorDetails details) {
  //   FlutterError.presentError(details);
  // };

  // // Add error handling for async errors
  // PlatformDispatcher.instance.onError = (error, stack) {
  //   print('Caught error: $error');
  //   return true;
  // };

  runApp(
    ScreenUtilInit(
      designSize: const Size(430, 932),
      builder: (context, child) => ProviderScope(child: App()),
    ),
  );
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
