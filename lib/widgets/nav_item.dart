import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:moblie_banking/core/utils/app_colors.dart';
import 'package:moblie_banking/provider/nav_provider.dart';
import 'package:moblie_banking/features/notification/logic/notification_provider.dart';

class NavigatorItem extends ConsumerWidget {
  final int index;
  final String title;
  final bool alert;
  final IconData? icons;
  final String? image;

  NavigatorItem({
    super.key,
    required this.index,
    required this.title,
    required this.alert,
    this.icons,
    this.image,
  });

  final tabs = ['/home', '/notifications', '/settings', '/services'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.of(context).size;
    double fixedSize = size.width + size.height;
    final current = ref.watch(navIndexProvider);
    final _sectectIndex = current == index;
    final notificationState = ref.watch(notificationNotifierProvider);
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
                  ? Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: fixedSize * 0.0025,
                      ),
                      child: SizedBox(
                        width: fixedSize * 0.025,
                        height: fixedSize * 0.025,
                        child: SvgPicture.asset(
                          image!,
                          height: fixedSize * 0.03,
                          width: fixedSize * 0.03,
                          color: _sectectIndex
                              ? AppColors.color2
                              : Colors.white,
                        ),
                      ),
                    )
                  : Stack(
                      children: [
                        Icon(
                          icons,
                          size: fixedSize * 0.03,
                          color: _sectectIndex
                              ? AppColors.color2
                              : Colors.white,
                        ),
                        if (index == 1 && notificationState.unreadCount > 0)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              constraints: BoxConstraints(
                                minWidth: 16,
                                minHeight: 16,
                              ),
                              child: Text(
                                notificationState.unreadCount > 99
                                    ? '99+'
                                    : notificationState.unreadCount.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
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
