import 'package:flutter/material.dart';
import 'package:moblie_banking/core/utils/app_colors.dart';
import 'package:moblie_banking/core/utils/app_image.dart';

class Header extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onTaps;
  final VoidCallback? onTap1;
  const Header({
    super.key,
    required this.text,
    this.icon,
    this.onTaps,
    this.onTap1,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double fixedSize = size.width + size.height;
    return Container(
      height: fixedSize * 0.045,
      width: double.infinity,
      color: AppColors.color1,
      child: icon != null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                onTap1 == null
                    ? SizedBox(width: fixedSize * 0.02)
                    : IconButton(
                        onPressed: onTap1,
                        icon: Image.asset(AppImage.back, color: Colors.white),
                      ),
                Padding(
                  padding: EdgeInsets.only(left: fixedSize * 0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: fixedSize * 0.01,
                          right: fixedSize * 0.01,
                        ),
                        child: Icon(
                          icon,
                          color: Colors.white,
                          size: fixedSize * 0.03,
                        ),
                      ),
                      Text(
                        text,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: fixedSize * 0.016,
                        ),
                      ),
                    ],
                  ),
                ),

                onTaps == null
                    ? SizedBox(width: fixedSize * 0.05)
                    : Padding(
                        padding: EdgeInsets.only(
                          top: fixedSize * 0.008,
                          right: fixedSize * 0.001,
                          left: fixedSize * 0.0,
                        ),
                        child: GestureDetector(
                          onTap: () async {},
                          child: Column(
                            children: [
                              Image.asset(AppImage.logout, scale: 1.2),
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
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                onTap1 == null
                    ? const SizedBox()
                    : IconButton(
                        onPressed: onTap1,
                        icon: Image.asset(AppImage.back, color: Colors.white),
                      ),

                Text(
                  text,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: fixedSize * 0.01,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTaps == null
                    ? SizedBox(width: fixedSize * 0.01)
                    : GestureDetector(
                        onTap: () async {},
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: fixedSize * 0.01,
                            right: fixedSize * 0.01,
                          ),
                          child: Column(
                            children: [
                              Image.asset(AppImage.logout, scale: 1.2),
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
              ],
            ),
    );
  }
}
