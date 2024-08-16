import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'core/app/app.dart';
import 'core/cache_helper/cashe_helper.dart';
import 'core/localization/app_localization.dart';
import 'core/service/service_locator.dart';
import 'firebase_options.dart';


void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await CacheHelper.init();
  await AppLocalization.setLanguage();

  setupForgotPassSingleton();
  runApp(const MyApp());

}
