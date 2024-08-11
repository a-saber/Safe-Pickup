import 'package:call_son/core/resources_manager/assets_manager.dart';
import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key, this.heightPercent=0.35});
  final double heightPercent ;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height * heightPercent,
        child: Image.asset(AssetsManager.logo));
  }
}
