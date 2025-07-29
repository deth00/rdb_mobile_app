import 'package:flutter/material.dart';
import 'package:moblie_banking/core/utils/app_colors.dart';
import 'package:moblie_banking/core/utils/app_image.dart';
import 'package:moblie_banking/widgets/appbar.dart';
import 'package:moblie_banking/widgets/card_deposit.dart';

class HomeLoan extends StatefulWidget {
  const HomeLoan({super.key});

  @override
  State<HomeLoan> createState() => _HomeLoanState();
}

class _HomeLoanState extends State<HomeLoan> {
  @override
  bool isvisible = false;
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double fixedSize = size.width + size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GradientAppBar(title: 'ກວດສອບການຊຳລະ'),
      body: SafeArea(
        child: Column(
          children: [
            // Header(
            //   onTaps: () {},
            //   text: 'ບັນຊີເງິນຝາກ',
            //   icon: Icons.account_balance_wallet_outlined,
            //   onTap1: () {
            //     context.pop();
            //   },
            // ),
            Container(
              height: fixedSize * 0.075,
              width: double.infinity,
              decoration: BoxDecoration(color: AppColors.bgColor2),
              child: Padding(
                padding: EdgeInsets.all(fixedSize * 0.005),
                child: Row(
                  children: [
                    Image.asset(AppImage.mF, scale: fixedSize * 0.0011),
                    SizedBox(width: fixedSize * 0.01),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              isvisible
                                  ? '231 4567 1212 123'
                                  : '231 xxxx xxxx 123',
                              style: TextStyle(
                                // ignore: deprecated_member_use
                                color: Colors.black.withOpacity(0.8),
                                fontSize: fixedSize * 0.014,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            isvisible
                                ? SizedBox(width: fixedSize * 0.05)
                                : SizedBox(width: fixedSize * 0.057),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isvisible = !isvisible;
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
                                    'ສະເເດງ',
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
                        Row(
                          children: [
                            // Image.asset(
                            //   AppImage.kip,
                            //   scale: fixedSize * 0.03,
                            //   color: AppColors.color1,
                            // ),
                            SizedBox(width: fixedSize * 0.005),
                            Text(
                              '123133213',
                              style: TextStyle(
                                // ignore: deprecated_member_use
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
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: fixedSize * 0.01,
                children: [
                  cardDeposit(
                    text: 'ການເຄື່ອນໄຫວ',
                    image: AppImage.trn,
                    routeName: '/transactions',
                  ),
                  cardDeposit(
                    text: 'ກວດສອບການຊຳລະ',
                    image: AppImage.kuad,
                    routeName: '/check',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
