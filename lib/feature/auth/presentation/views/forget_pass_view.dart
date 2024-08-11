import 'package:call_son/core/core_widgets/custom_app_bar.dart';
import 'package:call_son/core/core_widgets/default_button/default_button.dart';
import 'package:call_son/core/core_widgets/default_form/default_form_field.dart';
import 'package:call_son/core/core_widgets/logo_widget.dart';
import 'package:call_son/core/core_widgets/pop_up/my_snack_bar.dart';
import 'package:call_son/core/resources_manager/color_manager.dart';
import 'package:call_son/core/resources_manager/padding_manager.dart';
import 'package:call_son/feature/auth/presentation/cubit/school_forgot_pass_cubit/school_forgot_pass_cubit.dart';
import 'package:call_son/feature/auth/presentation/cubit/school_forgot_pass_cubit/school_forgot_pass_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({super.key});

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  final emailController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Forget Password", showPopup: true,),
      body: Center(
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            padding: PaddingManager.scaffoldBodyPadding,
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const LogoWidget(),
                  const SizedBox(height: 20),
                  DefaultFormField(
                    labelText: 'Email',
                    textInputType: TextInputType.emailAddress,
                    controller: emailController,
                    suffixIcon: const Icon(
                      IconlyLight.message,
                      color: ColorsManager.primary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  BlocConsumer<SchoolForgetPassCubit, SchoolForgetPassState>(
                      listener: (context, state) {
                        if (state is SchoolForgetPassSuccess) {
                          callMySnackBar(
                            context: context,
                            text: 'Reset Email sent successfully',
                          );
                          Navigator.pop(context);
                        } else if (state is SchoolForgetPassFailure) {
                          callMySnackBar(
                            context: context,
                            text: state.failure.errorMessage,
                          );
                        }
                      }, builder: (context, state) {
                    if (state is SchoolForgetPassLoading) {
                      return const CircularProgressIndicator();
                    } else {
                      return DefaultButton(
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              SchoolForgetPassCubit.get(context).forgotPass(
                                email: emailController.text,
                              );}
                          },
                          text: "Send Reset Email");
                    }
                  })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}