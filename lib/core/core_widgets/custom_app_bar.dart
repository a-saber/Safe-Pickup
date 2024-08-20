import 'package:call_son/core/cache_helper/cache_data.dart';
import 'package:call_son/core/cache_helper/cache_helper_keys.dart';
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
      leading: showPopup ?
      IconButton(
        icon: Icon( CacheData.lang == CacheHelperKeys.keyEN?
        IconlyLight.arrow_left_square : IconlyLight.arrow_right_square), // Replace with your custom icon
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
