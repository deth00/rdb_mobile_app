import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider_plus/carousel_options.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
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
import 'package:moblie_banking/features/home/logic/slide_provider.dart';

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
      // final savedPhone = await ref.read(secureStorageProvider).getPhone();
      // if (savedPhone != null && savedPhone.isNotEmpty) {
      //   setState(() {
      //     phoneControl.text = savedPhone;
      //   });
      // }
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double fixedSize = size.width + size.height;
    final isLoading = ref.watch(authNotifierProvider).isLoading;
    // final authController = ref.read(authNotifierProvider.notifier);
    // final authState = ref.watch(authNotifierProvider);
    final slideAsync = ref.watch(slideProvider);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20.h),
              Center(child: Image.asset(AppImage.logordb, width: 200.w)),
              Text(
                'Pay smart, Live easy',
                style: TextStyle(
                  fontSize: 19.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.color1,
                ),
              ),
              Text(
                'ເພື່ອຊິວິດທີ່ງ່າຍຂຶ້ນ',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w200,
                  color: AppColors.color1,
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 10.h),
              //   child: SizedBox(
              //     height: fixedSize * 0.13,
              //     width: double.infinity,
              //     child: slideAsync.when(
              //       loading: () => Center(child: CircularProgressIndicator()),

              //       error: (err, stack) => Center(
              //         child: Column(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             Icon(Icons.error_outline, color: Colors.red),
              //             SizedBox(height: 8),
              //             Text(
              //               'ເກີດຂໍ້ຜິດພາດໃນການໂຫຼດສະໄລດ໌',
              //               style: TextStyle(color: Colors.red),
              //             ),
              //             SizedBox(height: 8),
              //             Text(
              //               err.toString(),
              //               style: TextStyle(fontSize: 12, color: Colors.grey),
              //               textAlign: TextAlign.center,
              //             ),
              //           ],
              //         ),
              //       ),
              //       data: (slides) => CarouselSlider.builder(
              //         itemCount: slides.length,
              //         itemBuilder: (context, index, realIndex) {
              //           final slide = slides[index];
              //           return ClipRRect(
              //             borderRadius: BorderRadius.circular(fixedSize * 0.01),
              //             child: CachedNetworkImage(
              //               imageUrl: 'https://web.nbb.com.la/${slide.img}',
              //               fit: BoxFit.cover,
              //               width: double.infinity,
              //               placeholder: (context, url) =>
              //                   Center(child: CircularProgressIndicator()),
              //               errorWidget: (context, url, error) =>
              //                   Icon(Icons.broken_image),
              //             ),
              //           );
              //         },
              //         options: CarouselOptions(
              //           autoPlay: true,
              //           aspectRatio: 2.0,
              //           enlargeCenterPage: true,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              Container(
                height: 250.h,
                width: double.infinity,
                decoration: const BoxDecoration(
                  // color: Colors.amber,
                  // image: DecorationImage(
                  //   image: AssetImage(AppImage.bglogin),
                  //   scale: 1.2,
                  //   fit: BoxFit.cover,
                  // ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 5.h),
                    Container(
                      padding: EdgeInsets.all(3.r),
                      decoration: BoxDecoration(
                        gradient: AppColors.main,
                        borderRadius: BorderRadius.all(Radius.circular(40.r)),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 3.r,
                            color: Colors.grey.shade400,
                            offset: const Offset(0, 5),
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
                      padding: EdgeInsets.all(3.r),
                      decoration: BoxDecoration(
                        gradient: AppColors.main,
                        borderRadius: BorderRadius.all(Radius.circular(40.r)),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 3.r,
                            color: Colors.grey.shade400,
                            offset: Offset(0, 5),
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
                    SizedBox(height: 20.h),
                    Consumer(
                      builder: (context, ref, _) => GestureDetector(
                        onTap: isLoading ? null : _login,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                height: 55.h,
                                width: 240.w,
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
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Padding(
                      padding: EdgeInsets.only(left: 30.w, right: 30.w),
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
                                fontSize: 16.sp,
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
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
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
              Padding(
                padding: EdgeInsets.only(bottom: 15.h, top: 15.h),
                child: SizedBox(
                  height: fixedSize * 0.13,
                  width: double.infinity,
                  child: slideAsync.when(
                    loading: () => Center(child: CircularProgressIndicator()),

                    error: (err, stack) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, color: Colors.red),
                          SizedBox(height: 8.h),
                          Text(
                            'ເກີດຂໍ້ຜິດພາດໃນການໂຫຼດສະໄລດ໌',
                            style: TextStyle(color: Colors.red),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            err.toString(),
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    data: (slides) => CarouselSlider.builder(
                      itemCount: slides.length,
                      itemBuilder: (context, index, realIndex) {
                        final slide = slides[index];
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(fixedSize * 0.01),
                          child: CachedNetworkImage(
                            imageUrl: 'https://web.nbb.com.la/${slide.img}',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            placeholder: (context, url) =>
                                Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.broken_image),
                          ),
                        );
                      },
                      options: CarouselOptions(
                        autoPlay: true,
                        aspectRatio: 2.0,
                        enlargeCenterPage: true,
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        height: 50.h,
                        width: 170.w,
                        decoration: BoxDecoration(
                          color: AppColors.color1,
                          borderRadius: BorderRadius.all(Radius.circular(30.r)),
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
                                  height: 25.h,
                                  width: 25.w,
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  'RDB BANK',
                                  style: TextStyle(
                                    fontSize: 16.sp,
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
                        height: 50.h,
                        width: 170.w,
                        decoration: BoxDecoration(
                          color: AppColors.color1,
                          borderRadius: BorderRadius.all(Radius.circular(30.r)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade500,
                              offset: const Offset(0, 3),
                              blurRadius: 7.r,
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
                                  height: 25.h,
                                  width: 25.w,
                                ),
                                SizedBox(width: 5.w),
                                Text(
                                  'www.nbb.com.la',
                                  style: TextStyle(
                                    fontSize: 16.sp,
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
                          height: 50.h,
                          width: 170.w,
                          decoration: BoxDecoration(
                            color: AppColors.color1,
                            borderRadius: BorderRadius.all(
                              Radius.circular(30.r),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade500,
                                offset: const Offset(0, 3),
                                blurRadius: 7.r,
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
                                  height: 25.h,
                                  width: 25.w,
                                ),
                                SizedBox(width: 5.w),
                                Text(
                                  'calendar',
                                  style: TextStyle(
                                    fontSize: 16.sp,
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
                          height: 50.h,
                          width: 170.w,
                          decoration: BoxDecoration(
                            color: AppColors.color1,
                            borderRadius: BorderRadius.all(
                              Radius.circular(30.r),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade500,
                                offset: const Offset(0, 3),
                                blurRadius: 7.r,
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
                                  height: 25.h,
                                  width: 25.w,
                                ),
                                SizedBox(width: 5.w),
                                Text(
                                  'ບໍລິການອື່ນໆ',
                                  style: TextStyle(
                                    fontSize: 16.sp,
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
                      style: TextStyle(fontSize: 14.sp),
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
      height: 45,
      width: 320,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(screenWidth * 0.1)),
      ),
      child: TextField(
        keyboardType: textInputType,
        controller: controller,
        obscureText: obs,
        style: const TextStyle(color: Colors.grey),
        decoration: InputDecoration(
          prefixIcon: icon,
          suffixIcon: icon1,
          fillColor: Colors.white,
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
