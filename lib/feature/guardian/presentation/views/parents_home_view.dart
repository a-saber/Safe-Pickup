import 'package:call_son/core/core_widgets/default_form/default_form_field.dart';
import 'package:call_son/core/localization/translation_key_manager.dart';
import 'package:call_son/core/notification_manager/push_notification_service.dart';
import 'package:call_son/core/resources_manager/color_manager.dart';
import 'package:call_son/core/resources_manager/constants_manager.dart';
import 'package:call_son/core/resources_manager/delay_manager.dart';
import 'package:call_son/core/resources_manager/style_manager.dart';
import 'package:call_son/feature/auth/presentation/cubit/get_parent_cubit/get_parent_cubit.dart';
import 'package:call_son/feature/guardian/presentation/cubit/get_nearby_schools/get_nearby_schools_cubit.dart';
import 'package:call_son/feature/guardian/presentation/cubit/get_nearby_schools/get_nearby_schools_state.dart';
import 'package:call_son/feature/guardian/presentation/views/widgets/custom_floating_action_button.dart';
import 'package:call_son/feature/guardian/presentation/views/widgets/school_level_card_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

import 'parent_search_for_school_view.dart';
import 'widgets/custom_drawer.dart';

class ParentsHomeView extends StatelessWidget {
  const ParentsHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      FirebaseFirestore.instance.collection(CollectionManager.parentsCollection)
          .doc(FirebaseAuth.instance.currentUser!.uid).update({'fcmToken': newToken});
    });
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title:  Text(TranslationKeyManager.home.tr),
        leading: IconButton(
          onPressed: () async{
            scaffoldKey.currentState!.openDrawer();
          },
          icon: const Icon(IconlyLight.category),),
      ),
      drawer: CustomDrawer(scaffoldKey: scaffoldKey,),
      floatingActionButton: const CustomFloatingActionButton(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children:
          [
            InkWell(
              onTap: ()
              {
                Get.to(()=> ParentSearchForSchoolView(),
                    duration: const Duration(milliseconds: 500),
                    transition: DelayManager.rightToLeftWithFade);
              },
              child: TextFormField(
                style: StyleManager.regular.copyWith(
                    fontSize: 15.0,
                    color: ColorsManager.primary
                ),
                enabled: false,
                decoration: InputDecoration(
                    labelText: TranslationKeyManager.search.tr,
                    labelStyle: StyleManager.semiBold.copyWith(
                      fontSize: 15.0,
                    ),
                    suffixIcon: const Padding(
                      padding: EdgeInsetsDirectional.only(end:5.0),
                      child: Icon(
                        IconlyLight.search,
                        color: ColorsManager.primary,
                      ),
                    ),
                    errorStyle: StyleManager.regular.copyWith(
                        color: ColorsManager.red),
                    disabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: ColorsManager.grey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: ColorsManager.grey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsetsDirectional.only(start: 10.0)
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            BlocConsumer<GetNearBySchoolsCubit, GetNearBySchoolsState>
              (
              listener: (context, state) {},
              builder: (context, state) {
                if(state is GetNearBySchoolsLoading)
                {
                  return const Center(child: CircularProgressIndicator(),);
                }
                else if(state is GetNearBySchoolsSuccess)
                {
                  return Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                      [
                        Text(TranslationKeyManager.nearBySchools.tr, style: StyleManager.semiBold,),
                        const SizedBox(
                          height: 5,
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: GetNearBySchoolsCubit.get(context).schools.length,
                            itemBuilder: (context, index) => SchoolCardBuilder(school: GetNearBySchoolsCubit.get(context).schools[index],)
                          ),
                        ),
                      ],
                    ),
                  );
                }
                else if(state is GetNearBySchoolsFailure)
                {
                  return Center(child: Text(state.failure.errorMessage),);
                }
                else
                {
                  return const SizedBox();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
