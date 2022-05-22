abstract class OurStates {}

class InInitialState extends OurStates {}

class LoadingPreviewsForDoc extends OurStates {}

class EmptyPreviewsForDoc extends OurStates {
  String message;
  EmptyPreviewsForDoc({
    required this.message,
  });
}
class BannedPreviewsForDoc extends OurStates {
  String message;
  BannedPreviewsForDoc({
    required this.message,
  });
}

class SuccesPreviewsForDoc extends OurStates {}

class LoadingPatientForDoc extends OurStates {}

class SuccesPatientForDoc extends OurStates {}

class EmptyPatientForDoc extends OurStates {
  String message;
  EmptyPatientForDoc({
    required this.message,
  });
}
class BannedPatientForDoc extends OurStates {
  String message;
  BannedPatientForDoc({
    required this.message,
  });
}

class LoadingSurgeriesForDoc extends OurStates {}

class EmptySurgeriesForDoc extends OurStates {
  String message;
  EmptySurgeriesForDoc({
    required this.message,
  });
}
class BannedSurgeriesForDoc extends OurStates {
  String message;
  BannedSurgeriesForDoc({
    required this.message,
  });
}

class SuccesSurgeriesForDoc extends OurStates {}

class LoadingWorkDaysForDoc extends OurStates {}

class SuccesWorkDaysForDoc extends OurStates {}

class EmptyWorkDaysForDoc extends OurStates {
  String message;
  EmptyWorkDaysForDoc({
    required this.message,
  });
}
class BannedWorkDaysForDoc extends OurStates {
  String message;
  BannedWorkDaysForDoc({
    required this.message,
  });
}

class SuccesValidateDateForCreatePreviewDoctor extends OurStates {}

class FailedValidateDateForCreatePreviewDoctor extends OurStates {
  String message;
  FailedValidateDateForCreatePreviewDoctor({
    required this.message,
  });
}

class EmptyFreeTimeForCreatePreviewDoctor extends OurStates {
  String message;
  EmptyFreeTimeForCreatePreviewDoctor({
    required this.message,
  });
}

class SelectedTimeForPreveiw extends OurStates {}

class LoadingCreatePreviewDoctor extends OurStates {}

class SuccessCreatePreviewDoctor extends OurStates {
  String message;
  SuccessCreatePreviewDoctor({
    required this.message,
  });
}

class InvalidDatePreviewDoctor extends OurStates {
  String message;
  InvalidDatePreviewDoctor({
    required this.message,
  });
}

class AddToTestResult extends OurStates {}

class DeleteFromTestResult extends OurStates {}

class ChossenTestResult extends OurStates {}

class IsEditTestResult extends OurStates {}

class SelectedTestTypes extends OurStates {}

class LoadingGetAllTestTypes extends OurStates {}

class SuccessGetAllTestTypes extends OurStates {}

class LoadingAllTests extends OurStates {}

class SuccessAllTests extends OurStates {}

class LoadingUploadPhoto extends OurStates {}

class SuccessUploadPhoto extends OurStates {
  String message;
  SuccessUploadPhoto({
    required this.message,
  });
}

class ErrorUploadPhoto extends OurStates {
  String message;
  ErrorUploadPhoto({
    required this.message,
  });
}

class LoadingGetMedicalDetails extends OurStates {}

class SuccessGetMedicalDetails extends OurStates {}

class ErrorGetMedicalDetails extends OurStates {
  String message;
  int paId;
  ErrorGetMedicalDetails({
    required this.message,
    required this.paId
  });
}

class ErrorGetMedicalDetailsForPatient extends OurStates {
  String message;
  ErrorGetMedicalDetailsForPatient({
    required this.message,
  });
}

class AddToRayResult extends OurStates {}

class DeleteFromRayResult extends OurStates {}

class ChossenRayResult extends OurStates {}

class IsEditRays extends OurStates {}

class SelectedRayTypes extends OurStates {}

class LoadingGetAllRayTypes extends OurStates {}

class SuccessGetAllRayTypes extends OurStates {}

class LoadingAllRays extends OurStates {}

class SuccessAllRays extends OurStates {}

class AddToExternalRecords extends OurStates {}

class DeleteFromExternalRecords extends OurStates {}

class ChossenExternalRecords extends OurStates {}

class IsEditExternalRecords extends OurStates {}

class LoadingAllExternalRecords extends OurStates {}

class SuccessAllExternalRecords extends OurStates {}

class LoadingDoctors extends OurStates {}

class SuccesDoctors extends OurStates {}

class EmptyDoctors extends OurStates {
  String message;
  EmptyDoctors({
    required this.message,
  });
}

class FailedValidateDoctor extends OurStates {
  String message;
  FailedValidateDoctor({
    required this.message,
  });
}

class LoadingCities extends OurStates {}

class LoadingAreas extends OurStates {}

class SuccessLoadingCities extends OurStates {}

class SuccessLoadingAreas extends OurStates {}

class SelectedAreaForAddDoctor extends OurStates {}

class SelectedCityForAddDoctor extends OurStates {}

class SelectedBirthPlaceForAddDoctor extends OurStates {}

class SelectedGenderForAddDoctor extends OurStates {}

class SelectedSocialStatusForAddDoctor extends OurStates {}

class AddPhoneNumberForAddDoctor extends OurStates {}

class RemovePhoneNumberForAddDoctor extends OurStates {}

class SelectedBirthDateForAddDoctor extends OurStates {}

class SelectedHireDateForAddDoctor extends OurStates {}

class LoadingCreateDoctor extends OurStates {}

class SuccessCreateDoctor extends OurStates {
  String message;
  SuccessCreateDoctor({
    required this.message,
  });
}

class LoadingBills extends OurStates {}

class SuccesBills extends OurStates {}

class EmptyBills extends OurStates {
  String message;
  EmptyBills({
    required this.message,
  });
}

class LoadingDeletingPreview extends OurStates {}

class SuccesDeletingPreview extends OurStates {
  String message;
  bool status;
  SuccesDeletingPreview({
    required this.message,
    required this.status,
  });
}

class FaileDeletingPreview extends OurStates {
  String message;
  bool status;
  FaileDeletingPreview({required this.message, required this.status});
}
class LoadingDeletingSurgery extends OurStates {}

class SuccesDeletingSurgery extends OurStates {
  String message;
  bool status;
  SuccesDeletingSurgery({
    required this.message,
    required this.status,
  });
}

class FaileDeletingSurgery extends OurStates {
  String message;
  bool status;
  FaileDeletingSurgery({required this.message, required this.status});
}

class LoadingDisplayEmptySurgeryRoom extends OurStates {}

class SuccessDisplayEmptySurgeryRoom extends OurStates {}

class ErrorDisplayEmptySurgeryRoom extends OurStates {
   String message;
  ErrorDisplayEmptySurgeryRoom({
    required this.message,
  });
}


class LoadingGetAvalibaleTimeForSurgery extends OurStates {}

class SuccessGetAvalibaleTimeForSurgery extends OurStates {}

class ErrorGetAvalibaleTimeForSurgery extends OurStates {
   String message;
  ErrorGetAvalibaleTimeForSurgery({
    required this.message,
  });
}

class LoadingPatientForSurgery extends OurStates {}

class SuccesPatientForSurgery extends OurStates {}

class EmptyPatientForSurgery extends OurStates {
   String message;
  EmptyPatientForSurgery({
    required this.message,
  });
}

class LoadingCreateSurgeryDoctor extends OurStates {}

class SuccessCreateSurgeryDoctor extends OurStates {
  String message;
  SuccessCreateSurgeryDoctor({
    required this.message,
  });
}
class BannedCreateSurgeryDoctor extends OurStates {
  String message;
  BannedCreateSurgeryDoctor({
    required this.message,
  });
}

class SelectedHourForSurgery extends OurStates {}

class SelectedMinuteForSurgery extends OurStates {}

class SelectedTimeForSurgery extends OurStates {}

class LoadingGetPersonalInfo extends OurStates {}

class SuccesGetPersonalInfo extends OurStates {}

class LoadingDisplayAreasByCityId extends OurStates {}

class SuccessDisplayAreasByCityId extends OurStates {}

class LoadingEditPerosnal extends OurStates {}

class SuccessEditPerosnal extends OurStates {
  String message;
  SuccessEditPerosnal({
    required this.message,
  });
}
class LoadingRequestNurse extends OurStates {}

class SuccessRequestNurse extends OurStates {
  String message;
  SuccessRequestNurse({
    required this.message,
  });
}
class ErrorRequestNurse extends OurStates {
  String message;
  ErrorRequestNurse({
    required this.message,
  });
}

class SuccessCreateMedicalDetails extends OurStates {
  String message;
  SuccessCreateMedicalDetails({
    required this.message,
  });
}

class LoadingDisplayDiseasesTypes extends OurStates {}

class SuccessDisplayDiseasesTypes extends OurStates {}

class ChossenDiseasesTypes extends OurStates {}

class LoadingDisplayDiseasesByDiseasesTypes extends OurStates {}

class SuccessDisplayDiseasesByDiseasesTypes extends OurStates {}

class ChossenDiseasesByDiseasesTypes extends OurStates {}

class LoadingShowAllAllergies extends OurStates {}

class SuccessShowAllAllergies extends OurStates {}

class ChossenAllergies extends OurStates {}

class SuccessUpdateMedicalDetails extends OurStates {
  String message;
  SuccessUpdateMedicalDetails({
    required this.message,
  });
}

class SuccessGetMedicalDetailsForUpdate extends OurStates {}

class LoadingPreviews extends OurStates {}

class EmptyPreviews extends OurStates {
  String message;
  EmptyPreviews({
    required this.message,
  });
}

class SuccesPreviews extends OurStates {}

class LoadingDisplayDepartmentForCreatePreview extends OurStates {}

class SuccessDisplayDepartmentForCreatePreview extends OurStates {}

class LoadingDisplayDoctorForCreatePreview extends OurStates {}

class SuccessDisplayDoctorForCreatePreview extends OurStates {}



