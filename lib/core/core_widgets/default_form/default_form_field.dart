import 'package:call_son/core/localization/translation_key_manager.dart';
import 'package:call_son/core/resources_manager/color_manager.dart';
import 'package:call_son/core/resources_manager/style_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DefaultFormField extends StatelessWidget {
  const DefaultFormField({
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
    this.labelText,
    this.suffixPadding = 5.0,
    this.isFillWhite=false,
    this.hintText,
  });

  final int maxLines;
  final double suffixPadding;
  final bool enabled;
  final bool readOnly;
  final bool? isPassword;
  final String? labelText;
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
          return  TranslationKeyManager.notEmpty.tr;
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
        labelText: labelText,
        labelStyle: StyleManager.semiBold.copyWith(
          fontSize: 15.0,
        ),
        suffixIcon: Padding(
          padding: EdgeInsetsDirectional.only(end:suffixPadding),
          child: suffixIcon,
        ),
          errorStyle: StyleManager.regular.copyWith(
              color: ColorsManager.red),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: ColorsManager.grey),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: ColorsManager.primary),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color:  ColorsManager.red,
              )
          ),
          errorBorder:  OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color:  ColorsManager.red,
              )
          ),
        contentPadding: const EdgeInsetsDirectional.only(start: 10.0)
      ),
    );
  }
}

