// This page is to define a custom button widget
//that can be reused throughout the application.
// By defining a custom Button widget, developer can create consistent and
// reusable buttons with specific styles, functionality, and behavior.

import 'package:flutter/material.dart';

import '../utils/config.dart';

class Button extends StatelessWidget {
  const Button({
    Key? key,
    required this.width,
    required this.title,
    required this.onPressed,
    this.disabled = false,
  }) : super(key: key);

  final double width;
  final String title;
  final Function()? onPressed;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Config.primaryColor,
          foregroundColor: Colors.white,
        ),
        onPressed: disabled ? null : onPressed,
        child: Text(title),
      ),
    );
  }
}
