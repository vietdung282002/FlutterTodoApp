import 'package:flutter/material.dart';
import 'package:flutter_todo_app/view/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    super.key,
    this.placeholder = "",
    this.placeholderSize = 16,
    this.placeholderWeight = FontWeight.w400,
    this.enableBorderColor = Colors.grey,
    this.enableBorderWidth = 2,
    this.enableBorderRadius = 6,
    this.focusedBorderColor = backgroundColor,
    this.focusedBorderWidth = 2,
    this.focusedBorderRadius = 6,
    this.endIcon,
    this.maxLines,
    this.expands = false,
    this.keyboardType,
  });

  final String placeholder;
  final double placeholderSize;
  final FontWeight placeholderWeight;
  final Color enableBorderColor;
  final double enableBorderWidth;
  final double enableBorderRadius;
  final Color focusedBorderColor;
  final double focusedBorderWidth;
  final double focusedBorderRadius;
  final Widget? endIcon;
  final int? maxLines;
  final bool expands;
  final TextInputType? keyboardType;
  @override
  Widget build(BuildContext context) {
    return TextField(
      textAlign: TextAlign.start,
      textAlignVertical: TextAlignVertical.top,
      maxLines: maxLines,
      expands: expands,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: placeholder,
        hintStyle: GoogleFonts.inter(
          // Sử dụng font Lato từ Google Fonts
          textStyle: TextStyle(
            color: textColor.withOpacity(0.7),
            fontSize: placeholderSize,
            fontWeight: placeholderWeight,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: enableBorderColor, width: enableBorderWidth),
          borderRadius: BorderRadius.circular(enableBorderRadius),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: focusedBorderColor, width: focusedBorderWidth),
          borderRadius: BorderRadius.circular(focusedBorderRadius),
        ),
        suffixIcon: endIcon,
      ),
    );
  }
}