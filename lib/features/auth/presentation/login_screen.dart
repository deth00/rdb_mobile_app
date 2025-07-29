import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:moblie_banking/core/utils/app_colors.dart';
import 'package:moblie_banking/core/utils/app_image.dart';
import 'package:moblie_banking/core/utils/snackbar_helper.dart';
import 'package:moblie_banking/core/utils/svg_icons.dart';
import 'package:moblie_banking/features/auth/logic/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

bool _isObscure = true;

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final phoneControl = TextEditingController();
  final pwControl = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(authNotifierProvider.notifier).load();
      // Load saved phone number and display it
      final savedPhone = await ref.read(secureStorageProvider).getPhone();
      if (savedPhone != null && savedPhone.isNotEmpty) {
        setState(() {
          phoneControl.text = savedPhone;
        });
      }
    });
  }

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
    final authState = ref.read(authNotifierProvider);

    if (authState.isLoggedIn) {
      if (mounted) {
        context.goNamed('home');
      }
    } else {
      showCustomSnackBar(context, 'ເບີໂທ ຫຼື ລະຫັດຜ່ານບໍ່ຖືກ', isError: true);
    }
  }

  Future<void> _bioLogin() async {
    // Check if biometric is enabled first
    final currentAuthState = ref.read(authNotifierProvider);
    if (!currentAuthState.isBiometricEnabled) {
      showCustomSnackBar(
        context,
        'ກະລຸນາເປີດໃຊ້ງານການຢືນຢັນຕົວຕົນໃນການຕັ້ງຄ່າ',
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

    try {
      await ref.read(authNotifierProvider.notifier).biometricLogin();
      final authState = ref.read(authNotifierProvider);
      if (context.mounted) Navigator.of(context).pop();
      if (authState.isLoggedIn) {
        if (mounted) {
          context.goNamed('home');
        }
      } else {
        showCustomSnackBar(
          context,
          'ຢືນຢັນຕົວຕົນດ້ວຍ Biometric ບໍ່ສຳເລັດ',
          isError: true,
        );
      }
    } catch (e) {
      if (context.mounted) Navigator.of(context).pop();
      showCustomSnackBar(context, 'ການຢືນຢັນຕົວຕົນລົ້ມເຫລວ', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authNotifierProvider).isLoading;
    final authController = ref.read(authNotifierProvider.notifier);
    final authState = ref.watch(authNotifierProvider);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 50.h),
              // Image.asset(AppImage.logoRDB, height: 180.h),
              Center(child: SvgPicture.asset(SvgIcons.logoApp, height: 180.h)),
              Stack(
                children: [
                  SvgPicture.asset(SvgIcons.loginBg),
                  Container(
                    height: 350.h,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      // image: DecorationImage(
                      //   image: AssetImage(AppImage.bglogin),
                      //   scale: 1.2,
                      //   fit: BoxFit.cover,
                      // ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 20.h),
                        Container(
                          height: 50.h,
                          width: 330.w,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6.r,
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
                        SizedBox(height: 20.h),
                        Container(
                          height: 50.h,
                          width: 330.w,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6.r,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: AppTextField(
                            textInputType: TextInputType.multiline,
                            obs: _isObscure,
                            controller: pwControl,
                            text: 'ລະຫັດ: ********',
                            icon: const Icon(
                              Icons.lock_reset,
                              color: Colors.grey,
                            ),
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
                        SizedBox(height: 20.h),
                        Consumer(
                          builder: (context, ref, _) => GestureDetector(
                            onTap: isLoading ? null : _login,

                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.w),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,

                                children: [
                                  Container(
                                    height: 50.h,
                                    width: 230.w,
                                    decoration: BoxDecoration(
                                      color: AppColors.color1,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(30.r),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 1.r,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        'ເຂົ້າສູ່ລະບົບ',
                                        style: TextStyle(
                                          fontSize: 17.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.8,
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (authState.canUseBiometric &&
                                      authState.isBiometricEnabled)
                                    GestureDetector(
                                      onTap: () {
                                        _bioLogin();
                                      },
                                      child: Tooltip(
                                        message:
                                            'ເຂົ້າສູ່ລະບົບດ້ວຍລາຍນິ້ວມື ຫຼື Face ID',
                                        child: Container(
                                          height: 50.h,
                                          width: 95.w,
                                          decoration: BoxDecoration(
                                            gradient: AppColors.main,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(30.r),
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black12,
                                                blurRadius: 1.r,
                                                offset: const Offset(0, 5),
                                              ),
                                            ],
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(1.w),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(30.r),
                                                ),
                                              ),
                                              child: Center(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.fingerprint,
                                                      color: AppColors.color1,
                                                      size: 30.sp,
                                                    ),
                                                    SvgPicture.asset(
                                                      SvgIcons.faceId,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ), // fingerprint UI
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // SizedBox(height: 10.h),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 30.w,
                            vertical: 15.h,
                          ),
                          child: Row(
                            // mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  context.pushNamed('forgotPassword');
                                },
                                child: Text(
                                  'ລືມລະຫັດຜ່ານ ?   ',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              SizedBox(width: 0.5.w),
                              GestureDetector(
                                onTap: () {
                                  context.pushNamed('checkPhone');
                                },
                                child: Text(
                                  'ລົງທະບຽນ',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        height: 45.h,
                        width: 150.w,
                        decoration: BoxDecoration(
                          color: AppColors.color1,
                          borderRadius: BorderRadius.all(Radius.circular(20.r)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade500,
                              offset: const Offset(0, 3),
                              blurRadius: 2.r,
                            ),
                          ],
                        ),
                        child: GestureDetector(
                          onTap: () {},
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 13.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                  SvgIcons.logoF,
                                  height: 20.h,
                                  width: 20.w,
                                ),
                                SizedBox(width: 5.w),
                                Text(
                                  'RDB BANK',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 45.h,
                        width: 150.w,
                        decoration: BoxDecoration(
                          color: AppColors.color1,
                          borderRadius: BorderRadius.all(Radius.circular(20.r)),
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
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                  SvgIcons.iconW,
                                  height: 20.h,
                                  width: 20.w,
                                ),
                                SizedBox(width: 5.w),
                                Text(
                                  'www.nbb.com.la',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.pushNamed('calendar');
                        },
                        child: Container(
                          height: 45.h,
                          width: 150.w,
                          decoration: BoxDecoration(
                            color: AppColors.color1,
                            borderRadius: BorderRadius.all(
                              Radius.circular(20.r),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade500,
                                offset: const Offset(0, 3),
                                blurRadius: 7,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 13.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                  SvgIcons.calendar,
                                  height: 20.h,
                                  width: 20.w,
                                ),
                                SizedBox(width: 5.w),
                                Text(
                                  'calendar',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 45.h,
                          width: 150.w,
                          decoration: BoxDecoration(
                            color: AppColors.color1,
                            borderRadius: BorderRadius.all(
                              Radius.circular(20.r),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade500,
                                offset: const Offset(0, 3),
                                blurRadius: 7,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 13.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                  SvgIcons.other,
                                  height: 20.h,
                                  width: 20.w,
                                ),
                                SizedBox(width: 5.w),
                                Text(
                                  'ບໍລິການອື່ນໆ',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ສອບຖາມຂໍ້ມູນເພີ່ມຕື່ມ?',
                      style: TextStyle(fontSize: 12.sp),
                    ),
                    SizedBox(width: 9.w),
                    GestureDetector(
                      child: Container(
                        height: 26.h,
                        width: 65.w,
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.all(Radius.circular(16.r)),
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
                                fontSize: 13.sp,
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
