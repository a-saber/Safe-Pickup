import 'package:call_son/core/core_widgets/icon_container/icon_container.dart';
import 'package:call_son/core/resources_manager/color_manager.dart';
import 'package:call_son/core/resources_manager/style_manager.dart';
import 'package:flutter/material.dart';

class OptionWidget extends StatelessWidget {
  const OptionWidget(
      {super.key,
      required this.onTap,
      required this.text,
      required this.image,
      required this.isSelected});

  final Function() onTap;
  final String text;
  final String image;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          IconContainer(
            image: image,
            isSelected: isSelected,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            text,
            style: StyleManager.bold.copyWith(
              color: isSelected
                  ? ColorsManager.primary
                  : ColorsManager.grey,
            ),
          )
        ],
      ),
    );
  }
}
