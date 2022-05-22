import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _notificationService = NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  NotificationService._internal();

  Future<void> initNotification() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
    const AndroidInitializationSettings('ic_launcher');

    final IOSInitializationSettings initializationSettingsIOS =
    const IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    final InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showAlertNotification(int id, String title, String body) async {
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      
       NotificationDetails(
        android: AndroidNotificationDetails(
          'main_channel',
          'Main Channel',
          channelDescription: 'Main channel notifications',
          importance: Importance.max,
          priority: Priority.max,
          icon: 'ic_launcher',
          enableVibration: true,
          vibrationPattern: Int64List.fromList([200,100,200,275,425,100,200,100,200,275,425,100,75,25,75,125,75,25,75,125,100,100,200,100,200,275,425,100,200,100,200,275,425,100,75,25,75,125,75,25,75,125,100,100,200,100,200,275,425,100,200,100,200,275,425,100,75,25,75,125,75,25,75,125,100,100,200,100,200,275,425,100,200,100,200,275,425,100,75,25,75,125,75,25,75,125,100,100,200,100,200,275,425,100,200,100,200,275,425,100,75,25,75,125,75,25,75,125,100,100,200,100,200,275,425,100,200,100,200,275,425,100,75,25,75,125,75,25,75,125,100,100,200,100,200,275,425,100,200,100,200,275,425,100,75,25,75,125,75,25,75,125,100,100,200,100,200,275,425,100,200,100,200,275,425,100,75,25,75,125,75,25,75,125,100,100,200,100,200,275,425,100,200,100,200,275,425,100,75,25,75,125,75,25,75,125,100,100,200,100,200,275,425,100,200,100,200,275,425,100,75,25,75,125,75,25,75,125,100,100,200,100,200,275,425,100,200,100,200,275,425,100,75,25,75,125,75,25,75,125,100,100,200,100,200,275,425,100,200,100,200,275,425,100,75,25,75,125,75,25,75,125,100,100,200,100,200,275,425,100,200,100,200,275,425,100,75,25,75,125,75,25,75,125,100,100,200,100,200,275,425,100,200,100,200,275,425,100,75,25,75,125,75,25,75,125,100,100,200,100,200,275,425,100,200,100,200,275,425,100,75,25,75,125,75,25,75,125,100,100,200,100,200,275,425,100,200,100,200,275,425,100,75,25,75,125,75,25,75,125,100,100,]) ,
          largeIcon: const DrawableResourceAndroidBitmap('ic_launcher',),
          // color: Colors.red,
          // colorized: true,

          // styleInformation:  BigTextStyleInformation(
          //   "<div dir=\"rtl\" style=\" background-color:red;padding: 20px 30px;\"><h1 style=\" color:white\">"+title +"</h1><p style=\" color:white\">"+body+"</p></div>",
          //   htmlFormatBigText: true,
          // ),
          styleInformation: BigPictureStyleInformation(const DrawableResourceAndroidBitmap('ic_launcher',),
          contentTitle: "<h1 >"+title +"</h1>",
          htmlFormatContentTitle:  true,
          summaryText:"<h2>"+body+"</h2>" ,
          htmlFormatSummaryText: true,
          hideExpandedLargeIcon: false
          ),
        ),
        iOS: const IOSNotificationDetails(
          sound: 'default.wav',
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}