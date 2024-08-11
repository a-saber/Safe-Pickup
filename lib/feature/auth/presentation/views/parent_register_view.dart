import 'package:call_son/core/core_widgets/custom_app_bar.dart';
import 'package:call_son/core/core_widgets/default_button/default_button.dart';
import 'package:call_son/core/core_widgets/default_form/default_form_field.dart';
import 'package:call_son/core/core_widgets/more/default_add_row.dart';
import 'package:call_son/core/core_widgets/pop_up/my_snack_bar.dart';
import 'package:call_son/core/resources_manager/color_manager.dart';
import 'package:call_son/core/resources_manager/delay_manager.dart';
import 'package:call_son/core/shared_functions/image_manager/get_image.dart';
import 'package:call_son/feature/auth/presentation/cubit/get_schools/get_school_cubit.dart';
import 'package:call_son/feature/auth/presentation/cubit/guardian_register_ui/guardian_register_ui_cubit.dart';
import 'package:flutter/material.dart';
import 'package:call_son/feature/auth/presentation/cubit/guardian_register_ui/guardian_register_ui_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

import 'widgets/guardian_kids_data.dart';
import 'widgets/register_button.dart';

class ParentRegisterView extends StatefulWidget {
  const ParentRegisterView({super.key});

  @override
  State<ParentRegisterView> createState() => _ParentRegisterViewState();
}

class _ParentRegisterViewState extends State<ParentRegisterView> {
  bool passVisible = false;
  bool confirmPassVisible = false;
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      appBar: const CustomAppBar(title: "New Parent", showPopup: true,),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 30),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BlocConsumer<ParentRegisterUiCubit, ParentRegisterUiState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    var cubit = ParentRegisterUiCubit.get(context);
                    return Column(
                      children:
                      [
                        const IconImageViewer(isSchool: false,),
                        const SizedBox(height: 20,),
                        DefaultFormField(
                          labelText: 'Name',
                          textInputType: TextInputType.name,
                          controller: cubit.nameController,
                          suffixIcon: const Icon(
                            IconlyLight.profile,
                            color: ColorsManager.primary,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        DefaultFormField(
                          labelText: 'SSN',
                          textInputType: TextInputType.number,
                          controller: cubit.ssnController,
                          suffixIcon: const Icon(
                            IconlyLight.info_circle,
                            color: ColorsManager.primary,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        DefaultFormField(
                          labelText: 'Phone',
                          textInputType: TextInputType.phone,
                          controller: cubit.phoneController,
                          suffixIcon: const Icon(
                            IconlyLight.call,
                            color: ColorsManager.primary,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        DefaultFormField(
                          labelText: 'Email',
                          textInputType: TextInputType.emailAddress,
                          controller: cubit.emailController,
                          suffixIcon: const Icon(
                            IconlyLight.message,
                            color: ColorsManager.primary,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        DefaultFormField(
                          labelText: 'Password',
                          textInputType: TextInputType.text,
                          controller: cubit.passwordController,
                          isPassword: !passVisible,
                          suffixIcon: IconButton(
                              onPressed: ()
                              {
                                setState(() {
                                  passVisible = !passVisible;
                                });
                              }, icon: Icon(
                            passVisible? IconlyLight.show : IconlyLight.hide,
                            color: ColorsManager.primary,
                          )),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        DefaultFormField(
                          labelText: 'Confirm Password',
                          textInputType: TextInputType.text,
                          controller: cubit.confirmPasswordController,
                          isPassword: !confirmPassVisible,
                          suffixIcon: IconButton(
                              onPressed: ()
                              {
                                setState(() {
                                  confirmPassVisible = !confirmPassVisible;
                                });
                              }, icon: Icon(
                            confirmPassVisible? IconlyLight.show : IconlyLight.hide,
                            color: ColorsManager.primary,
                          )),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    );
                  },
                ),
                DefaultButton(
                  onTap: ()
                  {
                    if(formKey.currentState!.validate()){
                      if(ParentRegisterUiCubit.get(context).passwordController.text ==
                          ParentRegisterUiCubit.get(context).confirmPasswordController.text)
                      {
                      Get.to(()=> const ParentAssignKids(),
                      duration: const Duration(milliseconds: 500),
                      transition: DelayManager.rightToLeftWithFade);
                      }
                      else
                      {
                        callMySnackBar(context: context, text: 'Password does not match');
                      }
                    }
                  }, text: 'Continue')
              ],
            ),
          ),
        ),
      ),
    );
  }
}




class ParentAssignKids extends StatefulWidget {
  const ParentAssignKids({super.key});

  @override
  State<ParentAssignKids> createState() => _ParentAssignKidsState();
}

class _ParentAssignKidsState extends State<ParentAssignKids> {
  @override
  void initState() {
    GetSchoolsCubit.get(context).getSchools();
    super.initState();
  }
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.white,
      appBar: const CustomAppBar(title: "Assign Kids", showPopup: true,),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const ParentKidsData(),
                const SizedBox(
                  height: 30,
                ),
                RegisterButton(
                  formKey: formKey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
