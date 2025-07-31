import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moblie_banking/core/utils/snackbar_helper.dart';
import 'package:moblie_banking/features/auth/logic/auth_provider.dart';
import 'package:moblie_banking/widgets/appbar.dart';
import 'package:moblie_banking/widgets/field_input.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final phoneControl = TextEditingController();
  final pwControl = TextEditingController();
  @override
  void dispose() {
    phoneControl.dispose();
    pwControl.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    final phone = phoneControl.text.trim();
    final password = phoneControl.text.trim();
    if (phone.isEmpty || password.isEmpty) {
      showCustomSnackBar(
        context,
        'ກະລຸນາໃສ່ເບີໂທ ແລະ ລະຫັດຜ່ານ',
        isError: true,
      );
      return;
    }
    showDialog(
      context: context,
      barrierDismissible: false, // กดนอก dialog ไม่ให้ปิด
      builder: (context) => const Center(
        child: CircularProgressIndicator(), // หรือ Lottie ก็ได้
      ),
    );
    await ref.read(authNotifierProvider.notifier).register(phone, password);
    if (context.mounted) Navigator.of(context).pop();
    final authstate = ref.read(authNotifierProvider);
    if (authstate.successMessage == 'successfully') {
      if (mounted) {
        context.goNamed("login");
      }
    } else {
      // ignore: use_build_context_synchronously
      showCustomSnackBar(context, 'ເກິດຂໍ້ຜິດພາດ', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double fixedSize = size.width + size.height;
    return Scaffold(
      appBar: GradientAppBar(title: 'ລົງທະບຽນ'),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: fixedSize * 0.06,
            horizontal: fixedSize * 0.01,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Text(
                  'ລົງທະບຽນ',
                  style: TextStyle(fontSize: fixedSize * 0.015),
                ),
              ),

              SizedBox(height: fixedSize * 0.02),

              FieldInput(
                title: 'ເບິໂທລະສັບ',
                icon: Icons.phone,
                type: TextInputType.phone,
                controller: phoneControl,
                mexlent: 11,
              ),

              FieldInput(
                title: 'ລະຫັດຜ່ານ',
                icon: Icons.lock,
                type: TextInputType.text,
                controller: pwControl,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: FloatingActionButton.extended(
            onPressed: () {
              submit();
            },
            label: Center(
              child: Text(
                'ບັນທຶກ',
                style: TextStyle(
                  fontSize: fixedSize * 0.015,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            backgroundColor: Color.fromARGB(255, 1, 189, 136),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
