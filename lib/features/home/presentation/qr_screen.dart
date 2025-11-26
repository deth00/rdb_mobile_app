import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:moblie_banking/features/auth/logic/auth_provider.dart';
import 'package:moblie_banking/features/home/logic/home_provider.dart';
import 'package:moblie_banking/features/home/logic/qr_provider.dart';
import 'package:moblie_banking/features/home/logic/qr_state.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrScreen extends ConsumerStatefulWidget {
  const QrScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _QrScreenState();
}

class _QrScreenState extends ConsumerState<QrScreen> {
  @override
  void initState() {
    super.initState();
    // Generate QR when screen loads
    Future.microtask(() async {
      final homeState = ref.read(homeNotifierProvider);
      if (homeState.accountDpt.isNotEmpty) {
        final acno = homeState.accountDpt.first.linkValue;
        ref.read(qrNotifierProvider.notifier).generateQR(acno);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeNotifierProvider);
    final authstate = ref.watch(authNotifierProvider);
    final qrState = ref.watch(qrNotifierProvider);

    final user = authstate.user;
    final now = DateTime.now();
    final formatted = DateFormat('dd/MM/yyyy HH:mm').format(now);

    // Get account number from home state
    final acno = homeState.accountDpt.isNotEmpty
        ? homeState.accountDpt.first.linkValue
        : '';

    return Scaffold(
      backgroundColor: Color(0xFFE6F6F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: SizedBox(),
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: Colors.teal),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: homeState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : homeState.errorMessage != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 48.sp),
                  SizedBox(height: 20.h),
                  Text(
                    homeState.errorMessage!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red, fontSize: 16.sp),
                  ),
                  SizedBox(height: 20.h),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(homeNotifierProvider.notifier).clearError();
                      ref.read(homeNotifierProvider.notifier).getAccountDPT();
                    },
                    child: Text('ລອງໃໝ່', style: TextStyle(fontSize: 16.sp)),
                  ),
                ],
              ),
            )
          : acno.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.account_balance, color: Colors.grey, size: 48.sp),
                  SizedBox(height: 20.h),
                  Text(
                    'ບໍ່ມີບັນຊີເງິນຝາກ',
                    style: TextStyle(color: Colors.grey, fontSize: 16.sp),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 40.h,
                    ),
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8.r,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // โลโก้และชื่อธนาคาร
                        Row(
                          children: [
                            Image.asset(
                              'assets/icons/logordb.png',
                              width: 70.w,
                              height: 70.h,
                            ),
                            SizedBox(width: 10.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "ທະນາຄານ ພັດທະນາ ຊົນນະບົດ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.sp,
                                  ),
                                ),
                                Text(
                                  "Roral Development Bank",
                                  style: TextStyle(fontSize: 18.sp),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        // โลโก้กลาง
                        Image.asset(
                          'assets/icons/lordb.png',
                          width: 100.w,
                          height: 100.h,
                        ),
                        // SizedBox(height: 10.h),
                        // ชื่อบัญชีและเลขบัญชี
                        Text(
                          user == null
                              ? ''
                              : '${user.firstName} ${user.lastName}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
                          ),
                        ),
                        Text(
                          _maskAccount(acno),
                          style: TextStyle(color: Colors.teal, fontSize: 16.sp),
                        ),
                        SizedBox(height: 10.h),

                        // QR Code
                        qrState.isLoading
                            ? Center(
                                child: Column(
                                  children: [
                                    CircularProgressIndicator(),
                                    SizedBox(height: 20.h),
                                    Text(
                                      'ກຳລັງສ້າງ QR Code...',
                                      style: TextStyle(fontSize: 16.sp),
                                    ),
                                  ],
                                ),
                              )
                            : qrState.errorMessage != null
                            ? Center(
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      color: Colors.red,
                                      size: 48.sp,
                                    ),
                                    SizedBox(height: 20.h),
                                    Text(
                                      qrState.errorMessage!,
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
                                            .read(qrNotifierProvider.notifier)
                                            .clearError();
                                        ref
                                            .read(qrNotifierProvider.notifier)
                                            .generateQR(acno);
                                      },
                                      child: Text(
                                        'ລອງໃໝ່',
                                        style: TextStyle(fontSize: 16.sp),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : qrState.qrResponse != null
                            ? Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.teal,
                                        width: 2.w,
                                      ),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: QrImageView(
                                      data: qrState.qrResponse!.qr,
                                      version: QrVersions.auto,
                                      size: 200.w,
                                      gapless: false,
                                      backgroundColor: Colors.white,
                                    ),
                                  ),
                                  Positioned(
                                    child: Container(
                                      color: Colors.white,
                                      child: Image.asset(
                                        'assets/icons/lordb.png',
                                        width: 20.w,
                                        height: 20.h,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Center(
                                child: Text(
                                  'ບໍ່ມີຂໍ້ມູນ QR Code',
                                  style: TextStyle(fontSize: 16.sp),
                                ),
                              ),

                        SizedBox(height: 16.h),
                        Text(
                          "ໃຊ້ສຳລັບໂອນເງິນພາຍໃນຜ່ານ QR Code",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        SizedBox(height: 20.h),
                        // ปุ่ม 3 ปุ่ม
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _QrActionButton(
                              icon: Icons.send,
                              label: "ສົ່ງ QR",
                              onTap: () {},
                            ),
                            _QrActionButton(
                              icon: Icons.save_alt,
                              label: "ບັນທຶກ",
                              onTap: () {},
                            ),
                            _QrActionButton(
                              icon: Icons.share,
                              label: "ແບ່ງປັນ",
                              onTap: () {},
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        // วันที่/เวลา
                        Text(
                          "ວັນທີອັບເດດ: $formatted",
                          style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  String _maskAccount(String acNo) {
    if (acNo.length < 10) return 'xxxx';
    return '${acNo.substring(0, 3)} xxxx xxxx ${acNo.substring(acNo.length - 3)}';
  }
}

class _QrActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QrActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Ink(
          decoration: ShapeDecoration(
            color: Color(0xFFE6F6F2),
            shape: CircleBorder(),
          ),
          child: IconButton(
            icon: Icon(icon, color: Colors.teal, size: 24.sp),
            onPressed: onTap,
          ),
        ),
        SizedBox(height: 8.h),
        Text(label, style: TextStyle(fontSize: 12.sp)),
      ],
    );
  }
}
