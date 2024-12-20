import 'package:flutter/material.dart';
import 'package:flutter_todo_app/config/colors.dart';

class ButtonWidget extends StatelessWidget {
  final double width;
  final String text;
  final TextStyle? textStyle;
  final VoidCallback onTap;

  const ButtonWidget({
    super.key,
    required this.width,
    required this.text,
    required this.onTap,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: ButtonStyle(
        minimumSize: WidgetStateProperty.all<Size>(Size(width, 50)),
        padding: WidgetStateProperty.all<EdgeInsets>(const EdgeInsets.all(15)),
        backgroundColor: WidgetStateProperty.all<Color>(backgroundColor),
        foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
        ),
      ),
      child: Text(text, style: textStyle),
    );
  }
}
