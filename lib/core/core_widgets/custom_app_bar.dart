import 'package:call_son/core/resources_manager/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showPopup;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showPopup = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ColorsManager.white,
      title: Text(title),
      leading: showPopup ?IconButton(
        icon: const Icon(IconlyLight.arrow_left_square), // Replace with your custom icon
        onPressed: () {
          Navigator.pop(context);
        },
      ): null,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
