import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moblie_banking/core/services/biometric_auth.dart';

class SplashController {
  static final _storage = FlutterSecureStorage();
  static final _biometricAuth = BiometricAuth();

  static Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'auth_token');
    return token != null && token.isNotEmpty;
  }

  // ตรวจว่าผู้ใช้เปิดใช้ biometric หรือไม่
  static Future<bool> isUseBiometric() async {
    final useBio = await _storage.read(key: 'use_biometric');
    return useBio == 'true';
  }

  // เรียก biometric auth
  static Future<bool> authenticateBiometric() async {
    return await _biometricAuth.authenticate();
  }
}
