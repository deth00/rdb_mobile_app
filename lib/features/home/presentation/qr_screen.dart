import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:moblie_banking/features/auth/logic/auth_provider.dart';
import 'package:moblie_banking/provider/acno_provider.dart';
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
      final acnoAsync = await ref.read(acnoFutureProvider.future);
      ref.read(qrNotifierProvider.notifier).generateQR(acnoAsync);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double fixedSize = size.width + size.height;
    final acnoAsync = ref.watch(acnoFutureProvider);
    final authstate = ref.watch(authNotifierProvider);
    final qrState = ref.watch(qrNotifierProvider);

    final user = authstate.user;
    final now = DateTime.now();
    final formatted = DateFormat('dd/MM/yyyy HH:mm').format(now);
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
      body: acnoAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (acno) => SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: fixedSize * 0.02,
              vertical: fixedSize * 0.04,
            ),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
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
                    SvgPicture.asset(
                      'assets/icons/logo.svg',
                      width: fixedSize * 0.055,
                      height: fixedSize * 0.055,
                    ),
                    SizedBox(width: fixedSize * 0.005),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "ທະນາຄານ ພັດທະນາ ຊົນນະບົດ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: fixedSize * 0.015,
                          ),
                        ),
                        Text(
                          "Roral Development Bank",
                          style: TextStyle(fontSize: fixedSize * 0.013),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: fixedSize * 0.01),
                // โลโก้กลาง
                SvgPicture.asset(
                  'assets/icons/logo.svg',
                  width: fixedSize * 0.06,
                  height: fixedSize * 0.06,
                ),
                SizedBox(height: fixedSize * 0.007),
                // ชื่อบัญชีและเลขบัญชี
                Text(
                  user == null ? '' : '${user.firstName} ${user.lastName}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(_maskAccount(acno), style: TextStyle(color: Colors.teal)),
                SizedBox(height: fixedSize * 0.012),

                // QR Code
                qrState.isLoading
                    ? Center(
                        child: Column(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: fixedSize * 0.01),
                            Text('ກຳລັງສ້າງ QR Code...'),
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
                              size: 48,
                            ),
                            SizedBox(height: fixedSize * 0.01),
                            Text(
                              qrState.errorMessage!,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.red),
                            ),
                            SizedBox(height: fixedSize * 0.01),
                            ElevatedButton(
                              onPressed: () {
                                ref
                                    .read(qrNotifierProvider.notifier)
                                    .clearError();
                                acnoAsync.whenData((acno) {
                                  ref
                                      .read(qrNotifierProvider.notifier)
                                      .generateQR(acno);
                                });
                              },
                              child: Text('ລອງໃໝ່'),
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
                              border: Border.all(color: Colors.teal, width: 2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: QrImageView(
                              data: qrState.qrResponse!.qr,
                              version: QrVersions.auto,
                              size: 200,
                              gapless: false,
                              backgroundColor: Colors.white,
                            ),
                          ),
                          Positioned(
                            child: Container(
                              color: Colors.white,
                              child: SvgPicture.asset(
                                'assets/icons/logo.svg',
                                width: fixedSize * 0.03,
                                height: fixedSize * 0.03,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Center(child: Text('ບໍ່ມີຂໍ້ມູນ QR Code')),

                SizedBox(height: 8),
                Text(
                  "ໃຊ້ສຳລັບໂອນເງິນພາຍໃນຜ່ານ QR Code",
                  style: TextStyle(fontSize: 13),
                ),
                SizedBox(height: 16),
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
                SizedBox(height: 16),
                // วันที่/เวลา
                Text(
                  "ວັນທີອັບເດດ: $formatted",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
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
            icon: Icon(icon, color: Colors.teal),
            onPressed: onTap,
          ),
        ),
        SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}
