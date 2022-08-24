import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../firebase_options.dart';
import 'locator.dart';
import 'navigation_service.dart';


/// Add below line in main function
/// Future<void> main() async {
///   await initializeFCM();
///  setupLocator();}

///----------------------Initialize FCM in root widget-------------------------
/// final FcmService fcmService = locator<FcmService>();
///  fcmService.getFCM();


///------------Add Navigator in Meterial app------------------
///   MaterialApp(
///      title: 'Notifications',
///       onGenerateRoute: _routes(),//------------for routing
///       navigatorKey: locator<NavigationService>().navigatorKey,


late AndroidNotificationChannel channel;
bool isFlutterLocalNotificationsInitialized = false;

late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future initializeFCM() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  if (!kIsWeb) {
    await setupFlutterNotifications();
  }
}
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await setupFlutterNotifications();
  // showFlutterNotification(message);
  print('Handling a background message ${message.messageId}');
}
void  onClickNotification(String? payload)  {
  try {
    locator<NavigationService>().navigateTo("/landingPage", payload);
  } catch (e) {
    if (kDebugMode) {
      print("error---------$e");
    }
  }

}
Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  var androidSettings = const AndroidInitializationSettings('launcher_icon');
  var iOSSettings = const IOSInitializationSettings(
    requestSoundPermission: false,
    requestBadgePermission: false,
    requestAlertPermission: false,
  );
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  var initSettings =
      InitializationSettings(android: androidSettings, iOS: iOSSettings);
  await flutterLocalNotificationsPlugin.initialize(initSettings,
      onSelectNotification: (String? payload) async {
    onClickNotification(payload);
  });

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
}

void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null && !kIsWeb) {
    flutterLocalNotificationsPlugin.show(

      payload: jsonEncode(message.notification!.body),
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          // TODO add a proper drawable resource to android, for now using
          //      one that already exists in example app.
          icon: 'launch_background',
        ),
      ),
    );
  }
}

class FcmService {
  final NavigationService _navigationService = locator<NavigationService>();
  Future getFCM() async {
    FirebaseMessaging.onMessage.listen(showFlutterNotification);
    if (Platform.isIOS) {
      FirebaseMessaging.instance.requestPermission();
    }
    FirebaseMessaging.instance.subscribeToTopic("topic");
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("message clicked");
      _serialiseAndNavigate(message);
    });
  }

  Future<void> _serialiseAndNavigate(RemoteMessage message) async {
  await  _navigationService.navigateTo("/landingPage", message);
  }
}
