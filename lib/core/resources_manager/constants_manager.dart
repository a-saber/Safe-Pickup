
import 'package:flutter/material.dart';
import 'color_manager.dart';

abstract class ConstantsManager
{
  static const String appTitle = 'Safe Pickup';
  static const String fontFamily = 'Cairo';

}

class ThemeManager
{
  static ThemeData theme=ThemeData(
      primaryColor: ColorsManager.primary,
      fontFamily: 'Cairo',
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: ColorsManager.primary),
      textSelectionTheme: const TextSelectionThemeData(cursorColor: ColorsManager.primary),
      appBarTheme:
      const AppBarTheme(backgroundColor: ColorsManager.white,
      ),
      scaffoldBackgroundColor: ColorsManager.white
  );
}

class CollectionManager
{
  static const schoolsCollection = 'schools';
  static const parentsCollection = 'parents';
  static const kidsCollection = 'kids';
  static const callCollection = 'calls';
  static const levelsCollection = 'levels';
  static const schoolParentsCollection = 'schoolParents';
  static const schoolKidsCollection = 'schoolKids';
}