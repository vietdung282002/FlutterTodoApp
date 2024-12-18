import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TextButtonWidget extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final VoidCallback onTap;
  const TextButtonWidget({
    super.key,
    required this.text,
    this.textStyle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: text,
        style: textStyle,
        recognizer: TapGestureRecognizer()..onTap = onTap,
      ),
    );
  }
}
