import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:moblie_banking/core/utils/app_colors.dart';
import 'package:moblie_banking/core/utils/app_image.dart';
import 'package:moblie_banking/features/auth/logic/auth_provider.dart';
import 'package:moblie_banking/widgets/appbar.dart';
import 'package:moblie_banking/widgets/service_buttom.dart';

// Riverpod provider สำหรับสถานะ biometric
final useBiometricProvider = StateProvider<bool>((ref) => false);

class SettingScreen extends ConsumerStatefulWidget {
  const SettingScreen({super.key});

  @override
  ConsumerState<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends ConsumerState<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    final fixedSize =
        MediaQuery.of(context).size.width + MediaQuery.of(context).size.height;
    final biometricEnabled = ref.watch(authNotifierProvider);
    final controller = ref.read(authNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GradientAppBar(title: 'ການຕັ້ງຄ່າ'),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: fixedSize * 0.01),
            const ServiceButtom(
              title: 'ປ່ຽນລະຫັດໃໝ່',
              text: 'ປ່ຽນລະຫັດຜ່ານເຂົ້າລະບົບ',
              image: AppImage.key,
            ),

            // Biometric toggle
            ServiceButtom(
              title: 'ການຢືນຢັນຕົວຕົນ',
              text: 'ເປີດ/ປິດ ການເຂົ້າລະບົບດ້ວຍລາຍນິ້ວມື ຫຼື Face ID',
              image: AppImage.finger,
              widget: Switch(
                value: biometricEnabled.successMessage == 'true',
                onChanged: (value) {
                  // print(value);
                  controller.toggle(value);
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
