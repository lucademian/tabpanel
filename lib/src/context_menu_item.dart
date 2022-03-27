import 'package:flutter/widgets.dart';

class ContextMenuItem {
  final String? title;

  final IconData? icon;

  final Function()? onPressed;

  ContextMenuItem({
    this.title,
    this.icon,
    this.onPressed,
  });
}
