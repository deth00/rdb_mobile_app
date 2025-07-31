import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moblie_banking/core/utils/app_image.dart';
import 'package:moblie_banking/widgets/appbar.dart';
import 'package:moblie_banking/widgets/card_deposit.dart';

// Replace with your actual SVG/image imports
// import 'package:flutter_svg/flutter_svg.dart';

class FinancialPage extends StatelessWidget {
  const FinancialPage({super.key});

  @override
  Widget build(BuildContext context) {
    final fixedSize =
        MediaQuery.of(context).size.height + MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: GradientAppBar(title: 'ສິນເຊື່ອ'),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 8.w),
          child: Column(
            children: [
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: fixedSize * 0.01,
                  children: [
                    cardDeposit(
                      text: 'ສິນເຊື່ອນະໂຍບາຍ',
                      image: AppImage.sinnayo,
                      routeName: 'commingsoon',
                    ),
                    cardDeposit(
                      text: 'ສິນເຊື່ອທຸລະກິດ',
                      image: AppImage.sinbusi,
                      routeName: 'commingsoon',
                    ),
                    cardDeposit(
                      text: 'ຊຳລະຄ່າສິນເຊື່ອ',
                      image: AppImage.sinsamla,
                      routeName: 'commingsoon',
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
}
