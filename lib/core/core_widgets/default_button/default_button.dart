import 'package:call_son/core/resources_manager/color_manager.dart';
import 'package:call_son/core/resources_manager/style_manager.dart';
import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton(
      {super.key,
      required this.onTap,
      required this.text,
        this.icon,
      this.buttonColor = ColorsManager.primary});

  final Function()? onTap;
  final String text;
  final Color buttonColor;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: MaterialButton(
        disabledColor: ColorsManager.grey,
        onPressed: onTap,
        color: buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child:
        Builder(
          builder: (context) {
            if(icon != null){
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon!,
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    text,
                    style: StyleManager.regular.copyWith(
                      color: ColorsManager.white,
                    ),
                  ),
                ],
              );
            }
            return Text(
              text,
              style: StyleManager.regular.copyWith(
                color: ColorsManager.white,
              ),
            );
          }
        ),
      ),
    );
  }
}
