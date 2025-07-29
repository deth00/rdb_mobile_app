import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moblie_banking/core/utils/app_colors.dart';

class FieldInput extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? icon1;
  final bool? obs;
  final TextInputType type;
  final TextEditingController controller;
  final int? mexlent;

  const FieldInput({
    super.key,
    this.obs,
    required this.title,
    required this.icon,
    this.icon1,
    required this.type,
    required this.controller,
    this.mexlent,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: TextField(
        obscureText: obs ?? false,
        controller: controller,
        keyboardType: type,
        maxLength: mexlent ?? 20,
        decoration: InputDecoration(
          labelText: title,
          prefixIcon: Icon(icon),
          suffixIcon: icon1,
          counterText: '',
          contentPadding: EdgeInsets.symmetric(
            vertical: 14.h,
            horizontal: 20.w,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: AppColors.color1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: AppColors.color1, width: 2),
          ),
        ),
      ),
    );
  }
}
