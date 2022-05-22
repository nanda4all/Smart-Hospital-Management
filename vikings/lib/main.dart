// ignore_for_file: avoid_print

import 'dart:io';
import 'package:HMS/shared/components/firebase_fcm.dart';
import 'package:HMS/shared/notificationservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:HMS/presentation/router/app_router.dart';
import 'package:HMS/shared/components/constants.dart';
import 'package:HMS/shared/network/local/cache_helper.dart';
import 'package:HMS/shared/network/remote/dio_helper.dart';

import 'modules/package_doctor/request/request.dart';
import 'shared/local_notifications_service.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseFCM.initialize();
  NotificationService().initNotification();
  HttpOverrides.global = MyHttpOverrides();
  DioHelper.init();
  await CacheHelper.init();
  docId = sharedPreferences.getInt('docId');
  paId = sharedPreferences.getInt('paId');
  hoId = sharedPreferences.getInt('hoId');
  isManager = sharedPreferences.getBool('isManager');
  if (docId != null) {
    isLogin = true;
  } else if (paId != null) {
    isLogin = true;
  } else {
    isLogin = false;
  }
  print(docId);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    // LocalNotificationService.initialize(context);

    return MaterialApp(
      localizationsDelegates: const [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [Locale("ar")],
      locale: const Locale("ar"),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
        accentColor: Colors.blue,
        fontFamily: "Hacen-Algeria",
      ),
      onGenerateRoute: _appRouter.onGenerateRoute,
    );
  }
}
