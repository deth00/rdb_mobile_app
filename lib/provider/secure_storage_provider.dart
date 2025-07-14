// lib/provider/secure_storage_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moblie_banking/core/utils/secure_storage.dart';

final secureStorageProvider = Provider<SecureStorage>((ref) {
  return SecureStorage();
});
