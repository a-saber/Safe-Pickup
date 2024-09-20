import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_tts/flutter_tts.dart';
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

  NotificationService notificationService = NotificationService();

  // Initialize the notification service
  await notificationService.init();

  setupForgotPassSingleton();

  runApp(const MyApp());

}


class NotificationService {
  // Instance of FlutterLocalNotificationsPlugin
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // Initialize notification settings
  Future<void> init() async {
    try {
      // Request notification permissions
      await FirebaseMessaging.instance.requestPermission();

      // Get FCM token for debugging or registration
      final fcmToken = await FirebaseMessaging.instance.getToken();
      print('FCM Token: $fcmToken');

      // Initialize flutter_local_notifications
      const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
      const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

      // Initialize local notifications plugin
      await flutterLocalNotificationsPlugin.initialize(initializationSettings);

      // Listen to background messages
      FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);

      // Listen to foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Message received in foreground: ${message.data}');

        if (message.notification != null) {
          print('Notification received: ${message.notification}');
          _showNotification(message.notification!);
        }
      });

      // Handle messages when the app is opened from a notification
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('App opened from a notification: ${message.data}');
      });
    } catch (e) {
      print('Error initializing notifications: ${e.toString()}');
    }
  }

  // Handle background messages
  static Future<void> _backgroundMessageHandler(RemoteMessage message) async {
    print('Handling background message: ${message.messageId}');
    if (message.notification != null) {
      FlutterTts flutterTts = FlutterTts();
      flutterTts.setVolume(1);
      flutterTts.setLanguage('ar');
      await flutterTts.speak('${message.notification!.title} ${message.notification!.body}');
      print('Notification received in background: ${message.notification}');
    }
  }

  // Show a local notification
  Future<void> _showNotification(RemoteNotification notification) async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'channel_id', // ID of the channel
      'channel_name', // Name of the channel
      channelDescription: 'This is the channel description',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      icon: 'notification_icon'
    );
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);

    // Show the notification
    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      notification.title, // Notification title
      notification.body, // Notification body
      notificationDetails,
    );
    FlutterTts flutterTts = FlutterTts();
    flutterTts.setVolume(1);
    flutterTts.setLanguage('ar');
    await flutterTts.speak('${notification.title} ${notification.body}');
  }
}



// Future<void> initNotifications() async
// {
//   try
//   {
//     await FirebaseMessaging.instance.requestPermission();
//     final fcmToken = await FirebaseMessaging.instance.getToken();
//     print('fcmToken: $fcmToken');
//     FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print('Got a message whilst in the foreground!');
//       print('Message data: ${message.data}');
//       if (message.notification != null) {
//         print('Message also contained a notification: ${message.notification}');
//         print('title: ${message.notification!.title}');
//       }
//     });
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print('A new onMessageOpenedApp event was published!');
//       print('Message data: ${message.data}');
//       if (message.notification != null) {
//         print('Message also contained a notification: ${message.notification}');
//         print('title: ${message.notification!.title}');
//       }
//     });
//   }
//   catch(e)
//   {
//     print('error in initNotifications ${e.toString()}');
//   }
// }
//
// // build _backgroundMessageHandler
// Future<void> _backgroundMessageHandler(RemoteMessage message) async
// {
//   print('Handling a background message: ${message.messageId}');
//   print('Message data: ${message.data}');
//   if (message.notification != null) {
//     print('Message also contained a notification: ${message.notification}');
//     print('Message also contained a notification title: ${message.notification!.title}');
//   }
//
// }

