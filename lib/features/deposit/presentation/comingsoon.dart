import 'package:flutter/material.dart';
import 'package:moblie_banking/core/utils/app_colors.dart';
import 'package:moblie_banking/core/utils/app_image.dart';

class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.color1,
        leading: IconButton(
          icon: Image.asset(AppImage.back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Text(
          'Coming\nSoon...',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold,
            color: AppColors.color1,
          ),
        ),
      ),
    );
  }
}
