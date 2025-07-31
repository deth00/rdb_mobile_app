import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moblie_banking/core/utils/app_colors.dart';
import 'package:moblie_banking/core/utils/snackbar_helper.dart';
import 'package:moblie_banking/features/auth/logic/auth_provider.dart';
import 'package:moblie_banking/widgets/appbar.dart';

class CheckPhoneScreen extends ConsumerStatefulWidget {
  const CheckPhoneScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CheckPhoneScreenState();
}

class _CheckPhoneScreenState extends ConsumerState<CheckPhoneScreen> {
  final phoneControl = TextEditingController();
  @override
  void dispose() {
    phoneControl.dispose();
    super.dispose();
  }

  Future<void> checkPhone() async {
    final phone = phoneControl.text.trim();

    if (phone.isEmpty) {
      showCustomSnackBar(context, 'ກະລຸນາໃສ່ເບີໂທ', isError: true);
      return;
    } else {
      showDialog(
        context: context,
        barrierDismissible: false, // กดนอก dialog ไม่ให้ปิด
        builder: (context) => const Center(
          child: CircularProgressIndicator(), // หรือ Lottie ก็ได้
        ),
      );
      await ref.read(authNotifierProvider.notifier).cKPone(phone);
      if (context.mounted) Navigator.of(context).pop();
      final authState = ref.read(authNotifierProvider);
      if (authState.successMessage == 'OTP sent successfully') {
        if (mounted) {
          context.pushNamed('otpregis');
        }
      } else {
        showCustomSnackBar(context, 'ເບິໂທບໍ່ຖຶກຕ້ອງ', isError: true);
      }
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
            vertical: fixedSize * 0.05,
            horizontal: fixedSize * 0.01,
          ),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Center(
                child: Text(
                  'ກະລູນາປ້ອນເບີທີ່ທ່ານໄດ້ຜູກໄວ້',
                  style: TextStyle(fontSize: fixedSize * 0.015),
                ),
              ),

              SizedBox(height: fixedSize * 0.02),
              TextField(
                controller: phoneControl,
                keyboardType: TextInputType.phone,
                maxLength: 11,
                decoration: InputDecoration(
                  labelText: 'ເບິໂທລະສັບ',
                  prefixIcon: Icon(Icons.phone),
                  counterText: '',
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 20,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      fixedSize * 0.02,
                    ), // วงมน
                    borderSide: BorderSide(color: AppColors.color1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(fixedSize * 0.02),
                    borderSide: BorderSide(color: AppColors.color1, width: 2),
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
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Container(
            decoration: BoxDecoration(gradient: AppColors.main),
            child: FloatingActionButton.extended(
              onPressed: () {
                checkPhone();
              },
              label: Center(
                child: Text(
                  'ຕໍ່ໄປ',
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
