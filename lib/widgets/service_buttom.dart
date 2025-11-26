import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moblie_banking/core/utils/app_colors.dart';

class ServiceButtom extends StatelessWidget {
  final String title;
  final String text;
  final String image;
  final VoidCallback? onpress;
  final Widget? widget;
  const ServiceButtom({
    super.key,
    required this.title,
    required this.text,
    required this.image,
    this.widget,
    this.onpress,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: GestureDetector(
        onTap: onpress,
        child: Container(
          height: 100.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.r),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5.r,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 15.w),
                      child: SvgPicture.asset(
                        image,
                        width: 50.w,
                        height: 50.h,
                        colorFilter: ColorFilter.mode(
                          AppColors.color1,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            text,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.black54,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            softWrap: false,
                          ),
                        ],
                      ),
                    ),
                    widget == null
                        ? Icon(Icons.arrow_forward_ios, color: AppColors.color1)
                        : SizedBox(child: widget),
                  ],
                ),
                // Padding(
                //   padding: EdgeInsets.only(left: fixedSize * 0.002),
                //   child: const Divider(color: Colors.grey),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
