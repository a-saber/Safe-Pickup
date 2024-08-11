import 'package:call_son/core/resources_manager/color_manager.dart';
import 'package:flutter/material.dart';

class IconContainer extends StatelessWidget {
  const IconContainer(
      {super.key, required this.image, required this.isSelected});

  final bool isSelected;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: isSelected? ColorsManager.primary: ColorsManager.grey, width: 1),
      ),
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Image.asset(
          image,
          color:  isSelected? ColorsManager.primary : ColorsManager.grey,
        ),
      ),
    );
  }
}
