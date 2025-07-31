import 'package:flutter_riverpod/flutter_riverpod.dart';

// Simple provider for account number
final acnoFutureProvider = FutureProvider<String>((ref) async {
  // Simulate API call for account number
  await Future.delayed(Duration(seconds: 1));
  return '0201010000205444001';
});

// Legacy provider for backward compatibility
final qrFutureProvider = FutureProvider<String>((ref) async {
  // This will be replaced by the QR notifier provider
  await Future.delayed(Duration(seconds: 2));
  return '00020101021134500007FUNDNBB01041044020421960319020101000020544400158034186003VTE63045225';
});
