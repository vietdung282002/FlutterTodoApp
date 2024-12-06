import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextWidget extends StatelessWidget {
  const TextWidget({
    super.key,
    required this.text,
    this.fontSize = 16,
    this.textColor = Colors.black,
    this.fontWeight = FontWeight.w500,
    this.opacity = 1,
    this.textDecoration = TextDecoration.none,
  });

  final String text;
  final double fontSize;
  final Color textColor;
  final FontWeight fontWeight;
  final double opacity;
  final TextDecoration textDecoration;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.inter(
          textStyle: TextStyle(
        color: textColor.withOpacity(opacity),
        fontSize: fontSize,
        fontWeight: fontWeight,
        decoration: textDecoration,
      )),
      softWrap: true,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
