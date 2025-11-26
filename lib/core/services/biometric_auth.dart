import 'package:local_auth/local_auth.dart';

class BiometricAuth {
  final _auth = LocalAuthentication();

  Future<bool> isBiometricAvailable() async {
    try {
      final canCheckBiometrics = await _auth.canCheckBiometrics;
      final isDeviceSupported = await _auth.isDeviceSupported();
      return canCheckBiometrics && isDeviceSupported;
    } catch (e) {
      print("Biometric Availability Check Error: $e");
      return false;
    }
  }

  Future<bool> authenticate() async {
    final canAuthenticate = await isBiometricAvailable();
    if (!canAuthenticate) return false;

    try {
      return await _auth.authenticate(
        localizedReason: 'ກະລຸນາຢືນຢັນການໂອນເງິນດ້ວຍລາຍນິ້ວມື',
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
