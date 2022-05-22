// ignore_for_file: file_names

import 'package:HMS/shared/components/firebase_fcm.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseFCM.context=context;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff92cbdf),
        elevation: 0.0,
      ),
      body: Container(
        color: const Color(0xff92cbdf),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.025,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed('/LoginDoc');
                    },
                    child: const CircleAvatar(
                      radius: 70,
                      backgroundImage:
                          AssetImage('lib/assets/images/doctor.jpg'),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "دكتور",
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () async {
                      
                      Navigator.of(context).pushNamed("/LoginPa");
                      FirebaseMessaging messaging = FirebaseMessaging.instance;

                      NotificationSettings settings =
                          await messaging.requestPermission(
                        alert: true,
                        announcement: false,
                        badge: true,
                        carPlay: false,
                        criticalAlert: false,
                        provisional: false,
                        sound: true,
                      );

                      print(
                          'User granted permission: ${settings.authorizationStatus}');
                                    await FirebaseMessaging.instance.subscribeToTopic("Huda");

                    },
                    child: const CircleAvatar(
                      radius: 70,
                      backgroundImage: AssetImage('lib/assets/images/man.png'),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "مريض",
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
