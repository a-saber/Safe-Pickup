import 'package:call_son/core/resources_manager/color_manager.dart';
import 'package:call_son/core/resources_manager/style_manager.dart';
import 'package:flutter/material.dart';

class DefaultFormField2 extends StatelessWidget {
  const DefaultFormField2({
    super.key,
    this.enabled = true,
    this.readOnly = false,
    required this.controller,
    this.suffixIcon,
    this.textInputType = TextInputType.text,
    this.isPassword = false,
    this.onChange,
    this.onTap,
    this.validator,
    this.maxLines = 1,
    this.suffixPadding = 5.0,
    this.isFillWhite=false,
    this.hintText,
  });

  final int maxLines;
  final double suffixPadding;
  final bool enabled;
  final bool readOnly;
  final bool? isPassword;
  final String? hintText;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final TextInputType textInputType;
  final void Function(String)? onChange;
  final void Function()? onTap;
  final String? Function(String?)? validator;
  final bool? isFillWhite;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator ??
              (value) {
        if (value!.isEmpty) {
          return 'Must not be empty';
        }
        return null;
      },
      readOnly: readOnly,
      onTap: onTap,
      keyboardType: textInputType,
      controller: controller,
      onChanged: onChange,
      maxLines: maxLines,
      style: StyleManager.regular.copyWith(
        fontSize: 15.0,
        color: ColorsManager.primary
      ),
      obscureText: isPassword!,
      obscuringCharacter: '●',
      cursorColor: ColorsManager.primary,
      enabled: enabled,
      decoration: InputDecoration(
        hintText: hintText,
        labelStyle: StyleManager.regular.copyWith(
            fontSize: 15.0,
            color: ColorsManager.primary
        ),
        hintStyle: StyleManager.regular.copyWith(
          fontSize: 15.0,
            color: Colors.black.withOpacity(0.5)),
        suffixIcon: suffixIcon!=null?Padding(
          padding: EdgeInsetsDirectional.only(end:suffixPadding),
          child: suffixIcon,
        ):null,
          errorMaxLines: 2,
          errorStyle: StyleManager.regular.copyWith(
              fontSize: 13.0,
              color: ColorsManager.red),
          filled: true,
          fillColor: ColorsManager.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          disabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: ColorsManager.black),
          ),
          // enabledBorder: OutlineInputBorder(
          //    borderRadius: BorderRadius.circular(12),
          //     borderSide: BorderSide(color: ColorsManager.grey),
          // ),
          // focusedBorder: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(12),
          //   borderSide: BorderSide(color: ColorsManager.primary),
          // ),
          // focusedErrorBorder: OutlineInputBorder(
          //     borderRadius: BorderRadius.circular(12),
          //     borderSide: const BorderSide(
          //       color:  ColorsManager.red,
          //     )
          // ),
          errorBorder:  const UnderlineInputBorder(
              borderSide: BorderSide(
                color:  ColorsManager.red,
              )
          ),
      ),
    );
  }
}

