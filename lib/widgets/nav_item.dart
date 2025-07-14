import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moblie_banking/core/utils/app_colors.dart';
import 'package:moblie_banking/provider/nav_provider.dart';

class NavigatorItem extends ConsumerWidget {
  final int index;
  final String title;
  final bool alert;
  final IconData icons;
  final Widget? widget;

  NavigatorItem({
    super.key,
    required this.index,
    required this.title,
    required this.alert,
    required this.icons,
    this.widget,
  });

  final tabs = ['/home', '/transactions', '/settings', '/services'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.of(context).size;
    double fixedSize = size.width + size.height;
    final current = ref.watch(navIndexProvider);
    final _sectectIndex = current == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          ref.read(navIndexProvider.notifier).state = index;
          context.go(tabs[index]); // ⬅️ เปลี่ยนหน้า
        },
        child: Container(
          height: fixedSize * 0.055,
          width: MediaQuery.of(context).size.width / 4,
          decoration: _sectectIndex
              ? const BoxDecoration(color: Colors.white)
              : const BoxDecoration(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              alert
                  ? SizedBox(child: widget)
                  : Icon(
                      icons,
                      size: fixedSize * 0.03,
                      color: _sectectIndex ? AppColors.color2 : Colors.white,
                    ),
              Text(
                title,
                style: TextStyle(
                  color: _sectectIndex ? AppColors.color2 : Colors.white,
                  fontSize: fixedSize * 0.01,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
