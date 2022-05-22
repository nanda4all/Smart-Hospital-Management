import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize(BuildContext context) {
    // initializationSettings for Android
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings("@mipmap-hdpi/ic_launcher"),
    );

    /// TODO initialize method
    _notificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? route) {
      print("onSelectNotification");
      if (route!.isNotEmpty) {
        Navigator.of(context).pushNamed(route);

        print("Router Value: $route");
      }
    });
  }

  static void createAndDisplayNotification(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      NotificationDetails notificationDetails = NotificationDetails();
      // if (message.collapseKey == "Emergency") {
        notificationDetails = const NotificationDetails(
          android: AndroidNotificationDetails(
            // "com.example.flutter_push_notification_app",
            "HMS",
            "HMS",
            importance: Importance.max,
            priority: Priority.high,
            autoCancel: true,
            channelShowBadge: true,
            enableVibration: true,
            playSound: true,
            showWhen: true,
            color: Colors.red,
            fullScreenIntent: true,
            colorized: true,
            enableLights: true,
            // styleInformation: StyleInformation()
          ),
        );
      // } else {
      //   notificationDetails = const NotificationDetails(
      //     android: AndroidNotificationDetails(
      //       // "com.example.flutter_push_notification_app",
      //       "HMS",
      //       "HMS",
      //       importance: Importance.max,
      //       priority: Priority.high,
      //       autoCancel: true,
      //       channelShowBadge: true,
      //       enableVibration: true,
      //       playSound: true,
      //       showWhen: true,
      //     ),
      //   );
      // }

      /// pop up show
      await _notificationsPlugin.show(
        id,
        message.data['title'],
        message.data['body'],
        notificationDetails,
        // payload: message.data["route"],
      );
    } on Exception catch (e) {
      print(e);
    }
  }
}
