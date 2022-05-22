class LoginDoctor {
  late bool status;
  late String? message;
  late DoctorData? data;

  LoginDoctor.fromJson(Map<String, dynamic> json) {
    status = json["status"] as bool;
    message = json["message"];
    data = json["data"] != null ? DoctorData.fromJson(json["data"]) : null;
  }
}

class DoctorData {
  late int id;
  late String? name;
  late bool isManager;
  late int hoId;
  DoctorData({required this.id, required this.name, required this.isManager,required this.hoId} );
  DoctorData.fromJson(Map<String, dynamic> json) {
    id = json["doctorId"] as int;
    name = json["doctorName"];
    isManager = json["isManager"];
    hoId=json["hospitalId"];
  }
}
