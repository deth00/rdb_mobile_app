import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:moblie_banking/core/utils/app_colors.dart';
import 'package:moblie_banking/core/utils/app_image.dart';
import 'package:moblie_banking/core/utils/svg_icons.dart';
import 'package:moblie_banking/widgets/appbar.dart';
import 'package:moblie_banking/widgets/card_deposit.dart';
import 'package:moblie_banking/features/deposit/้home/logic/dpt_provider.dart';

class HomeDeposit extends ConsumerStatefulWidget {
  final String acno;
  const HomeDeposit({super.key, required this.acno});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeDepositState();
}

class _HomeDepositState extends ConsumerState<HomeDeposit> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(dptNotifierProvider.notifier).getAccountDetail(widget.acno);
    });
  }

  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dptNotifierProvider);
    final detail = state.accountDetail;
    final fixedSize =
        MediaQuery.of(context).size.height + MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GradientAppBar(title: 'ບັນຊີເງິນຝາກ', isLogout: true),
      body: SafeArea(
        child: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : state.errorMessage != null
            ? Center(child: Text(state.errorMessage!))
            : Column(
                children: [
                  // ✅ Card ບັນຊີ
                  Container(
                    height: fixedSize * 0.075,
                    width: double.infinity,
                    decoration: BoxDecoration(color: AppColors.bgColor2),
                    child: Padding(
                      padding: EdgeInsets.all(fixedSize * 0.005),
                      child: Row(
                        children: [
                          Image.asset(AppImage.mF, width: 70.w),
                          SizedBox(width: fixedSize * 0.01),
                          if (detail == null)
                            const Text('ບໍ່ມີຂໍ້ມູນ')
                          else
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 🔒 ເລກບັນຊີ
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      isVisible
                                          ? detail.acNo
                                          : _maskAccount(detail.acNo),
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.8),
                                        fontSize: fixedSize * 0.014,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    isVisible
                                        ? SizedBox(width: fixedSize * 0.03)
                                        : SizedBox(width: fixedSize * 0.06),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isVisible = !isVisible;
                                        });
                                      },
                                      child: Container(
                                        height: fixedSize * 0.02,
                                        width: fixedSize * 0.05,
                                        decoration: BoxDecoration(
                                          color: AppColors.color1,
                                          borderRadius: BorderRadius.circular(
                                            fixedSize * 0.007,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.shade400,
                                              offset: const Offset(1, 2),
                                              blurRadius: 3,
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Text(
                                            isVisible ? 'ປິດ' : 'ສະແດງ',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: fixedSize * 0.013,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // 💰 ຍອດເງິນ
                                Row(
                                  children: [
                                    // Image.asset(
                                    //   AppImage.kip,
                                    //   scale: fixedSize * 0.03,
                                    //   color: AppColors.color1,
                                    // ),
                                    SizedBox(width: fixedSize * 0.005),
                                    Text(
                                      isVisible
                                          ? (detail.balance > 0
                                                ? NumberFormat.currency(
                                                    locale: 'en_US',
                                                    symbol: 'ກີບ',
                                                    decimalDigits: 2,
                                                    customPattern: '#,##0.00 ¤',
                                                  ).format(detail.balance)
                                                : 'ບໍ່ມີຂໍ້ມູນ')
                                          : 'xxxxx',
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.8),
                                        fontSize: fixedSize * 0.015,
                                        fontWeight: FontWeight.bold,
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
                  SizedBox(height: fixedSize * 0.01),
                  // ✅ ເມນູ Grid
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 3,
                      crossAxisSpacing: fixedSize * 0.01,
                      children: [
                        cardDeposit(
                          text: 'ການເຄື່ອນໄຫວ',
                          image: AppImage.trn,
                          routeName: 'transactions',
                        ),
                        cardDeposit(
                          text: 'ບັນຊີ',
                          image: AppImage.bunc,
                          routeName: 'fundAccountDetail',
                          pathParameters: {'acno': widget.acno},
                        ),
                        cardDeposit(
                          text: 'ໂອນເງິນ',
                          image: AppImage.aon,
                          routeName: 'transfer',
                        ),
                        cardDeposit(
                          text: 'ສິນເຊື່ອ',
                          image: AppImage.sin,
                          routeName: 'commingsoon',
                        ),
                        cardDeposit(
                          text: 'ເຕີມເງິນໂທລະສັບ',
                          image: AppImage.tho,
                          routeName: 'commingsoon',
                        ),
                        cardDeposit(
                          text: 'ຈ່າຍຄ່າໄຟຟ້າ',
                          image: AppImage.fai,
                          routeName: 'commingsoon',
                        ),
                        cardDeposit(
                          text: 'ຈ່າຍຄ່ານໍ້າປະປາ',
                          image: AppImage.nam,
                          routeName: 'commingsoon',
                        ),
                        cardDeposit(
                          text: 'ປະກັນໄພ',
                          image: AppImage.pakun,
                          routeName: 'commingsoon',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  /// ບໍ່ໃຫ້ເຫັນໂຕເລກບາງສ່ວນ
  String _maskAccount(String acNo) {
    if (acNo.length < 10) return 'xxxx';
    return '${acNo.substring(0, 3)} xxxx xxxx ${acNo.substring(acNo.length - 3)}';
  }
}
