import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final List<Widget>? actionWidget;
  final Widget? leadingWidget;

  const AppBarWidget({
    super.key,
    this.title = "",
    this.backgroundColor = Colors.white,
    this.actionWidget,
    this.leadingWidget,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leadingWidget,
      actions: actionWidget,
      centerTitle: true,
      backgroundColor: backgroundColor,
      title: Column(
        children: [
          Text(
            title ?? "",
            style: textStyle,
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 20);
}
