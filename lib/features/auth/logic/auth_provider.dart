import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moblie_banking/core/services/api_service.dart';
import 'package:moblie_banking/core/utils/secure_storage.dart';
import 'package:moblie_banking/features/auth/logic/auth_notifier.dart';

import 'auth_state.dart';
import 'auth_redirect_notifier.dart';

/// ✅ ตัวหลัก: ใช้จัดการ Auth state (login/logout)
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final dio = ref.read(dioClientProvider);
  final storage = ref.read(secureStorageProvider);
  return AuthNotifier(dio, storage);
});

/// ✅ ตัวสำหรับ GoRouter redirect
final authRedirectProvider = Provider<AuthRedirectNotifier>((ref) {
  final notifier = AuthRedirectNotifier();

  // ✅ listen จาก authNotifierProvider
  ref.listen<AuthState>(authNotifierProvider, (prev, next) {
    notifier.update(next.isLoggedIn);
  });

  return notifier;
});

/// ✅ storage provider
final secureStorageProvider = Provider((ref) => SecureStorage());

/// ✅ dio client provider
final dioClientProvider = Provider((ref) => DioClient());
