import 'package:flutter/material.dart';
import 'package:call_son/core/resources_manager/color_manager.dart';
import 'package:call_son/core/resources_manager/style_manager.dart';

import 'pop_up_options.dart';



void callMySnackBar({
  required context,
  required String text,
  PopUpState? state,
  Color? backgroundColor = Colors.black,
  Color textColor = ColorsManager.white

})
{
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: state != null ? choosePopUpColor(state) :backgroundColor,
      content: Text(
        text,
        style: StyleManager.regular.copyWith(
          fontSize:15.0,
          color: textColor
        ),
      ),
      duration:const Duration(seconds: 2) ,
    ),

  );
}