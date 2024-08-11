import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import 'package:call_son/core/core_widgets/default_button/default_button.dart';
import 'package:call_son/core/core_widgets/default_form/default_form_field.dart';
import 'package:call_son/core/core_widgets/more/default_add_item_row.dart';
import 'package:call_son/core/core_widgets/more/default_add_row.dart';
import 'package:call_son/core/core_widgets/more/default_switch.dart';
import 'package:call_son/core/core_widgets/pop_up/my_snack_bar.dart';
import 'package:call_son/core/resources_manager/color_manager.dart';
import 'package:call_son/core/resources_manager/delay_manager.dart';
import 'package:call_son/core/resources_manager/padding_manager.dart';
import 'package:call_son/core/models/level_model.dart';
import 'package:call_son/core/shared_functions/image_manager/cubit/get_image_cubit.dart';
import 'package:call_son/core/shared_functions/image_manager/get_image.dart';
import 'package:call_son/feature/auth/presentation/cubit/school_register/school_register_cubit.dart';
import 'package:call_son/feature/auth/presentation/views/login_view.dart';
import 'package:iconly/iconly.dart';



class SchoolRegisterViewBody extends StatefulWidget {
  const SchoolRegisterViewBody({super.key});
  @override
  State<SchoolRegisterViewBody> createState() => _SchoolRegisterViewBodyState();
}

class _SchoolRegisterViewBodyState extends State<SchoolRegisterViewBody> {
  bool ssn = false;
  bool showPassword = true;
  bool showPasswordConfirm = true;
  List<TextEditingController> levels = [TextEditingController()];
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController passwordConfirm = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    GetImageCubit.get(context).image = null;
    super.initState();
  }
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
                const FileImageView(),
                const SizedBox(
                  height: 20,
                ),
                DefaultFormField(
                  labelText: 'Name',
                  textInputType: TextInputType.text,
                  controller: name,
                  suffixIcon: const Icon(
                    IconlyLight.profile,
                    color: ColorsManager.primary,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                DefaultFormField(
                  labelText: 'Phone',
                  textInputType: TextInputType.phone,
                  controller: phone,
                  suffixIcon: const Icon(
                    IconlyLight.call,
                    color: ColorsManager.primary,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                DefaultFormField(
                  labelText: 'Email',
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
                  labelText: 'Password',
                  textInputType: TextInputType.text,
                  controller: password,
                  isPassword: showPassword,
                  suffixIcon: IconButton(
                    onPressed: ()
                    {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                    icon: Icon( showPassword?
                    IconlyLight.show : IconlyLight.hide,
                      color: ColorsManager.primary,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                DefaultFormField(
                  labelText: 'Confirm Password',
                  textInputType: TextInputType.text,
                  controller: passwordConfirm,
                  isPassword: showPasswordConfirm,
                  suffixIcon: IconButton(
                    onPressed: ()
                    {
                      setState(() {
                        showPasswordConfirm = !showPasswordConfirm;
                      });
                    },
                    icon: Icon( showPasswordConfirm?
                    IconlyLight.show : IconlyLight.hide,
                      color: ColorsManager.primary,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                DefaultSwitch(
                  text: "SSN Required",
                  switchVal: ssn,
                  onChanged: (val) {
                    setState(() {
                      ssn = val;
                    });
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                DefaultAddRow(
                  text: "Levels",
                  number: levels.length,
                  onPressed: () {
                    setState(() {
                      levels.add(TextEditingController());
                    });
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) =>
                      DefaultAddItemRow(
                        controller: levels[index],
                        onTapButton: () {
                          setState(() {
                            if (levels.length > 1) {
                              levels.removeAt(index);
                            }
                          });
                        },
                      ),
                  itemCount: levels.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(
                        height: 15,
                      ),
                ),
                const SizedBox(
                  height: 30,
                ),
                BlocConsumer<SchoolRegisterCubit, SchoolRegisterState>(
                  listener: (context, state) {
                    if(state is SchoolRegisterError)
                    {
                      callMySnackBar(context: context, text: state.error);
                    }
                    else if(state is SchoolRegisterSuccess)
                    {
                      callMySnackBar(context: context, text: 'Verification Email Sent to Your Email\nPlease Verify Your Email');
                      Get.off(() => const LoginView(),
                      duration: const Duration(milliseconds: 500),
                      transition: DelayManager.rightToLeftWithFade);
                    }
                  },
                  builder: (context, state) {
                    if(state is SchoolRegisterLoading)
                    {
                      return const Center(child: CircularProgressIndicator(),);
                    }
                    return DefaultButton(
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                           if(password.text == passwordConfirm.text)
                           {
                             SchoolRegisterCubit.get(context).schoolModel.levels = List.generate(levels.length, (index) =>
                                 LevelModel(name: levels[index].text));
                             SchoolRegisterCubit.get(context).schoolModel.email = email.text;
                             SchoolRegisterCubit.get(context).schoolModel.password = password.text;
                             SchoolRegisterCubit.get(context).schoolModel.ssnRequired = ssn;
                             SchoolRegisterCubit.get(context).schoolModel.name = name.text;
                             SchoolRegisterCubit.get(context).schoolModel.phone = phone.text;
                             SchoolRegisterCubit.get(context).schoolModel.image = GetImageCubit.get(context).image;

                             SchoolRegisterCubit.get(context).register();
                           }
                           else {
                             callMySnackBar(context: context, text: 'Password not match');
                           }
                          }
                        },
                        text: "Register");
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
