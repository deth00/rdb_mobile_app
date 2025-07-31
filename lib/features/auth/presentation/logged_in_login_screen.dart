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

class LoggedInLoginScreen extends ConsumerStatefulWidget {
  const LoggedInLoginScreen({super.key});

  @override
  ConsumerState<LoggedInLoginScreen> createState() =>
      _LoggedInLoginScreenState();
}

class _LoggedInLoginScreenState extends ConsumerState<LoggedInLoginScreen> {
  final phoneControl = TextEditingController();
  final pwControl = TextEditingController();
  bool _isObscure = true;
  String name = '';
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(authNotifierProvider.notifier).load();
      final savedPhone = await ref.read(secureStorageProvider).getPhone();
      final saveName = await ref.read(secureStorageProvider).getName();
      if (saveName != null && saveName.isNotEmpty) {
        setState(() {
          name = saveName;
        });
      }
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
    Size size = MediaQuery.of(context).size;
    double fixedSize = size.width + size.height;
    final authState = ref.watch(authNotifierProvider);
    final slideAsync = ref.watch(slideProvider);
    final isLoading = ref.watch(authNotifierProvider).isLoading;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20.h),

              // Header with Logo and Icons
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Logo
                    Image.asset(AppImage.lordb, scale: 20, fit: BoxFit.cover),
                    _buildHeaderIcon(
                      icon: Icons.facebook,
                      color: AppColors.color1,
                      onTap: () {},
                    ),
                    SizedBox(width: 10.w),
                    _buildHeaderIcon(
                      icon: Icons.language,
                      color: AppColors.color1,
                      onTap: () {},
                    ),
                    SizedBox(width: 10.w),
                    _buildHeaderIcon(
                      icon: Icons.calendar_today,
                      color: AppColors.color1,
                      onTap: () {
                        context.pushNamed('calendar');
                      },
                    ),
                    SizedBox(width: 10.w),
                    Container(
                      width: 35.w,
                      height: 35.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.flag_circle,
                          color: AppColors.color1,
                          size: 45.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              // Promotional Banner
              Padding(
                padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 10.h),
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
                          SizedBox(height: 8),
                          Text(
                            'ເກີດຂໍ້ຜິດພາດໃນການໂຫຼດສະໄລດ໌',
                            style: TextStyle(color: Colors.red),
                          ),
                          SizedBox(height: 8),
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

              SizedBox(height: 25.h),

              // Login Form Section
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.w),
                child: Column(
                  children: [
                    // Username Field
                    Container(
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        gradient: AppColors.main,
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 3,
                            color: Colors.grey.shade400,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Container(
                        height: 50.h,
                        width: 340.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(40)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.w),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.account_circle,
                                    color: AppColors.color1,
                                    size: 45.sp,
                                  ),
                                  SizedBox(width: 10.w),
                                  Text(
                                    name.isNotEmpty
                                        ? name
                                        : '${authState.user?.firstName ?? ''} ${authState.user?.lastName ?? ''}',
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      color: AppColors.color1,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 10.w),
                              child: GestureDetector(
                                onTap: () {
                                  _showDialog(context);
                                },
                                child: Icon(
                                  Icons.close_rounded,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // Password Field
                    Container(
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        gradient: AppColors.main,
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 3,
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

                    SizedBox(height: 25.h),

                    // Login Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Consumer(
                          builder: (context, ref, _) => GestureDetector(
                            onTap: isLoading ? null : _login,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.w),
                              child: Container(
                                height: 50.h,
                                width: 230.w,
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
                              message: 'ເຂົ້າສູ່ລະບົບດ້ວຍລາຍນິ້ວມື ຫຼື Face ID',
                              child: Container(
                                height: 50.h,
                                width: 90.w,
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
                                            size: 35.sp,
                                          ),
                                          SizedBox(width: 5.w),
                                          SvgPicture.asset(SvgIcons.faceId),
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

                    SizedBox(height: 15.h),

                    // Forgot Password Link
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.w),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () {
                            context.pushNamed('forgotPassword');
                          },
                          child: Text(
                            'ລືມລະຫັດຜ່ານ ?',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.color1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 15.h),
              Divider(color: AppColors.color1),
              SizedBox(height: 15.h),
              // Quick Action Buttons
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildQuickActionButton(
                          icon: Icons.sync_alt_outlined,
                          label: 'ໂອນເງິນ',
                          onTap: () => context.goNamed('transfer'),
                        ),
                        _buildQuickActionButton(
                          icon: Icons.qr_code_scanner,
                          label: 'ສະແກນ',
                          onTap: () => context.goNamed('scanQR'),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildQuickActionButton(
                          icon: Icons.qr_code,
                          label: 'QR ຕົວເອງ',
                          onTap: () => context.goNamed('qr'),
                        ),
                        _buildQuickActionButton(
                          icon: Icons.grid_view,
                          label: 'ບໍລິການອື່ນໆ',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15.h),
              Divider(color: AppColors.color1),
              SizedBox(height: 15.h),

              // Footer
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.h),
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
                            Icon(
                              Icons.copyright,
                              color: Colors.white,
                              size: 16.sp,
                            ),
                            Text(
                              'ຕິດຕໍ',
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

  Widget _buildHeaderIcon({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 35.w,
        height: 35.w,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Icon(icon, color: Colors.white, size: 18.sp),
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.h,
        width: 150.w,
        decoration: BoxDecoration(
          color: AppColors.color1,
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 24.sp),
            SizedBox(height: 5.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('ຢືນຢັນການປ່ຽນຜູ້ໃຊ້'),
        content: const Text('ທ່ານຕ້ອງການປ່ຽນຜູ້ໃຊ້ແທ້ຫຼືບໍ່?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('ຍົກເລີກ'),
          ),
          ElevatedButton(
            onPressed: () {
              // setState(() {
              //   name = '';
              //   phoneControl.clear();
              //   pwControl.clear();
              // });
              context.goNamed('loginNever');
              Navigator.of(context).pop();

              // Optionally navigate to login or scan page:
              // context.goNamed('login');
            },
            child: const Text('ຢືນຢັນ'),
          ),
        ],
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
  final bool readOnly;

  const AppTextField({
    super.key,
    required this.text,
    required this.icon,
    this.icon1,
    required this.obs,
    required this.controller,
    required this.textInputType,
    this.readOnly = false,
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
        readOnly: readOnly,
        style: TextStyle(color: AppColors.color1, fontSize: 20.sp),
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
