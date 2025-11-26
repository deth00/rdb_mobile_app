import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CardInfo extends StatelessWidget {
  final String title;
  final String text;
  final TextStyle style;
  const CardInfo({
    super.key,
    required this.title,
    required this.text,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      width: double.infinity,
      padding: EdgeInsets.all(10.w),
      decoration: const BoxDecoration(
        // color: Colors.red,
        border: Border(bottom: BorderSide(color: Colors.grey)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
          ),
          Text(text, style: style),
        ],
      ),
    );
  }
}
