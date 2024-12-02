import 'package:flutter/material.dart';
import 'package:flutter_todo_app/view/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    super.key,
    required this.screenWidth,
    required this.text,
    required this.onTap,
  });

  final double screenWidth;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: ButtonStyle(
          minimumSize: WidgetStateProperty.all<Size>(Size(screenWidth, 50)),
          padding:
              WidgetStateProperty.all<EdgeInsets>(const EdgeInsets.all(15)),
          backgroundColor: WidgetStateProperty.all<Color>(backgroundColor),
          foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ))),
      child: Text(
        text,
        style: GoogleFonts.inter(
            textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white)),
      ),
    );
  }
}
