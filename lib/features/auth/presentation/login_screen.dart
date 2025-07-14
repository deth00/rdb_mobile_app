import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moblie_banking/core/utils/app_colors.dart';
import 'package:moblie_banking/core/utils/app_image.dart';
import 'package:moblie_banking/core/utils/snackbar_helper.dart';
import 'package:moblie_banking/features/auth/logic/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

bool _isObscure = true;

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late final phoneControl = TextEditingController();
  late final pwControl = TextEditingController();
  @override
  void dispose() {
    phoneControl.dispose();
    pwControl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final phone = phoneControl.text.trim();
    final password = pwControl.text.trim();

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

    await ref.read(authNotifierProvider.notifier).login(phone, password);
    if (context.mounted) Navigator.of(context).pop();
    final authState = ref.watch(authNotifierProvider);

    if (authState.isLoggedIn) {
      if (mounted) {
        context.go('/home');
      }
    } else {
      showCustomSnackBar(context, 'ເບີໂທ ຫຼື ລະຫັດຜ່ານບໍ່ຖືກ', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double fixedSize = size.width + size.height;
    final isLoading = ref.watch(authNotifierProvider).isLoading;
    final authController = ref.read(authNotifierProvider.notifier);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: fixedSize * 0.035),
              Center(child: Image.asset(AppImage.logoRDB, scale: 1.2)),
              Container(
                height: fixedSize * 0.29,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppImage.bglogin),
                    fit: BoxFit.contain,
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: fixedSize * 0.02),
                    Container(
                      height: fixedSize * 0.045,
                      width: fixedSize * 0.29,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: fixedSize * 0.0045,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: AppTextField(
                        textInputType: TextInputType.phone,
                        obs: false,
                        controller: phoneControl,
                        text: 'ເບີໂທ 020 xxxx xxxx',
                        icon: const Icon(
                          Icons.account_circle,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    SizedBox(height: fixedSize * 0.02),
                    Container(
                      height: fixedSize * 0.045,
                      width: fixedSize * 0.29,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: fixedSize * 0.0045,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: AppTextField(
                        textInputType: TextInputType.multiline,
                        obs: _isObscure,
                        controller: pwControl,
                        text: 'ລະຫັດ: ********',
                        icon: const Icon(Icons.lock_reset, color: Colors.grey),
                        icon1: IconButton(
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                          icon: Icon(
                            _isObscure
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: fixedSize * 0.02),
                    Consumer(
                      builder: (context, ref, _) => GestureDetector(
                        onTap: isLoading ? null : _login,

                        child: Container(
                          height: fixedSize * 0.045,
                          width: fixedSize * 0.29,
                          decoration: BoxDecoration(
                            gradient: AppColors.main,
                            borderRadius: BorderRadius.all(
                              Radius.circular(fixedSize * 0.016),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'ເຂົ້າສູ່ລະບົບ',
                              style: TextStyle(
                                fontSize: fixedSize * 0.017,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: fixedSize * 0.010),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            context.push('/forgotPassword');
                          },
                          child: Text(
                            'ລືມລະຫັດຜ່ານ ? ',
                            style: TextStyle(
                              fontSize: fixedSize * 0.014,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        SizedBox(width: fixedSize * 0.005),
                        GestureDetector(
                          onTap: () {
                            context.push('/checkPhone');
                          },
                          child: Text(
                            'ລົງທະບຽນ',
                            style: TextStyle(
                              fontSize: fixedSize * 0.014,
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: fixedSize * 0.010),

                    GestureDetector(
                      onTap: () {
                        print(123);
                        authController.biometricLogin();
                      },
                      child: Container(
                        height: fixedSize * 0.045,
                        width: fixedSize * 0.075,
                        decoration: BoxDecoration(
                          gradient: AppColors.main,
                          borderRadius: BorderRadius.all(
                            Radius.circular(fixedSize * 0.016),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: fixedSize * 0.001,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                Icons.fingerprint,
                                color: Colors.white,
                                size: fixedSize * 0.032,
                              ),
                              Image.asset(
                                AppImage.faceID,
                                color: Colors.white,
                                scale: fixedSize * 0.009,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: fixedSize * 0.01),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        height: fixedSize * 0.035,
                        width: fixedSize * 0.14,
                        decoration: BoxDecoration(
                          color: AppColors.color1,
                          borderRadius: BorderRadius.all(
                            Radius.circular(fixedSize * 0.016),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade500,
                              offset: const Offset(0, 3),
                              blurRadius: fixedSize * 0.002,
                            ),
                          ],
                        ),
                        child: GestureDetector(
                          onTap: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  left: fixedSize * 0.006,
                                  right: fixedSize * 0.005,
                                ),
                              ),
                              Text(
                                'RDB BANK',
                                style: TextStyle(
                                  fontSize: fixedSize * 0.013,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: fixedSize * 0.035,
                        width: fixedSize * 0.14,
                        decoration: BoxDecoration(
                          color: AppColors.color1,
                          borderRadius: BorderRadius.all(
                            Radius.circular(fixedSize * 0.016),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade500,
                              offset: const Offset(0, 3),
                              blurRadius: 7,
                            ),
                          ],
                        ),
                        child: GestureDetector(
                          onTap: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  left: fixedSize * 0.006,
                                  right: fixedSize * 0.005,
                                ),
                              ),
                              Text(
                                'www.nbb.com.la',
                                style: TextStyle(
                                  fontSize: fixedSize * 0.013,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: fixedSize * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: fixedSize * 0.035,
                          width: fixedSize * 0.14,
                          decoration: BoxDecoration(
                            color: AppColors.color1,
                            borderRadius: BorderRadius.all(
                              Radius.circular(fixedSize * 0.016),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade500,
                                offset: const Offset(0, 3),
                                blurRadius: 7,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  left: fixedSize * 0.009,
                                  right: fixedSize * 0.005,
                                ),
                              ),
                              Text(
                                'calendar',
                                style: TextStyle(
                                  fontSize: fixedSize * 0.013,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: fixedSize * 0.035,
                          width: fixedSize * 0.14,
                          decoration: BoxDecoration(
                            color: AppColors.color1,
                            borderRadius: BorderRadius.all(
                              Radius.circular(fixedSize * 0.016),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade500,
                                offset: const Offset(0, 3),
                                blurRadius: 7,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  left: fixedSize * 0.009,
                                  right: fixedSize * 0.005,
                                ),
                              ),
                              Text(
                                'ບໍລິການອື່ນໆ',
                                style: TextStyle(
                                  fontSize: fixedSize * 0.013,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: fixedSize * 0.01),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ສອບຖາມຂໍ້ມູນເພີ່ມຕື່ມ?',
                      style: TextStyle(fontSize: fixedSize * 0.012),
                    ),
                    SizedBox(width: fixedSize * 0.008),
                    GestureDetector(
                      child: Container(
                        height: fixedSize * 0.026,
                        width: fixedSize * 0.065,
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.all(
                            Radius.circular(fixedSize * 0.02),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade500,
                              offset: const Offset(0, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'ຕິດຕໍ່',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.white,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: fixedSize * 0.013,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppTextField extends StatelessWidget {
  final String text;
  final Widget icon;
  final Widget? icon1;
  final bool obs;
  final TextEditingController controller;
  final TextInputType textInputType;

  const AppTextField({
    super.key,
    required this.text,
    required this.icon,
    this.icon1,
    required this.obs,
    required this.controller,
    required this.textInputType,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 55,
      width: 360,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 15,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: TextField(
        keyboardType: textInputType,
        controller: controller,
        obscureText: obs,
        style: const TextStyle(color: Colors.grey),
        decoration: InputDecoration(
          prefixIcon: icon,
          suffixIcon: icon1,
          fillColor: Colors.grey.shade100,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(screenWidth * 0.1),
            borderSide: const BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(screenWidth * 0.1),
            borderSide: const BorderSide(color: Colors.white),
          ),
          hintText: text,
          hintStyle: const TextStyle(color: Colors.grey, letterSpacing: 0.8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(screenWidth * 0.7),
          ),
        ),
      ),
    );
  }
}
