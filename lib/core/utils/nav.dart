import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moblie_banking/core/utils/app_colors.dart';
import 'package:moblie_banking/core/utils/app_image.dart';
import 'package:moblie_banking/widgets/nav_item.dart' show NavigatorItem;
import 'package:moblie_banking/provider/nav_provider.dart';
import 'package:moblie_banking/features/notification/logic/notification_provider.dart';

class NavBar extends ConsumerWidget {
  final Widget child;
  const NavBar({super.key, required this.child});

  // static const tabs = ['/home', '/transactions', '/settings', '/account'];
  // int _sectectIndex = 0;

  // List page = [
  //   const HomeScreen(),
  //   const TransactionScreen(),
  //   const HomeScreen(),
  //   const TransactionScreen(),
  // ];
  // void onTapNav(int index) {
  //   setState(() {
  //     _sectectIndex = index;
  //   });
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navIndexProvider);
    final notificationState = ref.watch(notificationNotifierProvider);
    Size size = MediaQuery.of(context).size;
    double fixedSize = size.width + size.height;
    return Scaffold(
      body: child,
      bottomNavigationBar: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height / 13,
          decoration: BoxDecoration(gradient: AppColors.main),
          child: Row(
            children: [
              NavigatorItem(
                index: 0,
                title: 'ບັນຊີ',
                alert: false,
                icons: Icons.credit_card_rounded,
              ),
              NavigatorItem(
                index: 1,
                title: 'ແຈ້ງເຕືອນ',
                alert: true,
                image: AppImage.mnoti,
              ),
              NavigatorItem(
                index: 2,
                title: 'ຕັ້ງຄ່າ',
                alert: false,
                icons: Icons.settings,
              ),
              NavigatorItem(
                index: 3,
                title: 'ບໍລິການ',
                alert: true,
                // icons: Icons.grid_view_outlined,
                image: AppImage.other,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
