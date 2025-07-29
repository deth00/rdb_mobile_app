import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io' show Platform;

class SecureStorage {
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _biometricKey = 'use_biometric';
  static const _otpid = 'otp_id';
  static const _otpKey = 'otp_code';
  static const _phone = 'phone';
  static const _userAgentKey = 'user_agent';

  final _auth = LocalAuthentication();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<bool> canUseBiometric() async {
    return await _auth.canCheckBiometrics && await _auth.isDeviceSupported();
  }

  Future<bool> loginWithBiometric() async {
    final enabled = await _storage.read(key: _biometricKey);
    if (enabled != 'true') return false;

    final auth = await _auth.authenticate(
      localizedReason: 'ຢືນຢັນຕົວຕົນ',
      options: const AuthenticationOptions(biometricOnly: true),
    );

    if (auth) {
      final token = await _storage.read(key: _refreshTokenKey);
      return token != null;
    }
    return false;
  }

  Future<void> authenticateWithBiometric() async {
    final auth = await _auth.authenticate(
      localizedReason: 'ຢືນຢັນຕົວຕົນເພື່ອປ່ຽນການຕັ້ງຄ່າ',
      options: const AuthenticationOptions(biometricOnly: true),
    );

    if (!auth) {
      throw Exception('ການຢືນຢັນຕົວຕົນລົ້ມເຫລວ');
    }
  }

  /// Save Access Token
  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
  }

  /// Save Refresh Token
  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  /// Read Access Token
  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  /// Read Refresh Token
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  /// Delete both tokens
  Future<void> clearTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }

  /// Delete everything (use when logout)
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  /// Save biometric enabled flag
  Future<void> setBiometricEnabled(bool enabled) async {
    await _storage.write(key: _biometricKey, value: enabled.toString());
  }

  /// Read biometric enabled flag
  Future<bool> isBiometricEnabled() async {
    final value = await _storage.read(key: _biometricKey);
    return value == 'true';
  }

  /// Read all tokens at once (optional helper)
  Future<Map<String, String?>> getAllTokens() async {
    final access = await getAccessToken();
    final refresh = await getRefreshToken();
    return {'access_token': access, 'refresh_token': refresh};
  }

  Future<void> saveOtpId(String otp) async {
    await _storage.write(key: _otpid, value: otp);
  }

  Future<String?> getOtpId() async {
    return _storage.read(key: _otpid);
  }

  Future<void> saveOtp(String phone) async {
    await _storage.write(key: _otpKey, value: phone);
  }

  Future<String?> getOTP() async {
    return await _storage.read(key: _otpKey);
  }

  Future<void> savePhone(String phone) async {
    await _storage.write(key: _phone, value: phone);
  }

  Future<String?> getPhone() async {
    return await _storage.read(key: _phone);
  }

  Future<void> saveUserAgent(String userAgent) async {
    await _storage.write(key: _userAgentKey, value: userAgent);
  }

  Future<String?> getUserAgent() async {
    return await _storage.read(key: _userAgentKey);
  }

  /// Get detailed mobile device user agent using device_info_plus
  Future<String> getMobileUserAgent() async {
    final deviceInfo = DeviceInfoPlugin();

    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        return 'moblie_banking/1.0.0 (Android ${androidInfo.version.release}; ${androidInfo.model})';
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        return 'moblie_banking/1.0.0 (iOS ${iosInfo.systemVersion}; ${iosInfo.model})';
      } else {
        return 'moblie_banking/1.0.0 (Unknown Platform)';
      }
    } catch (e) {
      return 'moblie_banking/1.0.0 (Unknown Device)';
    }
  }
}
