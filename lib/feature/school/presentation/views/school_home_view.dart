import 'package:call_son/core/core_widgets/pop_up/my_snack_bar.dart';
import 'package:call_son/core/localization/translation_key_manager.dart';
import 'package:call_son/core/resources_manager/color_manager.dart';
import 'package:call_son/core/resources_manager/constants_manager.dart';
import 'package:call_son/core/resources_manager/style_manager.dart';
import 'package:call_son/core/shared_functions/image_manager/get_image.dart';
import 'package:call_son/feature/auth/presentation/cubit/get_school_cubit/get_school_cubit.dart';
import 'package:call_son/feature/auth/presentation/cubit/get_school_cubit/get_school_state.dart';
import 'package:call_son/feature/auth/presentation/views/login_view.dart';
import 'package:call_son/feature/school/presentation/views/school_calls_view.dart';
import 'package:call_son/feature/school/presentation/views/widgets/school_custom_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

class SchoolHomeView extends StatelessWidget {
  const SchoolHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      FirebaseFirestore.instance.collection(CollectionManager.schoolsCollection)
          .doc(FirebaseAuth.instance.currentUser!.uid).update({'fcmToken': newToken});
    });
    return Scaffold(
      key:  scaffoldKey,
      drawer: SchoolCustomDrawer(scaffoldKey: scaffoldKey),
      appBar: AppBar(
        title: Text(TranslationKeyManager.home.tr),
        leading: IconButton(
          onPressed: () {
            scaffoldKey.currentState!.openDrawer();
          },
          icon: const Icon(IconlyLight.category),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocConsumer<GetSchoolCubit, GetSchoolState>(
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
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    ),
                    const SizedBox(height: 30,),
                    Text(TranslationKeyManager.pickupRequests.tr,
                    style: StyleManager.regular.copyWith(
                      fontSize: 17
                    ),),
                    const SizedBox(height: 15,),
                    Expanded(child: const SchoolCallsView())
                  ],
                ),
              );
            }
            else
            {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
