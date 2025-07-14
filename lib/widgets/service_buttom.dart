import 'package:flutter/material.dart';
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
    Size size = MediaQuery.of(context).size;
    double fixedSize = size.width + size.height;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: fixedSize * 0.002),
      child: GestureDetector(
        onTap: onpress,
        child: Container(
          height: fixedSize * 0.07,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(fixedSize * 0.01),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.only(
              top: fixedSize * 0.002,
              left: fixedSize * 0.005,
              right: fixedSize * 0.005,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: fixedSize * 0.01),
                      child: Image.asset(image, scale: fixedSize * 0.001),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: fixedSize * 0.014,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            text,
                            style: TextStyle(
                              fontSize: fixedSize * 0.010,
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
