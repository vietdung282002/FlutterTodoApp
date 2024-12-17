import 'package:flutter/material.dart';

class CategoryWidget extends StatelessWidget {
  final Widget image;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;

  const CategoryWidget({
    super.key,
    required this.image,
    required this.onTap,
    this.backgroundColor = Colors.white,
    this.borderColor = Colors.white,
    this.borderWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
          border: Border.all(
            color: borderColor,
            width: borderWidth,
          )),
      child: IconButton(
        onPressed: onTap,
        icon: image,
      ),
    );
  }
}
