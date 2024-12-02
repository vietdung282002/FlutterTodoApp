import 'package:flutter/material.dart';
import 'package:flutter_todo_app/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    super.key,
    required this.screenWidth,
    required this.text,
  });

  final double screenWidth;
  final String text;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
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
