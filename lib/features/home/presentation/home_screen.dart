import 'package:carousel_slider_plus/carousel_options.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moblie_banking/core/utils/app_colors.dart';
import 'package:moblie_banking/core/utils/app_image.dart';
import 'package:moblie_banking/features/auth/logic/auth_provider.dart';
import 'package:moblie_banking/widgets/appbar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Future<void> logout() async {
    await ref.read(authNotifierProvider.notifier).logout();
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double fixedSize = size.width + size.height;
    final authstate = ref.watch(authNotifierProvider);
    final user = authstate.user;
    return Scaffold(
      // backgroundColor: Colors.white,
      // appBar: AppBar(
      //   centerTitle: true,
      //   // backgroundColor: Colors.black,
      //   elevation: 0,
      //   flexibleSpace: Container(
      //     decoration: BoxDecoration(
      //       gradient: AppColors.main, // เรียกใช้ gradient จาก constants
      //     ),
      //   ),
      //   title: Text(
      //     'RDB GROW',
      //     style: TextStyle(
      //       color: Colors.white,
      //       fontSize: fixedSize * 0.016,
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),
      //   actions: [
      //     Padding(
      //       padding: EdgeInsets.only(
      //         top: fixedSize * 0.0075,
      //         right: fixedSize * 0.01,
      //       ),
      //       child: GestureDetector(
      //         onTap: () async {
      //           // Handle logout action
      //         },
      //         child: Column(
      //           children: [
      //             Image.asset(AppImage.logout, scale: 1.2),
      //             Text(
      //               'ອອກລະບົບ',
      //               style: TextStyle(
      //                 fontSize: fixedSize * 0.01,
      //                 fontWeight: FontWeight.bold,
      //                 color: Colors.white,
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
      appBar: GradientAppBar(
        title: 'RDB GROW',
        onIconPressed: () {
          logout();
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Container(
              //   height: fixedSize * 0.045,
              //   width: double.infinity,
              //   color: AppColors.mainColor,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       // GestureDetector(
              //       //   onTap: () {
              //       //     Get.back();
              //       //   },
              //       //   child: Padding(
              //       //     padding: EdgeInsets.only(
              //       //         left: Dimensions.width10,
              //       //         right: Dimensions.width10),
              //       //     child: Image.asset(
              //       //       AppImage.back,
              //       //       color: Colors.white,
              //       //     ),
              //       //   ),
              //       // ),
              //       SizedBox(width: fixedSize * 0.018 + fixedSize * 0.018),
              //       Text(
              //         'RDB GROW',
              //         style: TextStyle(
              //           color: Colors.white,
              //           fontSize: fixedSize * 0.016,
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //       Padding(
              //         padding: EdgeInsets.only(
              //           top: fixedSize * 0.0075,
              //           right: fixedSize * 0.01,
              //         ),
              //         child: GestureDetector(
              //           onTap: () async {},
              //           child: Column(
              //             children: [
              //               Image.asset(AppImage.logout, scale: 1.2),
              //               Text(
              //                 'ອອກລະບົບ',
              //                 style: TextStyle(
              //                   fontSize: fixedSize * 0.01,
              //                   fontWeight: FontWeight.bold,
              //                   color: Colors.white,
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              Padding(
                padding: EdgeInsets.all(fixedSize * 0.01),
                child: SizedBox(
                  height: fixedSize * 0.13,
                  width: double.infinity,
                  child: CarouselSlider.builder(
                    itemCount: 5,
                    itemBuilder: (context, index, realIndex) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 3.0),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(fixedSize * 0.01),
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
                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: fixedSize * 0.01),
                              child: Image.asset(
                                AppImage.photo,
                                scale: MediaQuery.of(context).size.height / 750,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'null',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: fixedSize * 0.013,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: fixedSize * 0.003),
                                Text(
                                  '${user.firstName} ${user.lastName}',
                                  style: TextStyle(
                                    fontSize: fixedSize * 0.012,
                                    color: Colors.grey,
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${user.phone}',
                                      style: TextStyle(
                                        fontSize: fixedSize * 0.012,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    SizedBox(width: fixedSize * 0.05),
                                    GestureDetector(
                                      onTap: () {
                                        context.push('/account');
                                      },
                                      child: Container(
                                        height: fixedSize * 0.025,
                                        width: fixedSize * 0.07,
                                        decoration: BoxDecoration(
                                          gradient: AppColors.main,
                                          borderRadius: BorderRadius.circular(
                                            fixedSize * 0.01,
                                          ),
                                          // boxShadow: [
                                          //   BoxShadow(
                                          //     color: Colors.grey.shade400,
                                          //     offset: const Offset(1, 2),
                                          //     blurRadius: 3,
                                          //   ),
                                          // ],
                                        ),
                                        child: Center(
                                          child: Text(
                                            'ເບິ່ງຂໍ້ມູນ',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: fixedSize * 0.012,
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
                child: InkWell(
                  onTap: () {
                    // Navigate to deposit screen
                    context.push('/deposit');
                  },
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: fixedSize * 0.008,
                          right: fixedSize * 0.008,
                        ),
                        child: Image.asset(
                          AppImage.mF,
                          scale: fixedSize * 0.001,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: fixedSize * 0.001),
                        child: SizedBox(
                          width: fixedSize * 0.16,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'ບັນຊີເງິນຝາກ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: fixedSize * 0.013,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '0201 1234 5678',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: fixedSize * 0.012,
                                ),
                              ),
                              Text(
                                'xaiyadeth poudthavong',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: fixedSize * 0.012,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // SizedBox(
                      //   width: Dimensions.width10,
                      // ),
                      Padding(
                        padding: EdgeInsets.only(right: fixedSize * 0.001),
                        child: Image.asset(
                          AppImage.qr,
                          scale: fixedSize * 0.0008,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: fixedSize * 0.01),
              //   child: const Divider(color: Colors.grey),
              // ),

              // SizedBox(
              //   height: fixedSize * 0.08,
              //   width: double.infinity,
              //   child: InkWell(
              //     onTap: () {
              //       context.push('/loan');
              //     },
              //     child: Row(
              //       // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         Padding(
              //           padding: EdgeInsets.only(
              //             left: fixedSize * 0.008,
              //             right: fixedSize * 0.008,
              //           ),
              //           child: Image.asset(
              //             AppImage.mF,
              //             scale: fixedSize * 0.001,
              //           ),
              //         ),
              //         Padding(
              //           padding: EdgeInsets.only(right: fixedSize * 0.001),
              //           child: SizedBox(
              //             width: fixedSize * 0.16,
              //             child: Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               mainAxisAlignment: MainAxisAlignment.center,
              //               children: [
              //                 Text(
              //                   'ບັນຊີເງິນກູ້',
              //                   style: TextStyle(
              //                     color: Colors.black,
              //                     fontSize: fixedSize * 0.013,
              //                     fontWeight: FontWeight.w500,
              //                   ),
              //                 ),
              //                 Text(
              //                   '0201 1234 5678',
              //                   style: TextStyle(
              //                     color: Colors.grey,
              //                     fontSize: fixedSize * 0.012,
              //                   ),
              //                 ),
              //                 Text(
              //                   'xaiyadeth poudthavong',
              //                   style: TextStyle(
              //                     color: Colors.grey,
              //                     fontSize: fixedSize * 0.012,
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ),
              //         ),
              //         // SizedBox(
              //         //   width: Dimensions.width10,
              //         // ),
              //         Padding(
              //           padding: EdgeInsets.only(right: fixedSize * 0.001),
              //           child: Image.asset(
              //             AppImage.qr,
              //             scale: fixedSize * 0.0008,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
