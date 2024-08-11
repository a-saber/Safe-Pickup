import 'package:call_son/core/core_widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'widgets/school_register_view_body.dart';

class SchoolRegisterView extends StatelessWidget {
  const SchoolRegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: "New School", showPopup: true,),
      body: SchoolRegisterViewBody(),
    );
  }
}
