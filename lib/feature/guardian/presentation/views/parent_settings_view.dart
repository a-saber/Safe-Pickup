import 'package:call_son/core/cache_helper/cache_data.dart';
import 'package:call_son/core/cache_helper/cache_helper_keys.dart';
import 'package:call_son/core/cache_helper/cashe_helper.dart';
import 'package:call_son/core/core_widgets/custom_app_bar.dart';
import 'package:call_son/core/localization/translation_key_manager.dart';
import 'package:call_son/feature/school/presentation/views/school_settings_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

class ParentSettingsView extends StatelessWidget {
  const ParentSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: TranslationKeyManager.settings.tr,
        showPopup: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children:
          [
            SettingItemBuilder(
              icon: IconlyLight.swap,
              title: TranslationKeyManager.languages.tr,
              onTap: () async
              {
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
          ],
        ),
      ),
    );
  }
}
