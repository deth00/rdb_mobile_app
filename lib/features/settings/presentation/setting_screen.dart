import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moblie_banking/core/utils/app_colors.dart';
import 'package:moblie_banking/core/utils/app_image.dart';
import 'package:moblie_banking/features/auth/logic/auth_provider.dart';
import 'package:moblie_banking/widgets/appbar.dart';
import 'package:moblie_banking/widgets/service_buttom.dart';

class SettingScreen extends ConsumerStatefulWidget {
  const SettingScreen({super.key});

  @override
  ConsumerState<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends ConsumerState<SettingScreen> {
  @override
  void initState() {
    super.initState();
    // เรียกโหลดสถานะ biometric เมื่อหน้า Setting ถูกสร้าง
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authNotifierProvider.notifier).load();
    });
  }

  Future<void> _authenticateAndToggle(bool newValue) async {
    await ref.read(authNotifierProvider.notifier).authenticateWithBiometric();
    await ref.read(authNotifierProvider.notifier).toggle(newValue);
    // Show loading dialog
  }

  @override
  Widget build(BuildContext context) {
    final fixedSize =
        MediaQuery.of(context).size.width + MediaQuery.of(context).size.height;
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GradientAppBar(title: 'ການຕັ້ງຄ່າ', isLogout: true),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: fixedSize * 0.01),
            ServiceButtom(
              title: 'ປ່ຽນລະຫັດໃໝ່',
              text: 'ປ່ຽນລະຫັດຜ່ານເຂົ້າລະບົບ',
              image: AppImage.key,
              onpress: () {
                context.pushNamed('forgotPassword');
              },
            ),

            // Biometric toggle - Only show if device supports biometric
            if (authState.canUseBiometric)
              ServiceButtom(
                title: 'ການຢືນຢັນຕົວຕົນ',
                text: authState.isBiometricEnabled
                    ? 'ເປີດໃຊ້ງານການເຂົ້າລະບົບດ້ວຍລາຍນິ້ວມື ຫຼື Face ID'
                    : 'ປິດໃຊ້ງານການເຂົ້າລະບົບດ້ວຍລາຍນິ້ວມື ຫຼື Face ID',
                image: AppImage.finger,
                widget: authState.isLoading
                    ? const CircularProgressIndicator()
                    : Switch(
                        value: authState.isBiometricEnabled,
                        onChanged: (value) async {
                          // Require biometric authentication before toggling
                          await _authenticateAndToggle(value);
                        },
                        activeColor: AppColors.color1,
                      ),
              ),

            const ServiceButtom(
              title: 'ຈັດການອຸປະກອນ',
              text: 'ກຳນົດອຸປະກອນທີ່ໃຊ້ຮັບແຈ້ງເຕືອນ',
              image: AppImage.mobile,
            ),
            const ServiceButtom(
              title: 'ຕັ້ງຄ່າແຈ້ງເຕືອນ',
              text: 'ເຊັ່ນ ດອກເບ້ຍ ແລະ ການກູ້ຢືມ',
              image: AppImage.noti,
            ),
          ],
        ),
      ),
    );
  }
}
