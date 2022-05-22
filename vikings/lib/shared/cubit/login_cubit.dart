// ignore_for_file: avoid_print

import 'package:HMS/shared/local_notifications_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:HMS/models/login_doctor.dart';
import 'package:HMS/models/login_patient.dart';
import 'package:HMS/shared/cubit/login_states.dart';
import 'package:HMS/shared/network/end_points.dart';
import 'package:HMS/shared/network/remote/dio_helper.dart';

class LoginCubit extends Cubit<LogInStates> {
  LoginCubit() : super(LogInInitialState());
  static LoginCubit get(context) => BlocProvider.of(context);

  Map<dynamic, dynamic> hospitals = {};
  late LoginDoctor loginDoctorModel;
  late LoginPatient loginPatientModel;
  String? selectedValue;
  bool click = true;

  Future<void> getHospital() async {
    emit(LoadingGetHospitalState());
    DioHelper.getData(urlMethod: loginForDoctor).then((value) {
      for (var i = 0; i < value.data.length; i++) {
        hospitals[value.data[i]['hospitalId'] as int] =
            value.data[i]['hospitalName'] as String;
      }
      print(hospitals);
      emit(LogInGetHospitalState());
    });
  }

  Future<void> userLoginDoctor({
    required String email,
    required String password,
    required String hoId,
  }) async {
    emit(LogInLoadingState());
    final fcmToken = await FirebaseMessaging.instance.getToken();
    print(fcmToken);
    await FirebaseMessaging.instance.subscribeToTopic("Huda");

    DioHelper.postData(url: loginForDoctor, data: {
      'email': email,
      'password': password,
      'HoId': hoId,
      'fcmToken': fcmToken
    }).then((value) {
      loginDoctorModel = LoginDoctor.fromJson(value.data);
      emit(LogInDoctorSuccessState(loginDoctorModel));
    }).catchError((error) {
      emit(LogInErrorState(error.toString()));
      print(error.toString());
    });
  }

  Future<void> userLoginPatient({
    required String email,
    required String password,
    required String hoId,
  }) async {
    emit(LogInLoadingState());
    final fcmToken = await FirebaseMessaging.instance.getToken();
    print(fcmToken);
    DioHelper.postData(url: loginForPatient, data: {
      'email': email,
      'password': password,
      'HoId': hoId,
      'fcmToken': fcmToken
    }).then((value) {
      print(value.data);
      loginPatientModel = LoginPatient.fromJson(value.data);
      emit(LogInPateintSuccessState(loginPatientModel));
    }).catchError((error) {
      emit(LogInErrorState(error.toString()));
      print(error.toString());
    });
  }

  void selected(value) {
    selectedValue = value;
    emit(LogInChangeSelectedValueState());
  }

  void clicked() {
    click = !click;
    emit(LogInClickedState());
  }
}
