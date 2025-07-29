import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moblie_banking/core/utils/app_colors.dart';
import 'package:moblie_banking/core/utils/snackbar_helper.dart';
import 'package:moblie_banking/features/auth/logic/auth_provider.dart';
import 'package:moblie_banking/widgets/appbar.dart';
import 'package:moblie_banking/widgets/field_input.dart';

class CreatePasswordScreen extends ConsumerStatefulWidget {
  const CreatePasswordScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreatePasswordScreenState();
}

bool _isObscure1 = true;
bool _isObscure2 = true;

class _CreatePasswordScreenState extends ConsumerState<CreatePasswordScreen> {
  final pw1Controller = TextEditingController();
  final pw2Controller = TextEditingController();
  @override
  void dispose() {
    pw1Controller.dispose();
    pw2Controller.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    final pw1 = pw1Controller.text.trim();
    final pw2 = pw2Controller.text.trim();

    if (pw1 != pw2) {
      showCustomSnackBar(context, 'ລະຫັດບໍ່ຕົງກັນ ກະລຸນາລອງໃຫມ່');
      return;
    }
    showDialog(
      context: context,
      barrierDismissible: false, // กดนอก dialog ไม่ให้ปิด
      builder: (context) => const Center(
        child: CircularProgressIndicator(), // หรือ Lottie ก็ได้
      ),
    );
    await ref.read(authNotifierProvider.notifier).createPassword(pw1, pw2);
    if (context.mounted) Navigator.of(context).pop();
    final authstate = ref.watch(authNotifierProvider);
    if (authstate.successMessage == "successfully") {
      if (mounted) {
        context.pushReplacement('/login');
      }
    } else {
      showCustomSnackBar(context, 'ເກີດຂໍ້ຜິດພາດ', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double fixedSize = size.width + size.height;
    return Scaffold(
      appBar: GradientAppBar(title: 'ສ້າງລະຫັດຜ່ານໃຫມ່'),
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
                  'ສ້າງລະຫັດຜ່ານໃຫມ່',
                  style: TextStyle(fontSize: fixedSize * 0.015),
                ),
              ),

              SizedBox(height: fixedSize * 0.02),

              FieldInput(
                title: 'ລະຫັດຜ່ານ',
                obs: _isObscure1,
                icon: Icons.lock,
                icon1: IconButton(
                  onPressed: () {
                    setState(() {
                      _isObscure1 = !_isObscure1;
                    });
                  },
                  icon: Icon(
                    _isObscure1 ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                ),
                type: TextInputType.text,
                controller: pw1Controller,
              ),

              FieldInput(
                title: 'ລະຫັດຜ່ານ',
                obs: _isObscure2,
                icon: Icons.lock,
                type: TextInputType.text,
                controller: pw2Controller,
                icon1: IconButton(
                  onPressed: () {
                    setState(() {
                      _isObscure2 = !_isObscure2;
                    });
                  },
                  icon: Icon(
                    _isObscure2 ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            decoration: BoxDecoration(gradient: AppColors.main),
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
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
