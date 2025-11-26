import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:moblie_banking/core/utils/app_colors.dart';
import 'package:moblie_banking/core/utils/app_image.dart';
import 'package:moblie_banking/features/account/logic/profile_state.dart';
import 'package:moblie_banking/features/auth/logic/auth_provider.dart';
import 'package:moblie_banking/features/home/logic/home_provider.dart';
import 'package:moblie_banking/features/account/logic/profile_provider.dart';
import 'package:moblie_banking/widgets/appbar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Future<void> logout() async {
    await ref.read(authNotifierProvider.notifier).logout();
    if (mounted) {
      context.goNamed('login');
    }
  }

  Future<void> generateQR() async {
    await ref.read(homeNotifierProvider.notifier).generateQR();
    if (mounted) {
      context.pushNamed('accountQR');
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(homeNotifierProvider.notifier).getAccountDPT();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authstate = ref.watch(authNotifierProvider);
    final user = authstate.user;
    final acDpt = ref.watch(homeNotifierProvider);
    final profileState = ref.watch(profileNotifierProvider);
    return Scaffold(
      appBar: GradientAppBar(
        title: 'RDB Pay',
        isLogout: true,
        onIconPressed: () {
          logout();
        },
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: 120.h,
                  width: double.infinity,
                  color: AppColors.color2.withOpacity(0.1),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: user == null
                        ? Text('ບໍ່ມີຂໍ້ມຼນ', style: TextStyle(fontSize: 16.sp))
                        : Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 10.w),
                                child: ClipOval(
                                  child: _buildProfileImage(
                                    user.profile,
                                    80.h,
                                    profileState,
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${user.firstName} ${user.lastName}',
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        user.phone,
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      SizedBox(width: 65.w),
                                      GestureDetector(
                                        onTap: () {
                                          context.pushNamed('account');
                                        },
                                        child: Container(
                                          height: 35.h,
                                          width: 65.w,
                                          decoration: BoxDecoration(
                                            color: AppColors.color1,
                                            borderRadius: BorderRadius.circular(
                                              20.r,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'ແກ້ໄຂ',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14.sp,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 5.w),
                                      GestureDetector(
                                        onTap: () {
                                          context.pushNamed('addACDPT');
                                        },
                                        child: Container(
                                          height: 35.h,
                                          width: 90.w,
                                          decoration: BoxDecoration(
                                            color: AppColors.color1,
                                            borderRadius: BorderRadius.circular(
                                              20.r,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'ເພີ່ມບັນຊີ',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14.sp,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                  ),
                ),

                acDpt.isLoading
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 20.h),
                          ],
                        ),
                      )
                    : acDpt.errorMessage != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64.sp,
                              color: Colors.red,
                            ),
                            SizedBox(height: 20.h),
                            Text(
                              'ເກີດຂໍ້ຜິດພາດໃນການເຊື່ອມຕໍ່ກັບ Server',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 16.sp,
                              ),
                            ),
                            SizedBox(height: 20.h),
                            ElevatedButton(
                              onPressed: () {
                                ref
                                    .read(homeNotifierProvider.notifier)
                                    .clearError();
                                ref
                                    .read(homeNotifierProvider.notifier)
                                    .getAccountDPT();
                              },
                              child: Text(
                                'ລອງໃໝ່',
                                style: TextStyle(fontSize: 16.sp),
                              ),
                            ),
                          ],
                        ),
                      )
                    : acDpt.accountDpt.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.account_balance,
                              size: 64.sp,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 20.h),
                            Text(
                              'ບໍ່ມີບັນຊີ',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16.sp,
                              ),
                            ),
                            SizedBox(height: 20.h),
                            ElevatedButton(
                              onPressed: () {
                                context.pushNamed('addACDPT');
                              },
                              child: Text(
                                'ເພີ່ມບັນຊີ',
                                style: TextStyle(fontSize: 16.sp),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Expanded(
                        child: ListView.separated(
                          separatorBuilder: (_, __) => const Divider(),
                          itemCount: acDpt.accountDpt.length,
                          itemBuilder: (context, index) {
                            final account = acDpt.accountDpt[index];
                            return SizedBox(
                              // height: 100.h,
                              width: double.infinity,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.w,
                                    ),
                                    child: Image.asset(
                                      AppImage.mF,
                                      width: 120.w,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      context.pushNamed(
                                        'homeDeposit',
                                        pathParameters: {
                                          'acno': account.linkValue,
                                        },
                                      );
                                    },
                                    child: Container(
                                      width: 220.w,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            account.linkType == "DPT"
                                                ? 'ບັນຊີເງິນຝາກ'
                                                : '',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            account.linkValue,
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 16.sp,
                                            ),
                                          ),
                                          Text(
                                            user == null
                                                ? ""
                                                : "${user.firstName}${user.lastName}",
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      generateQR();
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 10.w),
                                      child: SvgPicture.asset(
                                        AppImage.qr,
                                        width: 55.w,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                // SizedBox(
                //   height: 100.h,
                //   width: double.infinity,
                //   child: Row(
                //     children: [
                //       Padding(
                //         padding: EdgeInsets.symmetric(horizontal: 10.w),
                //         child: Image.asset(
                //           AppImage.mF,
                //           width: 120.w,
                //           fit: BoxFit.contain,
                //         ),
                //       ),
                //       GestureDetector(
                //         onTap: () {
                //           context.pushNamed(
                //             'webview',
                //             queryParameters: {
                //               'url': 'https://fund.nbb.com.la',
                //               'title': 'ເງິນກອງທຶນ',
                //             },
                //           );
                //         },
                //         child: Container(
                //           color: Colors.white,
                //           width: 220.w,
                //           child: Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             children: [
                //               Text(
                //                 'ເງິນກອງທຶນ',
                //                 style: TextStyle(
                //                   color: Colors.black,
                //                   fontSize: 20.sp,
                //                 ),
                //               ),
                //               Text(
                //                 user == null
                //                     ? ""
                //                     : "${user.firstName}${user.lastName}",
                //                 style: TextStyle(
                //                   color: Colors.grey,
                //                   fontSize: 16.sp,
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),
                //       GestureDetector(
                //         onTap: () {
                //           generateQR();
                //         },
                //         child: Padding(
                //           padding: EdgeInsets.only(right: 10.w),
                //           child: SvgPicture.asset(AppImage.qr, width: 55.w),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
            // ปุ่มสแกน QR ที่มุมขวาล่าง
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.pushNamed('scanQR');
                      },
                      child: Container(
                        width: 60.w,
                        height: 60.h,
                        decoration: BoxDecoration(shape: BoxShape.circle),
                        child: Center(
                          child: SvgPicture.asset(AppImage.scan, width: 45.w),
                        ),
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      'ສະແກນ',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage(
    String? profile,
    double size,
    ProfileState profileState,
  ) {
    // Show selected image if available (preview before upload)
    if (profileState.selectedImage != null) {
      return Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5.r),
            child: SvgPicture.file(
              profileState.selectedImage!,
              width: size,
              height: size,
              fit: BoxFit.cover,
            ),
          ),
          // Preview indicator
          Positioned(
            top: 4.h,
            right: 4.w,
            child: Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(Icons.edit, size: 12.sp, color: Colors.white),
            ),
          ),
        ],
      );
    }

    // Show user's profile image if available and not hidden
    if (profile != null && profile.isNotEmpty && !profileState.isImageHidden) {
      if (profile.startsWith('http')) {
        return CachedNetworkImage(
          imageUrl: profile,
          width: size,
          height: size,
          fit: BoxFit.cover,
          placeholder: (context, url) => SizedBox(
            width: size,
            height: size,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ),
          errorWidget: (context, url, error) => Container(
            width: size,
            height: size,
            color: Colors.grey[300],
            child: Icon(Icons.person, color: Colors.grey, size: size * 0.7),
          ),
        );
      } else if (profile.startsWith('data:image/')) {
        // Decode base64
        final base64Str = profile.split(',').last;
        final bytes = base64Decode(base64Str);
        return Image.memory(
          bytes,
          width: size,
          height: size,
          fit: BoxFit.cover,
        );
      } else {
        // Assume it's a path to be appended to your API
        return CachedNetworkImage(
          imageUrl: 'https://fund.nbb.com.la/api/v1/$profile',
          width: size,
          height: size,
          fit: BoxFit.cover,
          placeholder: (context, url) => SizedBox(
            width: size,
            height: size,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ),
          errorWidget: (context, url, error) => Container(
            width: size,
            height: size,
            color: Colors.grey[300],
            child: Icon(Icons.person, color: Colors.grey, size: size * 0.7),
          ),
        );
      }
    }

    // Show hidden indicator if image is hidden
    if (profileState.isImageHidden && profile != null && profile.isNotEmpty) {
      return Stack(
        children: [
          Container(
            width: size,
            height: size,
            color: Colors.grey[300],
            child: Icon(Icons.person, color: Colors.grey, size: size * 0.7),
          ),
          Positioned(
            top: 4.h,
            right: 4.w,
            child: Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.visibility_off,
                size: 12.sp,
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    }

    // Default icon (same as home screen)
    return Container(
      width: size,
      height: size,
      color: Colors.grey[300],
      child: Icon(Icons.person, color: Colors.grey, size: size * 0.7),
    );
  }
}
