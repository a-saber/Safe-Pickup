import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/fcm/v1.dart';
import 'core/app/app.dart';
import 'core/cache_helper/cashe_helper.dart';
import 'core/localization/app_localization.dart';
import 'core/notification_manager/push_notification_service.dart';
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

  await initNotifications();

  setupForgotPassSingleton();

  runApp(const MyApp());

}

Future<void> initNotifications() async
{
  try
  {
    await FirebaseMessaging.instance.requestPermission();
    final fcmToken = await FirebaseMessaging.instance.getToken();
    print('fcmToken: $fcmToken');
    FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        print('title: ${message.notification!.title}');
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      print('Message data: ${message.data}');
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        print('title: ${message.notification!.title}');
      }
    });
  }
  catch(e)
  {
    print('error in initNotifications ${e.toString()}');
  }
}

// build _backgroundMessageHandler
Future<void> _backgroundMessageHandler(RemoteMessage message) async
{
  print('Handling a background message: ${message.messageId}');
  print('Message data: ${message.data}');
  if (message.notification != null) {
    print('Message also contained a notification: ${message.notification}');
    print('Message also contained a notification title: ${message.notification!.title}');
  }

}