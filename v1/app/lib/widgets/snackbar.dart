import 'package:flutter/material.dart';

launchSnackbar(
    {required BuildContext context,
    required String mode,
    required String message}) {
  Color? color;
  IconData? icon;

  if (mode == "SUCCESS") {
    color = Colors.green;
    icon = Icons.check_box_outlined;
  }
  if (mode == "ERROR") {
    color = Colors.red;
    icon = Icons.warning_amber_rounded;
  }

  final snackBar = SnackBar(
    duration: Duration(milliseconds: 3000),
    content: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.white),
        SizedBox(width: 10),
        Text(message,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
      ],
    ),
    backgroundColor: color,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
