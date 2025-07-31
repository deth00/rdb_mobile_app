import 'dart:convert';

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
import 'package:moblie_banking/features/account/logic/profile_state.dart';
import 'package:moblie_banking/features/auth/logic/auth_provider.dart';
import 'package:moblie_banking/features/home/logic/home_provider.dart';
import 'package:moblie_banking/features/account/logic/profile_provider.dart';
import 'package:moblie_banking/features/home/logic/slide_provider.dart';
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
    Size size = MediaQuery.of(context).size;
    double fixedSize = size.width + size.height;
    final authstate = ref.watch(authNotifierProvider);
    final user = authstate.user;
    final acDpt = ref.watch(homeNotifierProvider);
    final profileState = ref.watch(profileNotifierProvider);
    final slideAsync = ref.watch(slideProvider);
    return Scaffold(
      appBar: GradientAppBar(
        title: 'RDB GROW',
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
                Padding(
                  padding: EdgeInsets.all(fixedSize * 0.01),
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
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
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
                            borderRadius: BorderRadius.circular(
                              fixedSize * 0.01,
                            ),
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
                Container(
                  height: fixedSize * 0.09,
                  width: double.infinity,
                  color: AppColors.bgColor2,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: fixedSize * 0.008,
                      right: fixedSize * 0.001,
                    ),
                    child: user == null
                        ? Text('ບໍ່ມີຂໍ້ມຼນ')
                        : Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  right: fixedSize * 0.01,
                                ),
                                child: ClipOval(
                                  child: _buildProfileImage(
                                    user.profile,
                                    fixedSize * 0.06,
                                    profileState,
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Text(
                                  //   'null',
                                  //   style: TextStyle(
                                  //     color: Colors.black,
                                  //     fontSize: fixedSize * 0.013,
                                  //     fontWeight: FontWeight.w500,
                                  //   ),
                                  // ),
                                  // SizedBox(height: fixedSize * 0.003),
                                  Text(
                                    '${user.firstName} ${user.lastName}',
                                    style: TextStyle(
                                      fontSize: fixedSize * 0.012,
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
                                          fontSize: fixedSize * 0.012,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      SizedBox(width: fixedSize * 0.05),
                                      GestureDetector(
                                        onTap: () {
                                          context.pushNamed('account');
                                        },
                                        child: Container(
                                          height: fixedSize * 0.02,
                                          width: fixedSize * 0.04,
                                          decoration: BoxDecoration(
                                            color: AppColors.color1,
                                            borderRadius: BorderRadius.circular(
                                              fixedSize * 0.01,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsetsGeometry.all(1),
                                            child: Center(
                                              child: Text(
                                                'ແກ້ໄຂ',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: fixedSize * 0.010,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: fixedSize * 0.003),
                                      GestureDetector(
                                        onTap: () {
                                          context.pushNamed('addACDPT');
                                        },
                                        child: Container(
                                          height: fixedSize * 0.02,
                                          width: fixedSize * 0.05,
                                          decoration: BoxDecoration(
                                            color: AppColors.color1,
                                            borderRadius: BorderRadius.circular(
                                              fixedSize * 0.01,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'ເພີ່ມບັນຊີ',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: fixedSize * 0.010,
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

                SizedBox(
                  height: fixedSize * 0.08,
                  width: double.infinity,
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: fixedSize * 0.008,
                          right: fixedSize * 0.008,
                        ),
                        child: Image.asset(
                          AppImage.mF,
                          width: 80.w,
                          fit: BoxFit.contain,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.pushNamed(
                            'webview',
                            queryParameters: {
                              'url': 'https://www.google.co.th',
                            },
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: fixedSize * 0.001),
                          child: Container(
                            color: Colors.white,
                            width: fixedSize * 0.16,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Text(
                                //   '',
                                //   style: TextStyle(
                                //     color: Colors.black,
                                //     fontSize: fixedSize * 0.013,
                                //     fontWeight: FontWeight.w500,
                                //   ),
                                // ),
                                Text(
                                  'ເງິນກອງທຶນ',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: fixedSize * 0.012,
                                  ),
                                ),
                                Text(
                                  user == null
                                      ? ""
                                      : "${user.firstName}${user.lastName}",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: fixedSize * 0.012,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          generateQR();
                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: fixedSize * 0.001),
                          child: SvgPicture.asset(AppImage.qr, width: 45.w),
                        ),
                      ),
                    ],
                  ),
                ),
                acDpt.isLoading
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: fixedSize * 0.01),
                            // Text('ກຳລັງໂຫຼດຂໍ້ມູນບັນຊີ...'),
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
                              size: 64,
                              color: Colors.red,
                            ),
                            SizedBox(height: fixedSize * 0.01),
                            Text(
                              'ເກີດຂໍ້ຜິດພາດໃນການເຊື່ອມຕໍ່ກັບ Server',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.red),
                            ),
                            SizedBox(height: fixedSize * 0.01),
                            ElevatedButton(
                              onPressed: () {
                                ref
                                    .read(homeNotifierProvider.notifier)
                                    .clearError();
                                ref
                                    .read(homeNotifierProvider.notifier)
                                    .getAccountDPT();
                              },
                              child: Text('ລອງໃໝ່'),
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
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: fixedSize * 0.01),
                            Text(
                              'ບໍ່ມີບັນຊີ',
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(height: fixedSize * 0.01),
                            ElevatedButton(
                              onPressed: () {
                                context.pushNamed('addACDPT');
                              },
                              child: Text('ເພີ່ມບັນຊີ'),
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
                              height: fixedSize * 0.08,
                              width: double.infinity,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: fixedSize * 0.008,
                                      right: fixedSize * 0.008,
                                    ),
                                    child: Image.asset(
                                      AppImage.mF,
                                      width: 80.w,
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
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        right: fixedSize * 0.001,
                                      ),
                                      child: SizedBox(
                                        width: fixedSize * 0.16,
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
                                                fontSize: fixedSize * 0.013,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              account.linkValue,
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: fixedSize * 0.012,
                                              ),
                                            ),
                                            Text(
                                              user == null
                                                  ? ""
                                                  : "${user.firstName}${user.lastName}",
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: fixedSize * 0.012,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      generateQR();
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        right: fixedSize * 0.001,
                                      ),
                                      child: SvgPicture.asset(
                                        AppImage.qr,
                                        width: 45.w,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
              ],
            ),
            // ปุ่มสแกน QR ที่มุมขวาล่าง
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.all(fixedSize * 0.01),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.pushNamed('scanQR');
                      },
                      child: Container(
                        width: fixedSize * 0.05,
                        height: fixedSize * 0.05,
                        decoration: BoxDecoration(
                          // color: Colors.amber,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: SvgPicture.asset(AppImage.scan, width: 45.w),
                        ),
                      ),
                    ),
                    Text(
                      'ສະແກນ',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
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
            borderRadius: BorderRadius.circular(size * 0.001),
            child: SvgPicture.file(
              profileState.selectedImage!,
              width: size,
              height: size,
              fit: BoxFit.cover,
            ),
          ),
          // Preview indicator
          Positioned(
            top: 4,
            right: 4,
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.edit, size: 12, color: Colors.white),
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
            top: 4,
            right: 4,
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.visibility_off, size: 12, color: Colors.white),
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
