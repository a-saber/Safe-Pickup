import 'package:call_son/core/core_widgets/default_button/default_button.dart';
import 'package:call_son/core/core_widgets/default_form/default_form_field.dart';
import 'package:call_son/core/core_widgets/logo_widget.dart';
import 'package:call_son/core/core_widgets/pop_up/my_snack_bar.dart';
import 'package:call_son/core/localization/translation_key_manager.dart';
import 'package:call_son/core/resources_manager/color_manager.dart';
import 'package:call_son/core/resources_manager/delay_manager.dart';
import 'package:call_son/core/resources_manager/padding_manager.dart';
import 'package:call_son/core/resources_manager/style_manager.dart';
import 'package:call_son/feature/auth/presentation/cubit/get_parent_cubit/get_parent_cubit.dart';
import 'package:call_son/feature/guardian/presentation/views/parents_home_view.dart';
import 'package:call_son/feature/auth/presentation/cubit/get_school_cubit/get_school_cubit.dart';
import 'package:call_son/feature/auth/presentation/cubit/login/login_cubit.dart';
import 'package:call_son/feature/auth/presentation/cubit/login/login_state.dart';
import 'package:call_son/feature/auth/presentation/views/forget_pass_view.dart';
import 'package:call_son/feature/school/presentation/views/school_home_view.dart';
import 'package:call_son/feature/welcome/presentation/views/welcome_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

class SchoolLoginViewBody extends StatefulWidget {
  const SchoolLoginViewBody({super.key});

  @override
  State<SchoolLoginViewBody> createState() => _SchoolLoginViewBodyState();
}

class _SchoolLoginViewBodyState extends State<SchoolLoginViewBody> {
  bool showPassword = true;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: PaddingManager.scaffoldBodyPadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const LogoWidget(),
                const SizedBox(
                  height: 20,
                ),
                DefaultFormField(
                  labelText: TranslationKeyManager.email.tr,
                  textInputType: TextInputType.emailAddress,
                  controller: email,
                  suffixIcon: const Icon(
                    IconlyLight.message,
                    color: ColorsManager.primary,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                DefaultFormField(
                  labelText: TranslationKeyManager.password.tr,
                  textInputType: TextInputType.text,
                  controller: password,
                  isPassword: showPassword,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                    icon: Icon(
                      showPassword
                          ? IconlyLight.show
                          : IconlyLight.hide,
                      color: ColorsManager.primary,
                    ),
                  ),
                ),

                // Forget Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Get.to(()=> const ForgetPasswordView(),
                      duration: const Duration(milliseconds: 500),
                      transition: DelayManager.rightToLeftWithFade);
                    },
                    child: Text(
                      TranslationKeyManager.forgotPassword.tr,
                      style: const TextStyle(
                        fontSize: 14,
                        color: ColorsManager.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                // Login Button
                BlocConsumer<LoginCubit, LoginState>(
                  listener: (context, state) {
                    if (state is SchoolLoginFailure) {
                      callMySnackBar(
                          context: context, text: state.failure.errorMessage);
                    } else if (state is SchoolLoginSuccess) {
                      //callMySnackBar(context: context, text: 'Welcome');
                      if (state.loginResponse.isSchool) {
                        GetSchoolCubit.get(context)
                            .assignSchool(json: state.loginResponse.json);
                        Get.off(() => const SchoolHomeView(),
                            duration: const Duration(milliseconds: 500),
                            transition: DelayManager.rightToLeftWithFade);
                      } else {
                        GetParentCubit.get(context).assignParent(json: state.loginResponse.json);
                        Get.off(() => const ParentsHomeView(),
                            duration: const Duration(milliseconds: 500),
                            transition: DelayManager.rightToLeftWithFade);
                      }
                    }
                  },
                  builder: (context, state) {
                    if (state is SchoolLoginLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return DefaultButton(
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            LoginCubit.get(context).login(
                                email: email.text, password: password.text);
                          }
                        },
                        text: TranslationKeyManager.login.tr);
                  },
                ),

                // Register
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    TranslationKeyManager.doNotHaveAnAccount.tr,
                    style: StyleManager.regular,
                  ),
                  TextButton(
                      onPressed: () {
                        Get.to(
                          ()=> const WelcomeView(),
                          duration: const Duration(milliseconds: 500),
                          transition: DelayManager.rightToLeftWithFade
                        );
                      },
                      child: Text(
                        TranslationKeyManager.registerNow.tr,
                        style: const TextStyle(
                          fontSize: 14,
                          color: ColorsManager.primary,
                        ),
                      ))
                ])
              ],
            ),
          ),
        ),
      ),
    );
  }
}
