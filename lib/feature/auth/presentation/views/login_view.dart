import 'package:call_son/core/core_widgets/custom_app_bar.dart';
import 'package:call_son/feature/auth/presentation/views/widgets/login_view_body.dart';
import 'package:flutter/material.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: "Login"),
      body: SchoolLoginViewBody(),
    );
  }
}
