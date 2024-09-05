import 'package:call_son/core/cache_helper/cache_data.dart';
import 'package:call_son/core/cache_helper/cache_helper_keys.dart';
import 'package:call_son/core/cache_helper/cashe_helper.dart';
import 'package:call_son/core/localization/translation_key_manager.dart';
import 'package:call_son/core/resources_manager/assets_manager.dart';
import 'package:call_son/core/resources_manager/color_manager.dart';
import 'package:call_son/core/resources_manager/delay_manager.dart';
import 'package:call_son/core/resources_manager/style_manager.dart';
import 'package:call_son/feature/auth/presentation/cubit/get_school_cubit/get_school_cubit.dart';
import 'package:call_son/feature/auth/presentation/cubit/get_school_cubit/get_school_state.dart';
import 'package:call_son/feature/auth/presentation/cubit/location/location_cubit.dart';
import 'package:call_son/feature/auth/presentation/views/login_view.dart';
import 'package:call_son/feature/school/presentation/cubit/get_school_levels_cubit/get_school_levels_cubit.dart';
import 'package:call_son/feature/school/presentation/views/school_edit_levels.dart';
import 'package:call_son/feature/school/presentation/views/school_location_view.dart';
import 'package:call_son/feature/school/presentation/views/school_profile_view.dart';
import 'package:call_son/feature/school/presentation/views/widgets/logout_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconly/iconly.dart';

class SchoolCustomDrawer extends StatelessWidget {
  const SchoolCustomDrawer({super.key, required this.scaffoldKey});

  final GlobalKey<ScaffoldState> scaffoldKey;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: BlocConsumer<GetSchoolCubit, GetSchoolState>(
        listener: (context, state)
        {
          if( state is GetSchoolFailure)
          {
            Get.off(()=> const LoginView(),);
          }
        },
        builder: (context, state) {
          if(state is GetSchoolLoading)
          {
            return const Center(child: CircularProgressIndicator());
          }
          else
          {
            return ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(
                    color: ColorsManager.primary,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                            child: SizedBox(
                              height: 60,
                              width: 60,
                              child: Image.asset(
                                AssetsManager.logo,
                                fit: BoxFit.cover,
                                //color: ColorsManager.white,
                              ),
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                              onPressed: (){scaffoldKey.currentState!.closeDrawer();},
                              icon: const Icon(IconlyLight.close_square, color: ColorsManager.white,))
                        ],
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Text(
                                  TranslationKeyManager.hello.tr,
                                  style: StyleManager.medium.copyWith(
                                      fontSize: 15.0,
                                      color: ColorsManager.white
                                  ),
                                ),
                                Builder(
                                    builder: (context) {
                                      return Text(
                                        GetSchoolCubit.get(context).schoolModel!.name ?? '',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: StyleManager.regular.copyWith(
                                            fontSize: 18.0,
                                            color: ColorsManager.white
                                        ),
                                      );
                                    }
                                )
                              ],
                            ),
                          ),
                          IconButton(
                              splashColor: ColorsManager.white,
                              onPressed: ()
                              {
                                Get.to(()=> const SchoolProfileView(),
                                    duration: const Duration(milliseconds: 500),
                                    transition: DelayManager.rightToLeftWithFade);
                              },
                              icon: const Icon(IconlyLight.edit_square, color: ColorsManager.white,)
                          )
                        ],
                      ),
                    ],
                  ),
                ),

                ListTile(
                  leading: const Icon(IconlyLight.home,),
                  title: Text(TranslationKeyManager.home.tr),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(IconlyLight.profile),
                  title:  Text(TranslationKeyManager.profile.tr),
                  onTap: () {
                    Get.to(()=> const SchoolProfileView(),
                        duration: const Duration(milliseconds: 500),
                        transition: DelayManager.rightToLeftWithFade);
                  },
                ),
                ListTile(
                  leading: const Icon(IconlyLight.category),
                  title:  Text(TranslationKeyManager.levels.tr),
                  onTap: () {
                    GetSchoolLevelsCubit.get(context).getLevels();

                    Get.to(() => const SchoolEditLevels(),
                        duration: const Duration(milliseconds: 500),
                        transition: DelayManager.rightToLeftWithFade);
                  },
                ),
                ListTile(
                  leading: const Icon(IconlyLight.location),
                  title:  Text(TranslationKeyManager.location.tr),
                  onTap: () {
                    LocationCubit.get(context).setLocationToCustom(
                        latLng: LatLng(GetSchoolCubit.get(context).schoolModel!.lat!,
                          GetSchoolCubit.get(context).schoolModel!.long!,));
                    Get.to(() => const SchoolLocationView(),
                        duration: const Duration(milliseconds: 500),
                        transition: DelayManager.rightToLeftWithFade);
                  },
                ),
                ListTile(
                  leading: const Icon(IconlyLight.swap),
                  title:  Text(TranslationKeyManager.languages.tr),
                  onTap: () async {
                    if (CacheData.lang == CacheHelperKeys.keyEN) {
                      await CacheHelper.saveData(
                          key: CacheHelperKeys.langKey,
                          value: CacheHelperKeys.keyAR);
                      Get.updateLocale(TranslationKeyManager.localeAR);
                      CacheData.lang = CacheHelperKeys.keyAR;
                    } else {
                      await CacheHelper.saveData(
                          key: CacheHelperKeys.langKey,
                          value: CacheHelperKeys.keyEN);
                      Get.updateLocale(TranslationKeyManager.localeEN);
                      CacheData.lang = CacheHelperKeys.keyEN;
                    }
                  },
                ),

                // ListTile(
                //   leading: const Icon(IconlyLight.setting),
                //   title:  Text(TranslationKeyManager.settings.tr),
                //   onTap: () {
                //     Get.to(()=> const SchoolSettingsView(),
                //         duration: const Duration(milliseconds: 500),
                //         transition: DelayManager.rightToLeftWithFade
                //     );
                //   },
                // ),
                ListTile(
                  leading: const Icon(IconlyLight.logout),
                  title: Text(TranslationKeyManager.logout.tr),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext ctx) => alertLogout(context),
                        barrierDismissible: false); // Close the drawer
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
