import 'package:flutter/material.dart';

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
    Size size = MediaQuery.of(context).size;
    double fixedSize = size.width + size.height;
    return Container(
      height: fixedSize * 0.032,
      width: double.infinity,
      padding: EdgeInsets.all(fixedSize * 0.008),
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
              fontSize: fixedSize * 0.012,
            ),
          ),
          Text(text, style: style),
        ],
      ),
    );
  }
}
