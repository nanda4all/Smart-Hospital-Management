class LoginPatient {
  late bool status;
  late String? message;
  late PatientData? data;

  LoginPatient.fromJson(Map<String, dynamic> json) {
    status = json["status"] as bool;
    message = json["message"];
    data = json["data"] != null ? PatientData.fromJson(json["data"]) : null;
  }
}

class PatientData {
  late int id;
  late String? name;
    late int hoId;

  PatientData({required this.id, required this.name,required this.hoId});
  PatientData.fromJson(Map<String, dynamic> json) {
    id = json["patientId"] as int;
    name = json["patientName"];
        hoId=json["hospitalId"];

  }
}
