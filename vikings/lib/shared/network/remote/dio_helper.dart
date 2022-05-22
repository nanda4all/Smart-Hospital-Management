// ignore_for_file: avoid_print

import 'package:dio/dio.dart';

class DioHelper {
  static Dio? dio;

  static init() {
    dio = Dio(
      BaseOptions(
          baseUrl:'https://192.168.1.7:44314/',
          receiveDataWhenStatusError: true,
          headers: {
            'Content-Type': 'application/json',
          }),
    );
  }

  static Future<Response> getData(
      {required String urlMethod, Map<String, dynamic>? query}) async {
    return await dio!.get(urlMethod, queryParameters: query);
  }

  static Future<Response> postData(
      {required String url, required Map<String, dynamic> data , Map<String, dynamic>? query}) async {
    var formData = FormData.fromMap(data);
    return await dio!
        .post(
      url,
      data: formData,
      queryParameters: query,
    )
        .catchError((error) {  
      print(error);
    });
  }
}
