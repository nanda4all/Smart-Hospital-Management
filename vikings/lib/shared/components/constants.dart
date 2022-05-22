import 'package:shared_preferences/shared_preferences.dart';

late bool isLogin;
late int? hoId;
late int? docId;
late int? paId;
late bool? isManager=false;
late SharedPreferences sharedPreferences;

List<String> allergies = [
  'حساسية جلدية',
  'حساسية تنفسية',
  'حساسية الفول',
  'حساسية القطط',
  'حساسية جلدية',
  'حساسية تنفسية',
  'حساسية الفول',
  'حساسية القطط',
  'حساسية جلدية',
  'حساسية تنفسية',
  'حساسية الفول',
  'حساسية القطط',
];
