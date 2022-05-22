// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print

import 'package:HMS/models/bill.dart';
import 'package:HMS/shared/local_notifications_service.dart';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:HMS/shared/components/constants.dart';
import 'package:HMS/shared/cubit/states.dart';
import 'package:HMS/shared/network/end_points.dart';
import 'package:HMS/shared/network/remote/dio_helper.dart';
import 'package:image_picker/image_picker.dart';

class OurCubit extends Cubit<OurStates> {
  OurCubit() : super(InInitialState());

  static OurCubit get(context) => BlocProvider.of(context);
  var previews;
  var patientForDoctor;
  var surgeries;
  var doctors = [];
  var workDays;
  late DateTime dateOfPreview;
  var paIdForCreatePreview;
  Map<dynamic, dynamic> avalibaleTimeForPreview = {};
  var selectedTimeForPreview;
  bool dateIsValid = false;
  bool isEditTestResult = false;
  bool isEditRayResult = false;
  bool isEditExternalRecords = false;
  Map<dynamic, dynamic> testTypes = {};
  Map<dynamic, dynamic> rayTypes = {};
  Map<dynamic, dynamic> cities = {}; //new
  Map<dynamic, dynamic> areas = {}; //new
  var showAllTests;
  var showAllRays;
  var showAllExternalRecords;
  late int medicalDetailsId;
  Map<int, String?> selectedTestType = {};
  Map<int, String?> selectedRayType = {};
  List<String?> valueOfSelectedTestType = [];
  List<String?> valueOfSelectedRayType = [];
  List<dynamic> allergiesForPatient = [];
  List<dynamic> familyForPatient = [];
  List<dynamic> chronicForPatient = [];
  var medicalDetails;
  var examinations;

  var doctorBirthDate;
  var doctorHireDate;
  String? selectedCity;
  String? selectedArea;
  String? selectedBirthPlace;
  String? selectedGender;
  String? selectedSocialStatus;

  var bills;

  var patientForSurgery;
  Map<dynamic, dynamic> avalibaleTimeForSurgery = {};
  var emptySergeryRooms;
  late DateTime dateOfSurgery;
  Map<int, String?> selectedHourForSurgery = {};
  Map<int, String?> selectedMinuteForSurgery = {};
  Map<int, String?> selectedTimeForSurgery = {};
  var paIdForCreateSurgery;
  var docInfo;
  var paInfo;
  late int patientIdForMedicalDetails;
  Map<dynamic, dynamic> allergies = {};
  Map<int, String?> allergiesSelcted = {};
  Map<dynamic, dynamic> diseasesTypes = {};
  Map<int, String?> diseasesTypesSelctedForFamily = {};
  Map<int, Map<dynamic, dynamic>> diseases = {};
  Map<int, String?> diseasesSelctedForFamily = {};
  Map<int, String?> diseasesSelctedForChronic = {};
  Map<int, String?> diseasesTypesSelctedForChronic = {};
  Map<int, Map<dynamic, dynamic>> diseasesForChronic = {};
  var previewsPatient;
  Map<dynamic, dynamic> departments = {};
  var doctorsForCreatePreview;
  late int docIdForCreatePreview;


  void selectedTestTypes(String? value, int index) {
    selectedTestType[index] = value;
    emit(SelectedTestTypes());
  }

  void selectedRayTypes(String? value, int index) {
    selectedRayType[index] = value;
    emit(SelectedRayTypes());
  }

  void selctedTime(value) {
    selectedTimeForPreview = value;
    emit(SelectedTimeForPreveiw());
  }

  void addtoTestsResult() {
    emit(AddToTestResult());
  }

  void deleteFromTestsResult() {
    emit(DeleteFromTestResult());
  }

  void chossenTestResult() {
    emit(ChossenTestResult());
  }

  void chossenAllergies(String? value, int index) {
    allergiesSelcted[index] = value;
    emit(ChossenAllergies());
  }

  void chossenDiseasesTypes(String? value, int index) {
    diseasesTypesSelctedForFamily[index] = value;
    emit(ChossenDiseasesTypes());
  }

  void chossenDiseasesTypesForChronic(String? value, int index) {
    diseasesTypesSelctedForChronic[index] = value;
    emit(ChossenDiseasesTypes());
  }

  void chossenDiseasesForFamily(String? value, int index) {
    diseasesSelctedForFamily[index] = value;
    emit(ChossenDiseasesByDiseasesTypes());
  }

  void chossenDiseasesForChronic(String? value, int index) {
    diseasesSelctedForChronic[index] = value;
    emit(ChossenDiseasesByDiseasesTypes());
  }

  void editTestResult() {
    isEditTestResult = !isEditTestResult;
    emit(IsEditTestResult());
  }

  Future<void> getTestType() async {
    emit(LoadingGetAllTestTypes());
    DioHelper.getData(urlMethod: getTestTypes).then((value) {
      for (var i = 0; i < value.data.length; i++) {
        testTypes[value.data[i]['testlId'] as int] =
            value.data[i]['testName'] as String;
      }
      emit(SuccessGetAllTestTypes());
    });
  }

  Future<void> getPreviews(int doctorId) async {
    emit(LoadingPreviewsForDoc());
    DioHelper.getData(urlMethod: doctorPreviews, query: {'id': doctorId})
        .then((value) {
      if (value.data['status']) {
        previews = value.data['data']['previews'];
        print(previews);
        emit(SuccesPreviewsForDoc());
      } else {
        if (value.data['active']) {
        emit(EmptyPreviewsForDoc(message: value.data['message'].toString()));
          
        } else {
                  emit(BannedPreviewsForDoc(message: value.data['message'].toString()));

        }
      }
    });
  }

  Future<void> getPatientForDoctor(int doctorId) async {
    emit(LoadingPatientForDoc());
    DioHelper.getData(urlMethod: patientsForDoctor, query: {'id': doctorId})
        .then((value) {
      if (value.data['status']) {
        patientForDoctor = value.data['data']['patients'];
        emit(SuccesPatientForDoc());
      } else {
        if (value.data['active']) {
        emit(EmptyPatientForDoc(message: value.data['message'].toString()));
        } else {
          emit(BannedPatientForDoc(message: value.data['message'].toString()));
        }
      }
    });
  }

  Future<void> getSurgeriesForDoctor(int doctorId) async {
    emit(LoadingSurgeriesForDoc());
    DioHelper.getData(urlMethod: displaySurgeries, query: {'id': docId!})
        .then((value) {
      print(value.data);
      if (value.data['status']) {
        surgeries = value.data['data']['surgeries'];
        print(surgeries);
        emit(SuccesSurgeriesForDoc());
      } else {
        if (value.data['active']) {
        emit(EmptySurgeriesForDoc(message: value.data['message'].toString()));
          
        } else {
          emit(BannedSurgeriesForDoc(message: value.data['message'].toString()));
        }
      }
    });
  }

  Future<void> getDoctors(int docId) async {
    emit(LoadingDoctors());
    DioHelper.getData(urlMethod: getDoctorsInDept, query: {'id': docId})
        .then((value) {
      print(value.data);
      if (value.data['status']) {
        doctors = value.data['data']['doctors'];
        emit(SuccesDoctors());
      } else {
        emit(EmptyDoctors(message: value.data['message'].toString()));
      }
    });
  }

  Future<void> getWorkDaysForDoctor(int doctorId) async {
    emit(LoadingWorkDaysForDoc());
    DioHelper.getData(urlMethod: getWorkDays, query: {'id': doctorId})
        .then((value) {
      if (value.data['status']) {
        workDays = value.data['data']['workDays'];
        emit(SuccesWorkDaysForDoc());
      } else {
        if (value.data['active']) {
        emit(EmptyWorkDaysForDoc(message: value.data['message'].toString()));
          
        } else {
                  emit(BannedWorkDaysForDoc(message: value.data['message'].toString()));

        }
      }
    });
  }

  Future<void> validatePreviewDateForDoctor(
      {required DateTime date,
      required int doctorId,
      required int paId}) async {
    DioHelper.getData(
        urlMethod: validateDateForDoctorPreview,
        query: {'date': date, 'id': doctorId, 'PatId': paId}).then((value) {
      if (value.data['isValid']) {
        if (value.data['empty']) {
          emit(EmptyFreeTimeForCreatePreviewDoctor(
              message: value.data['message'].toString()));
        }
        print(value.data['data']);
        for (var i = 0; i < value.data['key'].length; i++) {
          avalibaleTimeForPreview[value.data['key'][i]]=value.data['value'][i];
        }
        emit(SuccesValidateDateForCreatePreviewDoctor());
      } else {
        emit(FailedValidateDateForCreatePreviewDoctor(
            message: value.data['message'].toString()));
      }
    });
  }

  Future<void> validateTimeForDoctorPreveiws(DateTime date, int paId) async {
    DioHelper.getData(urlMethod: validateTimeForDoctorPreview, query: {
      'date': date,
      'PaId': paId,
    }).then((value) {
      print(value.data);
      if (!value.data['status']) {
        emit(InvalidDatePreviewDoctor(
            message: value.data['message'].toString()));
      }
    });
  }

  Future<void> createPreview({
    required int doctorId,
    required int paId,
    required DateTime date,
  }) async {
    emit(LoadingCreatePreviewDoctor());
    DioHelper.postData(
        url: createPreviewDoctor,
        query: {'date': date},
        data: {'id': doctorId, 'PatId': paId}).then((value) {
      if (value.data['status']) {
        emit(SuccessCreatePreviewDoctor(
            message: value.data['message'].toString()));
      }
    }).catchError((error) {
      print(error.toString());
    });
  }

  Future<void> uploadPhoto(
      {required List<XFile> testsResult,
      required List<DateTime> dates,
      required int medicalId}) async {
    emit(LoadingUploadPhoto());
    List<MultipartFile> files = [];
    for (var img in testsResult) {
      files.add(await MultipartFile.fromFile(img.path));
    }
    var objToSend = {
      "files": files,
    };

    await DioHelper.postData(url: uploadTestResults, data: objToSend, query: {
      'dates': dates,
      'type': valueOfSelectedTestType,
      'medicalId': medicalId
    }).then((value) {
      if (value.data['status']) {
        emit(SuccessUploadPhoto(message: value.data['message'].toString()));
      } else {
        emit(ErrorUploadPhoto(message: value.data['message'].toString()));
      }
    }).catchError((onError) {
      print(onError.toString());
    });
  }

  Future<void> uploadPhotoRays(
      {required List<XFile> rayResult,
      required List<DateTime> dates,
      required int medicalId}) async {
    emit(LoadingUploadPhoto());
    List<MultipartFile> files = [];
    for (var img in rayResult) {
      files.add(await MultipartFile.fromFile(img.path));
    }
    var objToSend = {
      "files": files,
    };

    await DioHelper.postData(url: uploadRayResults, data: objToSend, query: {
      'dates': dates,
      'type': valueOfSelectedRayType,
      'medicalId': medicalId
    }).then((value) {
      if (value.data['status']) {
        emit(SuccessUploadPhoto(message: value.data['message'].toString()));
      } else {
        emit(ErrorUploadPhoto(message: value.data['message'].toString()));
      }
    }).catchError((onError) {
      print(onError.toString());
    });
  }

  Future<void> uploadPhotoExternalRecords(
      {required List<XFile> externalRecords, required int medicalId}) async {
    emit(LoadingUploadPhoto());
    List<MultipartFile> files = [];
    for (var img in externalRecords) {
      files.add(await MultipartFile.fromFile(img.path));
    }
    var objToSend = {
      "files": files,
    };

    await DioHelper.postData(
        url: uploadExternalRecords,
        data: objToSend,
        query: {'medicalId': medicalId}).then((value) {
      if (value.data['status']) {
        emit(SuccessUploadPhoto(message: value.data['message'].toString()));
      } else {
        emit(ErrorUploadPhoto(message: value.data['message'].toString()));
      }
    }).catchError((onError) {
      print(onError.toString());
    });
  }

  Future<void> showTest(int medicalId) async {
    emit(LoadingAllTests());
    await DioHelper.getData(urlMethod: displayTests, query: {
      'medicalId': medicalId,
    }).then((value) {
      showAllTests = value.data;
      emit(SuccessAllTests());
    });
  }

  Future<void> showRay(int medicalId) async {
    emit(LoadingAllRays());
    await DioHelper.getData(urlMethod: displayRays, query: {
      'medicalId': medicalId,
    }).then((value) {
      showAllRays = value.data;
      emit(SuccessAllRays());
    });
  }

  Future<void> showExternalRecords(int medicalId) async {
    emit(LoadingAllExternalRecords());
    await DioHelper.getData(urlMethod: displayExternalRecords, query: {
      'medicalId': medicalId,
    }).then((value) {
      showAllExternalRecords = value.data;
      emit(SuccessAllExternalRecords());
    });
  }

  Future<void> getMedicalDetailsForDoctor(int id, int paId) async {
    emit(LoadingGetMedicalDetails());
    await DioHelper.getData(
        urlMethod: showMedicalDetailsForDoctor,
        query: {'id': id, 'PaId': paId}).then((value) {
      if (value.data['status']) {
        medicalDetails = value.data['data'];
        allergiesForPatient = value.data['allegies'];
        familyForPatient = value.data['family'];
        chronicForPatient = value.data['chronic'];
        examinations = value.data['exam'];
        emit(SuccessGetMedicalDetails());
        print(allergiesForPatient);
        print(familyForPatient);
      } else {
        emit(ErrorGetMedicalDetails(
          message: value.data['message'].toString(),
          paId: value.data['paId']
          ));
      }
    });
  }

  Future<void> getMedicalDetailsForPatient(int paId) async {
    emit(LoadingGetMedicalDetails());
    await DioHelper.getData(
        urlMethod: showMedicalDetailsForPatient,
        query: {'id': paId}).then((value) {
      if (value.data['status']) {
        medicalDetails = value.data['data'];
        allergiesForPatient = value.data['allegies'];
        familyForPatient = value.data['family'];
        chronicForPatient = value.data['chronic'];
        examinations = value.data['exam'];
        emit(SuccessGetMedicalDetails());
        print(allergiesForPatient);
        print(familyForPatient);
      } else {
        print(value.data);
        emit(ErrorGetMedicalDetailsForPatient(message: value.data['message'].toString()));
      }
    });
  }

  void addtoRayResult() {
    emit(AddToRayResult());
  }

  void deleteFromRayResult() {
    emit(DeleteFromRayResult());
  }

  void chossenRayResult() {
    emit(ChossenRayResult());
  }

  void editRayResult() {
    isEditRayResult = !isEditRayResult;
    emit(IsEditRays());
  }

  Future<void> getRayType() async {
    emit(LoadingGetAllRayTypes());
    DioHelper.getData(urlMethod: getRayTypes).then((value) {
      for (var i = 0; i < value.data.length; i++) {
        rayTypes[value.data[i]['rayId'] as int] =
            value.data[i]['rayName'] as String;
      }
      emit(SuccessGetAllRayTypes());
    });
  }

  void addToExternalRecords() {
    emit(AddToExternalRecords());
  }

  void deleteFromExternalRecords() {
    emit(DeleteFromExternalRecords());
  }

  void editExternalRecords() {
    isEditExternalRecords = !isEditExternalRecords;
    emit(IsEditExternalRecords());
  }

  void chossenExternalRecords() {
    emit(ChossenExternalRecords());
  }

  Future<void> getAllCities() async {
    emit(LoadingCities());
    cities.clear();
    DioHelper.getData(urlMethod: getCities).then((value) {
      for (var i = 0; i < value.data.length; i++) {
        cities[value.data[i]['cityId'] as int] =
            value.data[i]['cityName'] as String;
      }
      emit(SuccessLoadingCities());
    });
  }

  Future<void> getAllAreas() async {
    emit(LoadingAreas());
    areas.clear();
    DioHelper.getData(
        urlMethod: getAreas,
        query: {'id': int.parse(selectedCity!)}).then((value) {
      for (var i = 0; i < value.data.length; i++) {
        areas[value.data[i]['id'] as int] =
            value.data[i]['name'] as String;
      }
      emit(SuccessLoadingAreas());
    });
  }

  void selctedHourForSurgery(String? value, int index) {
    selectedHourForSurgery[index] = value;
    emit(SelectedHourForSurgery());
  }

  void selctedMinuteForSurgery(String? value, int index) {
    selectedMinuteForSurgery[index] = value;
    emit(SelectedMinuteForSurgery());
  }

  void selctedTimeForSurgery(String? value, int index) {
    selectedTimeForSurgery[index] = value;
    emit(SelectedTimeForSurgery());
  }

  void selectBirthPlace(String? value) {
    selectedBirthPlace = value;
    emit(SelectedBirthPlaceForAddDoctor());
  }

  void selectArea(String? value) {
    selectedArea = value;
    emit(SelectedAreaForAddDoctor());
  }

  void selectCity(String? value) {
    selectedCity = value;
    emit(SelectedCityForAddDoctor());
    getAllAreas();
  }

  void selcteGender(value) {
    selectedGender = value;
    emit(SelectedGenderForAddDoctor());
  }

  void selecteSocialStatus(value) {
    selectedSocialStatus = value;
    emit(SelectedSocialStatusForAddDoctor());
  }

  void selecteBirthDate(value) {
    doctorBirthDate = value;
    emit(SelectedBirthDateForAddDoctor());
  }

  void selecteHireDate(value) {
    doctorHireDate = value;
    emit(SelectedHireDateForAddDoctor());
  }

  void addPhoneNuber() {
    emit(AddPhoneNumberForAddDoctor());
  }

  void removePhoneNuber() {
    emit(RemovePhoneNumberForAddDoctor());
  }

  Future<void> addDoctor({
    required String firstName,
    required String lastName,
    required String middleName,
    required String email,
    required String nationalNumber,
    required String? familyMembers,
    required String qualifications,
    required List<String>? phoneNumbers,
  }) async {
    emit(LoadingCreateDoctor());
    DioHelper.postData(
      url: createDoctor,
      query: {
        'birthDate': doctorBirthDate,
        'hireDate': doctorHireDate,
        'phone': phoneNumbers,
      },
      data: {
        'id': docId,
        'firstName': firstName,
        'middleName': middleName,
        'lastName': lastName,
        'email': email,
        'nationalNumber': nationalNumber,
        'gender': selectedGender,
        'socialStatus': selectedSocialStatus,
        'familyMembers': familyMembers,
        'birthPlace': selectedBirthPlace,
        'livesIn': selectedArea,
        'qualifications': qualifications,
      },
    ).then((value) {
      print(value.data);
      if (value.data['status']) {
        emit(SuccessCreateDoctor(message: value.data['message'].toString()));
      }
    }).catchError((error) {
      print(error.toString());
    });
  }

  Future<void> getBills() async {
    emit(LoadingBills());
    DioHelper.getData(urlMethod: showBills, query: {'id': paId}).then((value) {
      if (value.data['status']) {
        print(value.data['data']);
        bills = value.data['data'];
        emit(SuccesBills());
      } else {
        emit(EmptyBills(message: value.data['message'].toString()));
      }
    });
  }

  Future<void> deletePreviewForDoc({required String prevId}) async {
    emit(LoadingDeletingPreview());
    DioHelper.getData(
        urlMethod: deletePreviewDoc,
        query: {'id': int.parse(prevId)}).then((value) {
      if (value.data['status']) {
        print(value.data['message']);
        emit(SuccesDeletingPreview(
          status: true,
          message: value.data['message'],
        ));
        getPreviews(docId!);
      } else {
        emit(FaileDeletingPreview(
            status: true, message: value.data['message'].toString()));
      }
    });
  }

  Future<void> deleteSurgeryForDoc({required String id}) async {
    emit(LoadingDeletingSurgery());
    DioHelper.getData(urlMethod: deleteSurgeryDoc, query: {'id': int.parse(id)})
        .then((value) {
      if (value.data['status']) {
        print(value.data['message']);
        emit(SuccesDeletingSurgery(
          status: true,
          message: value.data['message'],
        ));
        getPreviews(docId!);
      } else {
        emit(FaileDeletingSurgery(
            status: true, message: value.data['message'].toString()));
      }
    });
  }

  Future<void> displayEmptySurgeryRoom(int hoID) async {
    emit(LoadingDisplayEmptySurgeryRoom());
    await DioHelper.getData(urlMethod: showEmptySurgeryRoom, query: {
      'HoId': hoID,
    }).then((value) {
      if (value.data['status']) {
        emptySergeryRooms = value.data['data'];
        emit(SuccessDisplayEmptySurgeryRoom());
      } else {
        emit(ErrorDisplayEmptySurgeryRoom(
            message: value.data['message'].toString()));
      }
    });
  }

  Future<void> displayAvalibalTimeForSurgery(
      {required DateTime date,
      required srId,
      required String? hour,
      required String? minute}) async {
    emit(LoadingGetAvalibaleTimeForSurgery());
    await DioHelper.getData(urlMethod: AvalibaleTimeForSurgery, query: {
      'date': date,
      'Sr_Id': srId,
      'hour': hour,
      'minute': minute,
    }).then((value) {
      if (value.data['status']) {
        for (var i = 0; i < value.data['key'].length; i++) {
          avalibaleTimeForSurgery[value.data['key'][i]] =
              value.data['value'][i];
          emit(SuccessGetAvalibaleTimeForSurgery());
        }
      } else {
        emit(ErrorGetAvalibaleTimeForSurgery(
            message: value.data['message'].toString()));
      }
    });
  }

  Future<void> displayPatientForSurgery(int hoId) async {
    emit(LoadingPatientForSurgery());
    await DioHelper.getData(
        urlMethod: showPatientForSurgery, query: {'HoId': hoId}).then((value) {
      if (value.data['status']) {
        patientForSurgery = value.data['data'];
        emit(SuccesPatientForSurgery());
      } else {
        emit(EmptyPatientForSurgery(message: value.data['message'].toString()));
      }
    });
  }

  Future<void> createSurgery(
      {required int doctorId,
      required int paId,
      required int srId,
      required DateTime date,
      required String name,
      required String hour,
      required String minute}) async {
    emit(LoadingCreateSurgeryDoctor());
    await DioHelper.postData(url: createSurgeryDoctor, query: {
      'date': date
    }, data: {
      'id': doctorId,
      'PatId': paId,
      'srId': srId,
      'hour': hour,
      'minute': minute,
      'name': name,
    }).then((value) {
      if (value.data['status']) {
        emit(SuccessCreateSurgeryDoctor(
            message: value.data['message'].toString()));
      }
      else if (value.data['active']) {
        emit(BannedCreateSurgeryDoctor(message: value.data['message'].toString()));
      }
    }).catchError((error) {
      print(error.toString());
    });
  }

  Future<void> getPersonalInfoDoctor(int docId) async {
    emit(LoadingGetPersonalInfo());
    await DioHelper.getData(urlMethod: personalInfoDoctor, query: {'id': docId})
        .then((value) {
      docInfo = value.data['data'];
      for (var i = 0; i < value.data['cities'].length; i++) {
        cities[value.data['cities'][i]['id'] as int] =
            value.data['cities'][i]['name'] as String;
      }
      for (var i = 0; i < value.data['data'][0]['areas'].length; i++) {
        areas[value.data['data'][0]['areas'][i]['id'] as int] =
            value.data['data'][0]['areas'][i]['name'] as String;
      }
      emit(SuccesGetPersonalInfo());
    });
  }

Future<void> displayAreasByCityId(cityId) async {
    emit(LoadingDisplayAreasByCityId());
    await DioHelper.getData(urlMethod: areasByCityId, query: {'id': cityId})
        .then((value) {
      for (var i = 0; i < value.data.length; i++) {
        areas[value.data[i]['id'] as int] = value.data[i]['name'] as String;
      }
      emit(SuccessDisplayAreasByCityId());
    });
  }

Future<void> editPersonalInfoDoctor(
      {required int docId,
      required String socialDropdownValue,
      required String familyMembers,
      required String qualifications,
      required List<String> phones,
      required String dropdownValueArea}) async {
    emit(LoadingEditPerosnal());
    await DioHelper.postData(url: setPersonalInfoDoctor, query: {
      'phones': phones
    }, data: {
      'id': docId,
      'social': socialDropdownValue,
      'family': familyMembers,
      'qual': qualifications,
      'area': dropdownValueArea
    }).then((value) {
      emit(SuccessEditPerosnal(message: value.data['message'].toString()));
    }).catchError((error) {
      print(error.toString());
    });
  }

 Future<void> getPersonalInfoPatient(int paId) async {
    emit(LoadingGetPersonalInfo());
    await DioHelper.getData(urlMethod: personalInfoPatient, query: {'id': paId})
        .then((value) {
      print(value.data);
      paInfo = value.data['data'];
      for (var i = 0; i < value.data['cities'].length; i++) {
        cities[value.data['cities'][i]['id'] as int] =
            value.data['cities'][i]['name'] as String;
      }
      for (var i = 0; i < value.data['data'][0]['areas'].length; i++) {
        areas[value.data['data'][0]['areas'][i]['id'] as int] =
            value.data['data'][0]['areas'][i]['name'] as String;
      }
      emit(SuccesGetPersonalInfo());
    });
  }

Future<void> editPersonalInfoPatient(
      {required int paId,
      required String socialDropdownValue,
      required List<String> phones,
      required String dropdownValueArea}) async {
    emit(LoadingEditPerosnal());
    await DioHelper.postData(url: setPersonalInfoPatient, query: {
      'phones': phones
    }, data: {
      'id': paId,
      'social': socialDropdownValue,
      'area': dropdownValueArea
    }).then((value) {
      emit(SuccessEditPerosnal(message: value.data['message'].toString()));
    }).catchError((error) {
      print(error.toString());
    });
  }
  Future<void> sendNurseRequest()async{
    emit(LoadingRequestNurse());
    await DioHelper.getData(urlMethod: sendingNurseRequest,query: {'id':paId})
    .then((value) {
      emit(SuccessRequestNurse(message: value.data['message'].toString()));
    }).catchError((error){
      emit(ErrorRequestNurse(message: 'فشل الاتصال'));
      print(error.toString());
    });
  }

  Future<void> createMedicalDetails({
    required int paId,
    required String bloodType,
    required String plans,
    required String needs,
    required List<String> allAllergies,
    required List<String> family,
    required List<String> chronic,
  }) async {
    await DioHelper.postData(url: createMeidcal, query: {
      'allergies': allAllergies,
      'family': family,
      'chronic': chronic
    }, data: {
      'paId': paId,
      'blood': bloodType,
      'plan': plans,
      'need': needs,
    }).then((value) {
      emit(SuccessCreateMedicalDetails(
          message: value.data['message'].toString()));
    }).catchError((error) {
      print(error.toString());
    });
  }

Future<void> displayAllAllergies() async {
    emit(LoadingShowAllAllergies());
    await DioHelper.getData(
      urlMethod: showAllAllergies,
    ).then((value) {
      for (var i = 0; i < value.data.length; i++) {
        allergies[value.data[i]['id'] as int] = value.data[i]['name'] as String;
      }
      emit(SuccessShowAllAllergies());
    });
  }  

Future<void> displayDiseasesTypes() async {
    emit(LoadingDisplayDiseasesTypes());
    await DioHelper.getData(
      urlMethod: showDiseasesTypes,
    ).then((value) {
      for (var i = 0; i < value.data.length; i++) {
        diseasesTypes[value.data[i]['id'] as int] =
            value.data[i]['name'] as String;
      }
      emit(SuccessDisplayDiseasesTypes());
    });
  }

  Future<void> displayDiseasesByDiseasesTypes(
      String diseaseTypeId, int index) async {
    emit(LoadingDisplayDiseasesByDiseasesTypes());
    await DioHelper.getData(
        urlMethod: showDiseasesByDiseasesTypes,
        query: {'id': diseaseTypeId}).then((value) {
      Map<dynamic, dynamic> temp = {};
      for (var i = 0; i < value.data.length; i++) {
        temp[value.data[i]['id'] as int] = value.data[i]['name'] as String;
        diseases[index] = temp;
      }
      emit(SuccessDisplayDiseasesByDiseasesTypes());
    });
  }

  Future<void> displayDiseasesByDiseasesTypesForChronic(
      String diseaseTypeId, int index) async {
    emit(LoadingDisplayDiseasesByDiseasesTypes());
    await DioHelper.getData(
        urlMethod: showDiseasesByDiseasesTypes,
        query: {'id': diseaseTypeId}).then((value) {
      Map<dynamic, dynamic> temp = {};
      for (var i = 0; i < value.data.length; i++) {
        temp[value.data[i]['id'] as int] = value.data[i]['name'] as String;
        diseasesForChronic[index] = temp;
      }
      emit(SuccessDisplayDiseasesByDiseasesTypes());
    });
  }

  Future<void> updateMedicalDetails({
    required int medicalId,
    required String bloodType,
    required String plans,
    required String needs,
    required List<String> allAllergies,
    required List<String> family,
    required List<String> chronic,
  }) async {
    await DioHelper.postData(url: updateMeidcal, query: {
      'allergies': allAllergies,
      'family': family,
      'chronic': chronic
    }, data: {
      'medicalId': medicalId,
      'blood': bloodType,
      'plan': plans,
      'need': needs,
    }).then((value) {
      emit(SuccessUpdateMedicalDetails(
          message: value.data['message'].toString()));
    }).catchError((error) {
      print(error.toString());
    });
  }

  Future<void> getPreviewsForPatient(int paId, int hoId) async {
    emit(LoadingPreviews());
    await DioHelper.getData(
        urlMethod: showPreviewsForPatient,
        query: {'id': paId, 'Ho_Id': hoId}).then((value) {
      if (value.data['status']) {
        previewsPatient = value.data['data']['previews'];
        emit(SuccesPreviews());
      } else {
        emit(EmptyPreviews(message: value.data['message'].toString()));
      }
    });
  }

  Future<void> displayDepartmentForCreatePreview(hoId) async {
    emit(LoadingDisplayDepartmentForCreatePreview());
    await DioHelper.getData(
        urlMethod: showDepartmentForCreatePreview,
        query: {'Ho_Id': hoId}).then((value) {
      for (var i = 0; i < value.data.length; i++) {
        departments[value.data[i]['id'] as int] =
            value.data[i]['name'] as String;
      }
      emit(SuccessDisplayDepartmentForCreatePreview());
    });
  }

  Future<void> displayDoctorsForCreatePreview(deptId) async {
    emit(LoadingDisplayDoctorForCreatePreview());
    await DioHelper.getData(
        urlMethod: showDoctorForCreatePreview,
        query: {'Dept_Id': deptId}).then((value) {
      print(value.data);
      doctorsForCreatePreview = value.data['doctors'];
      emit(SuccessDisplayDoctorForCreatePreview());
    });
  }

  Future<void> validatePreviewDateForPatient(
      {required DateTime date,
      required int doctorId,
      required int paId}) async {
    await DioHelper.getData(
        urlMethod: validateDateForPatientPreview,
        query: {'date': date, 'id': paId, 'DocId': doctorId}).then((value) {
      if (value.data['isValid']) {
        if (value.data['empty']) {
          emit(EmptyFreeTimeForCreatePreviewDoctor(
              message: value.data['message'].toString()));
        }
        for (var i = 0; i < value.data['key'].length; i++) {
          avalibaleTimeForPreview[value.data['key'][i]] =
              value.data['value'][i];
          emit(SuccessGetAvalibaleTimeForSurgery());
        }
        emit(SuccesValidateDateForCreatePreviewDoctor());
      } else {
        emit(FailedValidateDateForCreatePreviewDoctor(
            message: value.data['message'].toString()));
      }
    });
  }

  Future<void> validateTimeForPatientPreveiws(DateTime date, int paId) async {
    await DioHelper.getData(urlMethod: validateTimeForPatientPreview, query: {
      'date': date,
      'PaId': paId,
    }).then((value) {
      if (!value.data['status']) {
        emit(InvalidDatePreviewDoctor(
            message: value.data['message'].toString()));
      }
    });
  }
  Future<void> getMedicalDetailsForUpdate(int id, int medicalId) async {
    emit(LoadingGetMedicalDetails());
    await DioHelper.getData(
        urlMethod: showMedicalDetailsForUpdate,
        query: {'id': id, 'medicalId': medicalId}).then((value) {
      if (value.data['status']) {
        medicalDetails = value.data['data'];
        allergiesForPatient = value.data['allegies'];
        familyForPatient = value.data['family'];
        chronicForPatient = value.data['chronic'];
        emit(SuccessGetMedicalDetailsForUpdate());
        print(value.data);
        print(familyForPatient);
        print(chronicForPatient);
        print(allergiesForPatient);
      } else {
        emit(ErrorGetMedicalDetails(
            message: value.data['message'].toString(),
            paId: value.data['paId']));
      }
    });
  }

}
