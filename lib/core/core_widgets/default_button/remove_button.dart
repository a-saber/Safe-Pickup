import 'package:call_son/core/resources_manager/color_manager.dart';
import 'package:call_son/core/resources_manager/style_manager.dart';
import 'package:flutter/material.dart';

class DefaultRemoveButton extends StatelessWidget {
  const DefaultRemoveButton({super.key, required this.onTap});
final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 44,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: ColorsManager.primary,
        ),
        child: Center(
          child: Text("Remove",style: StyleManager.regular.copyWith(
            color: ColorsManager.white,
          ),),
        ),
      ),
    );
  }
}
