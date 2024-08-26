import 'package:call_son/core/core_widgets/custom_app_bar.dart';
import 'package:call_son/core/localization/translation_key_manager.dart';
import 'package:call_son/feature/auth/presentation/views/widgets/login_view_body.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: TranslationKeyManager.login.tr),
      body: const SchoolLoginViewBody(),
    );
  }
}
