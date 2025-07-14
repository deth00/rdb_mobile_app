import 'package:local_auth/local_auth.dart';

class BiometricAuth {
  final _auth = LocalAuthentication();

  Future<bool> authenticate() async {
    final canAuthenticate =
        await _auth.canCheckBiometrics && await _auth.isDeviceSupported();
    if (!canAuthenticate) return false;

    try {
      return await _auth.authenticate(
        localizedReason: 'กรุณายืนยันตัวตนเพื่อเข้าใช้งาน',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );
    } catch (e) {
      print("Biometric Error: $e");
      return false;
    }
  }
}
