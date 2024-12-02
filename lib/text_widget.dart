import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextWidget extends StatelessWidget {
  const TextWidget({
    super.key,
    required this.text,
    this.fontSize = 16,
    this.textColor = Colors.black,
    this.fontWeight = FontWeight.w500,
    this.isComplete = false,
  });

  final String text;
  final double fontSize;
  final Color textColor;
  final FontWeight fontWeight;
  final bool isComplete;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.inter(
          textStyle: TextStyle(
        color: isComplete ? textColor.withOpacity(0.5) : textColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
        decoration:
            isComplete ? TextDecoration.lineThrough : TextDecoration.none,
      )),
      softWrap: true,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
