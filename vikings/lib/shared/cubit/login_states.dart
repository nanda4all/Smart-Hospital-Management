import 'package:HMS/models/login_doctor.dart';
import 'package:HMS/models/login_patient.dart';

abstract class LogInStates {}

class LogInInitialState extends LogInStates {}

class LogInDoctorSuccessState extends LogInStates {
  final LoginDoctor loginModel;

  LogInDoctorSuccessState(this.loginModel);
}
class LogInPateintSuccessState extends LogInStates {
  final LoginPatient loginModel;

  LogInPateintSuccessState(this.loginModel);
}

class LogInLoadingState extends LogInStates {}

class LogInErrorState extends LogInStates {
  final String error;

  LogInErrorState(this.error);
}

class LogInChangeSelectedValueState extends LogInStates {}

class LogInClickedState extends LogInStates {}

class LogInGetHospitalState extends LogInStates {}

class LoadingGetHospitalState extends LogInStates {}

