import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class cardDeposit extends StatelessWidget {
  const cardDeposit({
    super.key,
    required this.text,
    required this.image,
    required this.routeName,
  });

  final String text;
  final String image;
  final String routeName;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double fixedSize = size.width + size.height;
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: fixedSize * 0.002,
        horizontal: fixedSize * 0.002,
      ),
      child: GestureDetector(
        onTap: () {
          context.push(routeName);
        },
        child: SizedBox(
          // color: Colors.amberAccent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset(image, scale: 1.2),
              Text(
                text,
                style: TextStyle(
                  fontSize: fixedSize * 0.012,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
