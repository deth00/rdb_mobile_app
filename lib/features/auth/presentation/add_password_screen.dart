import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:moblie_banking/core/utils/app_colors.dart';
import 'package:moblie_banking/core/utils/snackbar_helper.dart';
import 'package:moblie_banking/features/auth/logic/auth_provider.dart';
import 'package:moblie_banking/widgets/appbar.dart';

class AddPasswordScreen extends ConsumerStatefulWidget {
  final String? redirectUrl;

  const AddPasswordScreen({Key? key, this.redirectUrl}) : super(key: key);

  @override
  ConsumerState<AddPasswordScreen> createState() => _AddPasswordScreenState();
}

class _AddPasswordScreenState extends ConsumerState<AddPasswordScreen> {
  bool _isObscure = true;
  bool _isLoading = false;
  final phoneControl = TextEditingController();
  final pwControl = TextEditingController();
  String? _redirectUrl;

  @override
  void initState() {
    super.initState();
    // Get redirect URL from route parameters
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final savedPhone = await ref.read(secureStorageProvider).getPhone();
      if (savedPhone != null && savedPhone.isNotEmpty) {
        setState(() {
          _redirectUrl = widget.redirectUrl;
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

    setState(() {
      _isLoading = true;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await ref.read(authNotifierProvider.notifier).login(phone, password);
      if (context.mounted) Navigator.of(context).pop();
      final authState = ref.read(authNotifierProvider);

      if (authState.isLoggedIn) {
        showCustomSnackBar(context, 'ເຂົ້າສູ່ລະບົບສຳເລັດ', isError: false);
        if (mounted) {
          // Navigate to the redirect URL or default to home
          if (widget.redirectUrl != null && widget.redirectUrl!.isNotEmpty) {
            context.pushNamed(widget.redirectUrl!);
          } else {
            context.goNamed('home');
          }
        }
      } else {
        showCustomSnackBar(context, 'ເບີໂທ ຫຼື ລະຫັດຜ່ານບໍ່ຖືກ', isError: true);
      }
    } catch (e) {
      if (context.mounted) Navigator.of(context).pop();
      showCustomSnackBar(
        context,
        'ເກີດຂໍ້ຜິດພາດໃນການເຂົ້າສູ່ລະບົບ',
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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

    setState(() {
      _isLoading = true;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await ref.read(authNotifierProvider.notifier).biometricLogin();
      final authState = ref.read(authNotifierProvider);
      if (context.mounted) Navigator.of(context).pop();

      if (authState.isLoggedIn) {
        showCustomSnackBar(context, 'ເຂົ້າສູ່ລະບົບສຳເລັດ', isError: false);
        if (mounted) {
          // Navigate to the redirect URL or default to home
          if (widget.redirectUrl != null && widget.redirectUrl!.isNotEmpty) {
            context.pushNamed(widget.redirectUrl!);
          } else {
            context.goNamed('home');
          }
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
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GradientAppBar(
        title: '',
        icon: Icons.arrow_back,
        onIconPressed: () => context.pop(),
        actions: [
          IconButton(
            icon: Icon(Icons.lock, color: Colors.white),
            onPressed: () {
              // Handle forgot password
              context.pushNamed('forgotPassword');
            },
          ),
          IconButton(
            icon: Icon(Icons.close, color: Colors.white),
            onPressed: () => context.pop(),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 24.h),
            // Avatar
            CircleAvatar(
              radius: 80.r,
              backgroundColor: AppColors.color1,
              child: Icon(Icons.person, color: Colors.white, size: 120.r),
            ),
            SizedBox(height: 24.h),
            // Username
            Text(
              'ກະລຸນາປ້ອນລະຫັດຜ່ານ',
              style: TextStyle(
                fontSize: 20.sp,
                color: AppColors.color1,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 24.h),
            // Password field
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: TextField(
                controller: pwControl,
                obscureText: _isObscure,
                enabled: !_isLoading,
                decoration: InputDecoration(
                  hintText: 'ປ້ອນລະຫັດ',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscure ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.color1,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.r),
                    borderSide: BorderSide(color: AppColors.color1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.r),
                    borderSide: BorderSide(color: AppColors.color1, width: 2),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 16.h,
                    horizontal: 20.w,
                  ),
                ),
                onSubmitted: (_) => _login(),
              ),
            ),
            SizedBox(height: 16.h),
            // Login button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.color1,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                  ),
                  child: _isLoading
                      ? SizedBox(
                          height: 20.h,
                          width: 20.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Text(
                          'ເຂົ້າສູ່ລະບົບ',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            // Biometric label and icons
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ເຂົ້າລະບົບດ້ວຍຊີວະພາບ',
                    style: TextStyle(color: AppColors.color1, fontSize: 14.sp),
                  ),
                  SizedBox(height: 16.h),
                  if (authState.canUseBiometric && authState.isBiometricEnabled)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: _isLoading ? null : _bioLogin,
                          child: Container(
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.color1,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Icon(
                              Icons.fingerprint,
                              color: AppColors.color1,
                              size: 32.r,
                            ),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        GestureDetector(
                          onTap: _isLoading ? null : _bioLogin,
                          child: Container(
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.color1,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Icon(
                              Icons.face,
                              color: AppColors.color1,
                              size: 32.r,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            // Spacer
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }
}
