import 'package:call_son/core/core_widgets/pop_up/my_snack_bar.dart';
import 'package:call_son/core/localization/translation_key_manager.dart';
import 'package:call_son/core/resources_manager/color_manager.dart';
import 'package:call_son/core/resources_manager/style_manager.dart';
import 'package:call_son/core/shared_functions/image_manager/get_image.dart';
import 'package:call_son/feature/auth/presentation/cubit/get_school_cubit/get_school_cubit.dart';
import 'package:call_son/feature/auth/presentation/cubit/get_school_cubit/get_school_state.dart';
import 'package:call_son/feature/auth/presentation/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class SchoolHomeView extends StatelessWidget {
  const SchoolHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GetSchoolCubit, GetSchoolState>(
      listener: (context, state) {
        if (state is GetSchoolFailure) {
          callMySnackBar(context: context, text: state.failure.errorMessage);
          Get.off(() => const LoginView());
        }
      },
      builder: (context, state) {
        if(state is GetSchoolLoading)
        {
          return const Center(child: CircularProgressIndicator(),);
        }
        else if(state is GetSchoolSuccess)
        {
          var cubit = GetSchoolCubit.get(context);
          return SafeArea(
            child: Column(
              children:
              [
                Row(
                  children: [
                    Builder( builder: (context) {
                      if(cubit.schoolModel!.imagePath == null)
                      {
                        return const IconImageViewer();
                      }
                      else
                      {
                        return CloudImageViewer(imagePath: cubit.schoolModel!.imagePath!);
                      }
                    }),
                    const SizedBox(width: 10,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            TranslationKeyManager.hello.tr,
                            style: StyleManager.bold.copyWith(
                              color: ColorsManager.primary),
                          ),
                          Text(cubit.schoolModel!.name ??'',
                            style: StyleManager.regular.copyWith(
                              fontSize: 15.0
                            ),
                          ),

                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        }
        else
        {
          return const SizedBox();
        }
      },
    );
  }
}
