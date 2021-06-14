import 'dart:convert';
import 'dart:io';
import 'package:crypton/crypton.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:social_media_app/util/const.dart';
import 'package:social_media_app/views/screens/notification_screen/models/notification_sender.dart';

import 'app.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("background Message");
  await Firebase.initializeApp();
  await initializeNotification();
  await showNotification(message);
}

Future<void> showNotification(RemoteMessage message) async {
  Map<String, dynamic>? data = message.data;
  String recUid = data["recUid"];
  Directory dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  Box<String> box = await Hive.openBox<String>("keys");
  String privateKey = box.get(recUid) ?? "KeyBoş";
  NSender sender = NSender.fromMap(data);
  RemoteNotification? notification = message.notification;
  String body;
  try {
    RSAPrivateKey prvtKey = RSAPrivateKey.fromString(privateKey);
    body = prvtKey.decrypt(notification!.body ?? "");
  } catch (e) {
    body = notification!.body ?? "";
  }
  if (!kIsWeb) {
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    flutterLocalNotificationsPlugin.show(getIdFromUid(sender.uid!),
        notification.title, body, notificationDetails,
        payload: JsonEncoder().convert(data));
  } else {
    print("Web de mesaj= " + notification.title!);
  }
}

AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
  channel.id,
  channel.name,
  channel.description,
  color: kPrimaryColor,
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
    (message) async {
      print("onData foreground " + message.toString());
      await initializeNotification();
      await showNotification(message);
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
  } else {}

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(MyApp());
}
