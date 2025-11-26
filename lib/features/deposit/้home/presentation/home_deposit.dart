import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:moblie_banking/core/utils/app_colors.dart';
import 'package:moblie_banking/core/utils/app_image.dart';
import 'package:moblie_banking/widgets/appbar.dart';
import 'package:moblie_banking/widgets/card_deposit.dart';
import 'package:moblie_banking/features/deposit/้home/logic/dpt_provider.dart';
import 'package:moblie_banking/features/deposit/account/logic/select_primary_account_state.dart';
import 'package:moblie_banking/core/utils/route_constants.dart';
import 'package:go_router/go_router.dart';

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
  void _navigateToTransactions() async {
    try {
      // First navigate to select primary account screen
      final result = await context.pushNamed(
        RouteConstants.selectPrimaryAccount,
      );

      // If an account was selected, navigate to transactions screen
      if (result != null && result is DepositAccount) {
        final selectedAccount = result;
        if (mounted) {
          context.pushNamed(
            RouteConstants.transactions,
            pathParameters: {'acno': selectedAccount.accountNumber},
          );
        }
      }
    } catch (e) {
      // Handle any navigation errors
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('ເກີດຂໍ້ຜິດພາດໃນການນຳທາງ'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dptNotifierProvider);
    final detail = state.accountDetail;

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
                    height: 120.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.color2.withOpacity(0.1),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(5.w),
                      child: Row(
                        children: [
                          Image.asset(AppImage.mF, width: 100.w),
                          SizedBox(width: 15.w),
                          if (detail == null)
                            Text(
                              'ບໍ່ມີຂໍ້ມູນ',
                              style: TextStyle(fontSize: 16.sp),
                            )
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
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    isVisible
                                        ? SizedBox(width: 15.w)
                                        : SizedBox(width: 55.w),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isVisible = !isVisible;
                                        });
                                      },
                                      child: Container(
                                        height: 35.h,
                                        width: 70.w,
                                        decoration: BoxDecoration(
                                          color: AppColors.color1,
                                          borderRadius: BorderRadius.circular(
                                            10.r,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.shade400,
                                              offset: const Offset(1, 2),
                                              blurRadius: 3.r,
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Text(
                                            isVisible ? 'ປິດ' : 'ສະແດງ',
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
                                // 💰 ຍອດເງິນ
                                Row(
                                  children: [
                                    SizedBox(width: 5.w),
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
                                        fontSize: 20.sp,
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
                  SizedBox(height: 20.h),
                  // ✅ ເມນູ Grid
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 3,
                      crossAxisSpacing: 15.w,
                      mainAxisSpacing: 15.h,
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      children: [
                        _buildTransactionCard(),
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
                          routeName: 'financial',
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

  Widget _buildTransactionCard() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
      child: GestureDetector(
        onTap: _navigateToTransactions,
        child: SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SvgPicture.asset(AppImage.trn, width: 80.w),
              Text(
                'ການເຄື່ອນໄຫວ',
                style: TextStyle(fontSize: 16.sp, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
