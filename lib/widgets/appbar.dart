import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:moblie_banking/core/utils/app_colors.dart';
import 'package:moblie_banking/core/utils/app_image.dart';

class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final IconData? icon;
  final String title;
  final bool? isLogout;

  final bool centerTitle;
  final List<Widget>? actions;
  final VoidCallback? onIconPressed;

  const GradientAppBar({
    super.key,
    this.icon,
    required this.title,
    this.isLogout = false,
    this.centerTitle = true,
    this.actions,
    this.onIconPressed,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double fixedSize = size.width + size.height;
    return AppBar(
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: centerTitle,
      leading: onIconPressed == null
          ? null
          : IconButton(
              onPressed: onIconPressed,
              icon: Icon(icon, color: Colors.white),
            ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // IconButton(
          //   icon: Icon(icon, color: Colors.white),
          //   onPressed: onIconPressed ?? () {},
          // ),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: isLogout == true
          ? [
              Padding(
                padding: EdgeInsets.only(
                  top: fixedSize * 0.0075,
                  right: fixedSize * 0.01,
                ),
                child: GestureDetector(
                  onTap: () {
                    context.goNamed('login');
                  },
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        AppImage.logouts,
                        height: 20.h,
                        width: 20.w,
                      ),
                      Text(
                        'ອອກລະບົບ',
                        style: TextStyle(
                          fontSize: fixedSize * 0.01,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]
          : actions,
      flexibleSpace: Container(
        decoration: BoxDecoration(gradient: AppColors.main),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
