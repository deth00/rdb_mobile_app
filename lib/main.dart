import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:moblie_banking/app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  // Initialize Lao locale data
  await initializeDateFormatting('lo');

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
      designSize: const Size(385, 852),
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
