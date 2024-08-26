import 'package:call_son/core/core_widgets/pop_up/my_snack_bar.dart';
import 'package:call_son/core/localization/translation_key_manager.dart';
import 'package:call_son/core/models/parent_model.dart';
import 'package:call_son/core/resources_manager/delay_manager.dart';
import 'package:call_son/core/resources_manager/style_manager.dart';
import 'package:call_son/feature/auth/presentation/cubit/guardian_register_ui/guardian_register_ui_state.dart';
import 'package:call_son/feature/auth/presentation/cubit/parent_register/parent_register_cubit.dart';
import 'package:call_son/feature/auth/presentation/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/core_widgets/default_button/default_button.dart';
import '../../../../../core/resources_manager/app_router.dart';
import '../../../../../core/resources_manager/color_manager.dart';
import '../../cubit/guardian_register_ui/guardian_register_ui_cubit.dart';

class RegisterButton extends StatelessWidget {
  const RegisterButton({super.key, required this.formKey,});

  final formKey;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ParentRegisterCubit, ParentRegisterState>(
      listener: (context, state)
      {
        if(state is ParentRegisterSuccess)
        {
          callMySnackBar(context: context, text: TranslationKeyManager.registerSuccessVerifyEmail.tr, backgroundColor: ColorsManager.primary);
          Get.off(()=> const LoginView(),
          duration: const Duration(milliseconds: 500),
          transition: DelayManager.rightToLeftWithFade);
        }
        if(state is ParentRegisterError)
        {
          callMySnackBar(context: context, text: state.error, backgroundColor: ColorsManager.red);
        }
      },
      builder: (context, state) {
        return state is ParentRegisterLoading  ?
        const Center(
          child: CircularProgressIndicator(
            color: ColorsManager.primary,
          ),
        ) :
        BlocConsumer<ParentRegisterUiCubit, ParentRegisterUiState>(
          listener: (context, state) {},
          builder: (context, uiState) {
            return Column(
              children: [
                if(state is ParentRegisterDuplicateError)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Text(state.error, style: StyleManager.medium.copyWith(color: ColorsManager.red),),
                  ),
                DefaultButton(
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        ParentModel parentModel = ParentModel(
                          name: ParentRegisterUiCubit.get(context).nameController.text,
                          ssn: ParentRegisterUiCubit.get(context).ssnController.text,
                          phone: ParentRegisterUiCubit.get(context).phoneController.text,
                          email: ParentRegisterUiCubit.get(context).emailController.text,
                          password: ParentRegisterUiCubit.get(context).passwordController.text,
                        );
                        parentModel.kidsModels = ParentRegisterUiCubit.get(context).kids;
                        ParentRegisterCubit.get(context).register(
                          parentModel: parentModel,
                        );
                      }
                    },
                    text: TranslationKeyManager.register.tr),
              ],
            );
          },
        );
      },
    );
  }
}
