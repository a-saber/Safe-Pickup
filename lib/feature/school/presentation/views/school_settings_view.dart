import 'package:call_son/core/cache_helper/cache_data.dart';
import 'package:call_son/core/cache_helper/cache_helper_keys.dart';
import 'package:call_son/core/cache_helper/cashe_helper.dart';
import 'package:call_son/core/localization/translation_key_manager.dart';
import 'package:call_son/core/resources_manager/delay_manager.dart';
import 'package:call_son/core/resources_manager/style_manager.dart';
import 'package:call_son/feature/auth/presentation/cubit/get_school_cubit/get_school_cubit.dart';
import 'package:call_son/feature/auth/presentation/cubit/location/location_cubit.dart';
import 'package:call_son/feature/school/presentation/cubit/get_school_levels_cubit/get_school_levels_cubit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconly/iconly.dart';

import 'school_edit_levels.dart';
import 'school_location_view.dart';
import 'school_profile_view.dart';
import 'widgets/logout_alert.dart';

class SchoolSettingsView extends StatelessWidget {
  const SchoolSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
      [
        SettingItemBuilder(
          icon: IconlyLight.profile,
          title: 'Profile',
          onTap: () {
            Get.to(() => const SchoolProfileView(),
                duration: const Duration(milliseconds: 500),
                transition: DelayManager.rightToLeftWithFade);
          },
        ),
        SettingItemBuilder(
          icon: IconlyLight.category,
          title: 'Levels',
          onTap: () {
            GetSchoolLevelsCubit.get(context).getLevels();

            Get.to(() => const SchoolEditLevels(),
                duration: const Duration(milliseconds: 500),
                transition: DelayManager.rightToLeftWithFade);
          },
        ),
        SettingItemBuilder(
          icon: IconlyLight.location,
          title: 'Location',
          onTap: ()
          {
            LocationCubit.get(context).setLocationToCustom(
                latLng: LatLng(GetSchoolCubit.get(context).schoolModel!.lat!,
                  GetSchoolCubit.get(context).schoolModel!.long!,));
            Get.to(() => const SchoolLocationView(),
                duration: const Duration(milliseconds: 500),
                transition: DelayManager.rightToLeftWithFade);
          },
        ),
        SettingItemBuilder(
          icon: IconlyLight.swap,
          title: 'Language',
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
        SettingItemBuilder(
          icon: IconlyLight.bag,
          title: 'Students',
          onTap: () {},
        ),
        SettingItemBuilder(
          icon: IconlyLight.logout,
          title: 'Logout',
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext ctx) => alertLogout(context),
                barrierDismissible: false);
          },
        ),

      ],
    );
  }
}

class SettingItemBuilder extends StatelessWidget {
  const SettingItemBuilder({super.key,
    required this.icon, required this.title, this.onTap});

  final IconData icon;
  final String title;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children:
          [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Icon(icon,),
            ),
            const SizedBox(width: 10,),
            Text(title, style: StyleManager.semiBold.copyWith(fontSize: 17),),
            const Spacer(),
            const Icon(IconlyLight.arrow_right_2, size: 20,),
          ],
        ),
      ),
    );
  }
}

