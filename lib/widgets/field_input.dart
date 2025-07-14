import 'package:flutter/material.dart';
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
    Size size = MediaQuery.of(context).size;
    double fixedSize = size.width + size.height;
    return Padding(
      padding: EdgeInsets.only(top: fixedSize * 0.01),
      child: TextField(
        obscureText: obs!,
        controller: controller,
        keyboardType: type,
        maxLength: mexlent ?? 20,
        decoration: InputDecoration(
          labelText: title,
          prefixIcon: Icon(icon),
          suffixIcon: icon1,
          counterText: '',
          contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(fixedSize * 0.01), // วงมน
            borderSide: BorderSide(color: AppColors.color1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(fixedSize * 0.01),
            borderSide: BorderSide(color: AppColors.color1, width: 2),
          ),
        ),
      ),
    );
  }
}
