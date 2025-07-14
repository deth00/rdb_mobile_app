import 'package:flutter/material.dart';

void showCustomSnackBar(
  BuildContext context,
  String message, {
  bool isError = false,
}) {
  final snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade600,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    content: Row(
      children: [
        Icon(
          isError ? Icons.error_outline : Icons.check_circle_outline,
          color: Colors.white,
        ),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            message,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
    duration: Duration(seconds: 3),
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}
