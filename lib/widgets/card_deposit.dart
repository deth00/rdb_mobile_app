import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class cardDeposit extends StatelessWidget {
  final String text;
  final String image;
  final String routeName;
  final Map<String, String>? pathParameters;

  const cardDeposit({
    super.key,
    required this.text,
    required this.image,
    required this.routeName,
    this.pathParameters,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
      child: GestureDetector(
        onTap: () {
          if (pathParameters != null) {
            context.pushNamed(routeName, pathParameters: pathParameters!);
          } else {
            context.pushNamed(routeName);
          }
        },
        child: SizedBox(
          // color: Colors.amberAccent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SvgPicture.asset(image, width: 80.w),
              Text(
                text,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.black,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
