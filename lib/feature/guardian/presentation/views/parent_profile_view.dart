import 'package:call_son/core/core_widgets/custom_app_bar.dart';
import 'package:call_son/core/core_widgets/default_button/default_button.dart';
import 'package:call_son/core/core_widgets/default_form/default_form_field.dart';
import 'package:call_son/core/core_widgets/pop_up/my_snack_bar.dart';
import 'package:call_son/core/localization/translation_key_manager.dart';
import 'package:call_son/core/resources_manager/assets_manager.dart';
import 'package:call_son/core/resources_manager/color_manager.dart';
import 'package:call_son/feature/auth/presentation/cubit/get_parent_cubit/get_parent_cubit.dart';
import 'package:call_son/feature/auth/presentation/cubit/get_parent_cubit/get_parent_state.dart';
import 'package:call_son/feature/auth/presentation/views/login_view.dart';
import 'package:call_son/feature/guardian/presentation/cubit/update_parent_data_cubit/update_parent_data_cubit.dart';
import 'package:call_son/feature/guardian/presentation/cubit/update_parent_data_cubit/update_parent_data_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

class ParentProfileView extends StatelessWidget {
  const ParentProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: CustomAppBar(title: TranslationKeyManager.profile.tr, showPopup: true, ),
      body: BlocConsumer<GetParentCubit, GetParentState>(
        listener: (context, state)
        {
          if(state is GetParentFailure)
          {
            Get.off(()=> const LoginView());
          }
        },
        builder: (context, state)
        {
          if(state is GetParentLoading)
          {
            return const Center(child: CircularProgressIndicator(),);
          }
          else if (GetParentCubit.get(context).parentModel != null)
          {
            var parentModel = GetParentCubit.get(context).parentModel;
            TextEditingController name = TextEditingController(text: parentModel!.name??'');
            TextEditingController phone = TextEditingController(text: parentModel.phone??'');
            TextEditingController email = TextEditingController(text: parentModel.email??'');
            TextEditingController ssn = TextEditingController(text: parentModel.ssn??'');

            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: Column(
                  children:
                  [
                    Container(
                      height: 80,
                      width: 80,
                      decoration:
                      BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: ColorsManager.primary, width: 1),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Image.asset(
                            AssetsManager.family,
                            color: ColorsManager.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    DefaultFormField(
                      enabled: false,
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
                      labelText: TranslationKeyManager.name.tr,
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
                      labelText: TranslationKeyManager.phone.tr,
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
                      labelText: TranslationKeyManager.ssn.tr,
                      textInputType: TextInputType.number,
                      controller: ssn,
                      suffixIcon: const Icon(
                        IconlyLight.info_circle,
                        color: ColorsManager.primary,
                      ),
                    ),
                    const SizedBox(height: 30,),
                    BlocConsumer<UpdateParentCubit, UpdateParentState>(
                      listener: (context, state) {
                        if(state is UpdateParentError)
                        {
                          callMySnackBar(context: context, text: state.error);
                        }
                        else if(state is UpdateParentSuccess)
                        {
                          callMySnackBar(context: context, text: TranslationKeyManager.accountUpdatedSuccessfully.tr);
                          GetParentCubit.get(context).getParent();
                        }
                      },
                      builder: (context, state) {
                        if(state is UpdateParentLoading)
                        {
                          return const Center(child: CircularProgressIndicator(),);
                        }
                        return DefaultButton(
                            onTap: () {
                              if (formKey.currentState!.validate()) {
                                parentModel.name = name.text;
                                parentModel.phone = phone.text;
                                parentModel.ssn = ssn.text;
                                UpdateParentCubit.get(context).update(parent: parentModel);
                              }
                            },
                            text: TranslationKeyManager.update.tr);
                      },
                    ),
                  ],
                ),
              ),
            );
          }
          else
          {
            return const SizedBox();
          }

        }
      ),
    );
  }
}
