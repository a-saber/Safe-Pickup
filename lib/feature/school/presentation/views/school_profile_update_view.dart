import 'package:call_son/core/core_widgets/custom_app_bar.dart';
import 'package:call_son/core/core_widgets/default_button/default_button.dart';
import 'package:call_son/core/core_widgets/default_form/default_form_field.dart';
import 'package:call_son/core/core_widgets/more/default_switch.dart';
import 'package:call_son/core/core_widgets/pop_up/my_snack_bar.dart';
import 'package:call_son/core/localization/translation_key_manager.dart';
import 'package:call_son/core/models/school_model.dart';
import 'package:call_son/core/resources_manager/color_manager.dart';
import 'package:call_son/core/resources_manager/padding_manager.dart';
import 'package:call_son/core/shared_functions/image_manager/cubit/get_image_cubit.dart';
import 'package:call_son/core/shared_functions/image_manager/get_image.dart';
import 'package:call_son/feature/auth/presentation/cubit/get_school_cubit/get_school_cubit.dart';
import 'package:call_son/feature/school/presentation/cubit/update_school_data_cubit/update_school_data_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

class SchoolProfileUpdateView extends StatefulWidget {
  const SchoolProfileUpdateView({super.key, required this.schoolModel});

  final SchoolModel schoolModel;

  @override
  State<SchoolProfileUpdateView> createState() => _SchoolProfileUpdateViewState();
}

class _SchoolProfileUpdateViewState extends State<SchoolProfileUpdateView> {

  bool ssn = false;
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController location = TextEditingController();
  @override
  void initState() {
    name.text = widget.schoolModel.name ??'';
    phone.text = widget.schoolModel.phone ??'';
    location.text = widget.schoolModel.location ??'';
    ssn = widget.schoolModel.ssnRequired ??false;
    GetImageCubit.get(context).image = null;
    super.initState();
  }
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: TranslationKeyManager.profile.tr, showPopup: true),
      body:  Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: PaddingManager.scaffoldBodyPadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FileImageView(imagePath: widget.schoolModel.imagePath,),
                const SizedBox(
                  height: 20,
                ),
                DefaultFormField(
                  enabled: false,
                  labelText: TranslationKeyManager.email.tr,
                  textInputType: TextInputType.emailAddress,
                  controller: TextEditingController(text: widget.schoolModel.email),
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
                  labelText: TranslationKeyManager.address.tr,
                  textInputType: TextInputType.text,
                  controller: location,
                  suffixIcon: const Icon(
                    IconlyLight.location,
                    color: ColorsManager.primary,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                DefaultSwitch(
                  text: TranslationKeyManager.ssnRequired.tr,
                  switchVal: ssn,
                  onChanged: (val) {
                    setState(() {
                      ssn = val;
                    });
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                BlocConsumer<UpdateSchoolCubit, UpdateSchoolState>(
                  listener: (context, state) {
                    if(state is UpdateSchoolError)
                    {
                      callMySnackBar(context: context, text: state.error);
                    }
                    else if(state is UpdateSchoolSuccess)
                    {
                      callMySnackBar(context: context, text: TranslationKeyManager.accountUpdatedSuccessfully.tr);
                      GetSchoolCubit.get(context).getSchool();
                    }
                  },
                  builder: (context, state) {
                    if(state is UpdateSchoolLoading)
                    {
                      return const Center(child: CircularProgressIndicator(),);
                    }
                    return DefaultButton(
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            widget.schoolModel.name = name.text;
                            widget.schoolModel.phone = phone.text;
                            widget.schoolModel.location = location.text;
                            widget.schoolModel.ssnRequired = ssn;
                            widget.schoolModel.image = GetImageCubit.get(context).image;
                            UpdateSchoolCubit.get(context).update(schoolModel: widget.schoolModel);
                          }
                        },
                        text: TranslationKeyManager.update.tr);
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
