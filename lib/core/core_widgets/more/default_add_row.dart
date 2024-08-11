import 'package:call_son/core/resources_manager/color_manager.dart';
import 'package:call_son/core/resources_manager/style_manager.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class DefaultAddRow extends StatelessWidget {
  const DefaultAddRow(
      {super.key,
      required this.text,
      required this.number,
        this.icon = IconlyLight.plus,
        this.isInner = false,
      required this.onPressed});

  final String text;
  final bool isInner;
  final int number;
  final IconData? icon;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    double fontSize = isInner? 14.0 :18.0;
    return Row(
      children: [
        Text(
          number.toString(),
          style: StyleManager.semiBold.copyWith(
            fontSize: fontSize,
          ),
        ),
        const SizedBox(width: 5,),
        Text(
          text,
          style: StyleManager.semiBold.copyWith(
            fontSize: fontSize,
          ),
        ),

        const Spacer(),

        IconButton(
          onPressed: onPressed,
          icon: Icon(
            icon,
            color: ColorsManager.primary,
          ),
        ),

      ],
    );
  }
}
