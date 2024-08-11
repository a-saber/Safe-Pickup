import 'package:call_son/core/core_widgets/custom_app_bar.dart';
import 'package:call_son/core/core_widgets/default_button/default_button.dart';
import 'package:call_son/core/core_widgets/default_form/default_form_field2.dart';
import 'package:call_son/core/core_widgets/pop_up/my_snack_bar.dart';
import 'package:call_son/core/models/kid_model.dart';
import 'package:call_son/feature/guardian/presentation/cubit/edit_kid/edit_kid_cubit.dart';
import 'package:call_son/feature/guardian/presentation/cubit/edit_kid/edit_kid_state.dart';
import 'package:call_son/feature/guardian/presentation/cubit/get_super_parent_kids_cubit/get_super_parent_kids_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditKidData extends StatelessWidget {
  EditKidData({super.key, required this.kid});

  final KidModel kid;
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    nameController.text = kid.name??"";
    return Scaffold(
      appBar: const CustomAppBar(title: 'Edit Kid', showPopup: true,),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children:
            [
              DefaultFormField2(
                hintText: "kid name",
                textInputType: TextInputType.name,
                controller: nameController,
              ),
              const SizedBox(height: 30,),
              BlocConsumer<EditKidCubit, EditKidState>(
                listener: (context, state) {
                  if (state is EditKidFailure) {
                    callMySnackBar(
                        context: context, text: state.failure.errorMessage);
                  }
                  else if (state is EditKidSuccess) {
                    kid.name=nameController.text;
                    GetAllParentKidsCubit.get(context).getAllParentKids(superParentId: kid.superParentId!);
                    callMySnackBar(context: context, text: 'Edited Successfully');
                  }
                },
                builder: (context, state) {
                  if (state is EditKidLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return DefaultButton(
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          kid.name = nameController.text;
                          EditKidCubit.get(context).editKid(kid: kid);
                        }
                      },
                      text: "Edit");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}