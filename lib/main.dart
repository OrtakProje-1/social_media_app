

import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:social_media_app/util/const.dart';
import 'package:social_media_app/views/screens/notification_screen/enum/notification_type.dart';
import 'package:social_media_app/views/screens/notification_screen/models/notification_sender.dart';

import 'app.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print(message.notification!.title);
  print('Handling a background message ${message.messageId}');
  await initializeNotification();
  showNotification(message);
}

void showNotification(RemoteMessage message) {
   Map<String, dynamic>? data = message.data;
   print(data);
   NSender sender = NSender.fromMap(data);
   NType nType = NType.values[int.parse(data["nType"])];
   print(sender);
   print(nType);
  RemoteNotification? notification = message.notification;
 if(!kIsWeb){
   print("bildirim oluşturuluyor");
    NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails);
  flutterLocalNotificationsPlugin.show(getIdFromUid(sender.uid!),
      notification!.title, notification.body, notificationDetails,
      payload: JsonEncoder().convert(data));
 }else{
   print("Web de mesaj= "+notification!.title!);
 }
}

AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
  channel.id,
  channel.name,
  channel.description,
  color:kPrimaryColor,
  importance: Importance.max,
  priority: Priority.high,
);

Future<void> selectNotification(String? s) async {
  print("Bildirim seçildi payload= " + s!.toString());
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'com.example.social_media_app',
  'Bildirimler',
  'Bildirim kanalı.',
  importance: Importance.high,
);

Future<void> initializeNotification() async {
  AndroidInitializationSettings androidInitializationSettings =
      AndroidInitializationSettings("app_icon");
  await flutterLocalNotificationsPlugin.initialize(
      InitializationSettings(android: androidInitializationSettings),
      onSelectNotification: selectNotification);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessage.listen(
    (message) {
      print("onData");
      showNotification(message);
    },
    onDone: () {
      print("onDone");
    },
  );

  if (!kIsWeb) {
    await initializeNotification();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }else{
  }

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(MyApp());
}
