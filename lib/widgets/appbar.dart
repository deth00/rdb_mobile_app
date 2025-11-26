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
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20.sp,
            ),
          ),
        ],
      ),
      actions: isLogout == true
          ? [
              Padding(
                padding: EdgeInsets.only(top: 10.h, right: 15.w),
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
                          fontSize: 12.sp,
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
