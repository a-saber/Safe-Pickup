import 'package:flutter/animation.dart';
import 'package:get/get.dart';

class DelayManager {

  //tween animation
  static Tween<Offset> tweenSplashAnimation =
      Tween<Offset>(begin: const Offset(-6, 0), end: Offset.zero);

  // Transition animation
  static const Transition fade = Transition.fade;
  static const Transition downToUp = Transition.downToUp;
  static const Transition rightToLeftWithFade = Transition.rightToLeftWithFade;
  static const Transition fadeIn = Transition.fadeIn;
}
