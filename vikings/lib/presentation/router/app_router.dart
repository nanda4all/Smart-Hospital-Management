import 'package:HMS/modules/package_doctor/show_doctors/add_doctor.dart';
import 'package:HMS/modules/package_doctor/show_doctors/show_doctors.dart';
import 'package:HMS/modules/package_doctor/show_medical_details/show_external_records.dart';
import 'package:HMS/modules/package_doctor/show_medical_details/show_rays.dart';
import 'package:HMS/modules/package_doctor/show_medical_details/upload_external_records.dart';
import 'package:HMS/modules/package_doctor/show_medical_details/upload_ray_result.dart';
import 'package:HMS/modules/package_patient/show_medical_details/medical_details_for_patient.dart';
import 'package:HMS/modules/package_patient/show_medical_details/show_external_records_for_patient.dart';
import 'package:HMS/modules/package_patient/show_medical_details/show_rays_for_patient.dart';
import 'package:HMS/modules/package_patient/show_medical_details/show_tests_for_patient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:HMS/modules/Home_Screen/HomeScreen.dart';
import 'package:HMS/modules/package_doctor/create_preview_for_doctor/pick_date.dart';
import 'package:HMS/modules/package_doctor/doctor_master/doctor.dart';
import 'package:HMS/modules/package_doctor/login_screen_doc/lgoin_screen_doc.dart';
import 'package:HMS/modules/package_doctor/mgr_doctor_master/mgrdoctor.dart';
import 'package:HMS/modules/package_doctor/show_medical_details/medical_details.dart';
import 'package:HMS/modules/package_doctor/show_medical_details/show_tests.dart';
import 'package:HMS/modules/package_doctor/show_medical_details/upload_test_result.dart';
import 'package:HMS/modules/package_doctor/show_patients_for_doctor/show_patients_for_doctor.dart';
import 'package:HMS/modules/package_doctor/show_previews_for_doctor/show_previews_for_doctor.dart';
import 'package:HMS/modules/package_doctor/show_work_days/show_work_days.dart';
import 'package:HMS/modules/package_doctor/surgery_for_doctor/surgery_for_doctor.dart';
import 'package:HMS/modules/package_patient/Login_Screen_Pa/Login_Screen_Pa.dart';
import 'package:HMS/modules/package_patient/patient_master/paitent.dart';
import 'package:HMS/shared/components/constants.dart';
import 'package:HMS/shared/cubit/cubit.dart';
import 'package:HMS/shared/cubit/login_cubit.dart';
import '../../modules/package_doctor/create_surgery_for_doctor/empty_sergery_rom.dart';
import '../../modules/package_doctor/create_surgery_for_doctor/show_patient_for_surgery.dart';
import '../../modules/package_doctor/edit_personal_info_doctor/edit_personal_info_doctor.dart';
import '../../modules/package_doctor/show_medical_details/create_medical_details.dart';
import '../../modules/package_doctor/show_medical_details/update_medical_details.dart';
import '../../modules/package_patient/create_preview_for_patient/create_preview_for_patient.dart';
import '../../modules/package_patient/create_preview_for_patient/pick_date_for_patient.dart';
import '../../modules/package_patient/edit_personal_info_patient/edit_personal_info_patient.dart';
import '../../modules/package_patient/show_bill_for_patient/show_bill_for_patient.dart';
import '../../modules/package_patient/show_previews_for_patient/show_previews_for_patient.dart';

class AppRouter {
  final LoginCubit logCupit = LoginCubit();
  final OurCubit ourCubit = OurCubit();
  Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        if (!isLogin) {
          return MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                    value: logCupit,
                    child: const HomeScreen(),
                  )
                  );
        } else if (docId != null) {
          return MaterialPageRoute(
              builder: (_) {
                return BlocProvider.value(
                    value: ourCubit,
                    child: isManager!
                        ? MgrdoctorMaster(doctorId: docId!)
                        : DoctorMaster(
                            doctorId: docId!,
                          ),
                  );
              });
        }
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                value: ourCubit, child: PatientScreenMaster()));
      case '/LoginDoc':
        return MaterialPageRoute(builder: (_) {
          logCupit.selectedValue = null;
          return BlocProvider.value(
              value: logCupit..getHospital(), 
              child: LoginScreenDoc());
        });
      case '/LoginPa':
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                value: logCupit..getHospital(), child: LoginScreenPa()));
      case '/doctorMaster':
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                value: ourCubit,
                child: DoctorMaster(
                  doctorId: docId!,
                )));
      case '/MgrdoctorMaster':
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                  value: ourCubit,
                  child: MgrdoctorMaster(
                    doctorId: logCupit.loginDoctorModel.data!.id,
                  ),
                ));
      case '/patient_master':
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                  value: ourCubit,
                  child: PatientScreenMaster(),
                ));
      case '/showPreviewsForDoc':
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                value: ourCubit..displayPreviewsForDoctor(docId!),
                child: ShowPreviewsForDoctor()));
      case '/ShowPatientsForDoctor':
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                  value: ourCubit..displayPatientForDoctor(docId!),
                  child: const ShowPatientsForDoctor(),
                ));
      case '/ShowDoctors':
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                  value: ourCubit..getDoctors(docId!),
                  child: const ShowDoctors(),
                ));
      case '/AddDoctor':
        return MaterialPageRoute(
            builder: (_) {
              ourCubit.doctorBirthDate=null;
              ourCubit.doctorHireDate=null;
              ourCubit.selectedArea=null;
              ourCubit.selectedBirthPlace=null;
              ourCubit.selectedCity=null;
              ourCubit.selectedGender=null;
              ourCubit.selectedSocialStatus=null;
              return BlocProvider.value(
                  value: ourCubit..getAllCities(),
                  child: AddDoctor(),
                );
            });
      case '/SurgeryForDoctor':
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                  value: ourCubit..getSurgeriesForDoctor(docId!),
                  child: const SurgeryForDoctor(),
                ));
      case '/ShowWorkDays':
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                  value: ourCubit..getWorkDaysForDoctor(docId!),
                  child: const ShowWorkDays(),
                ));
      case '/PickDate':
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                  value: ourCubit,
                  child: PickDate(),
                ));
      case '/MedicalDetails':
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                  value: ourCubit,
                  child: const MedicalDetails(),
                ));
      case '/MedicalDetailsForPatient':
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                  value: ourCubit..getMedicalDetailsForPatient(paId!),
                  child: const MedicalDetailsForPatient(),
                ));
      case '/UploadTestResult':
        return MaterialPageRoute(builder: (_) {
          ourCubit.selectedTestType.clear();
          return BlocProvider.value(
            value: ourCubit,
            child: UploadTestResult(),
          );
        });
      case '/UploadRayResult':
        return MaterialPageRoute(builder: (_) {
          ourCubit.selectedRayType.clear();
          return BlocProvider.value(
            value: ourCubit,
            child: UploadRayResult(),
          );
        });
      case '/UploadExternalRecord':
        return MaterialPageRoute(builder: (_) {
          return BlocProvider.value(
            value: ourCubit,
            child: UploadExternalRecords(),
          );
        });
      case '/ShowTests':
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                  value: ourCubit..showTest(ourCubit.medicalDetailsId),
                  child: ShowTests(),
                ));
      case '/ShowTestsForPatient':
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                  value: ourCubit..showTest(ourCubit.medicalDetailsId),
                  child: const ShowTestsForPatient(),
                ));
      case '/ShowRays':
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                  value: ourCubit..showRay(ourCubit.medicalDetailsId),
                  child: ShowRays(),
                ));
      case '/ShowRaysForPatient':
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                  value: ourCubit..showRay(ourCubit.medicalDetailsId),
                  child: const ShowRaysForPatient(),
                ));
      case '/ShowExternalRecordsForDoctor':
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                  value: ourCubit..showExternalRecords(ourCubit.medicalDetailsId),
                  child: const ShowExternalRecordsForDoctor(),
                ));
      case '/ShowExternalRecordsForPatient':
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                  value: ourCubit..showExternalRecords(ourCubit.medicalDetailsId),
                  child: const ShowExternalRecordsForPatient(),
                ));
      case '/ShowBillForPatient':
        return MaterialPageRoute(
            builder: (_) {
              print(paId);
              return BlocProvider.value(
                  value: ourCubit..getBills(),
                  child: const ShowBillForPatient(),
                );
            });
            case '/ShowEmptySurgeryRoom':
        return MaterialPageRoute(builder: (_) {
          ourCubit.avalibaleTimeForSurgery = {};
          ourCubit.selectedHourForSurgery = {};
          ourCubit.selectedMinuteForSurgery= {};
          ourCubit.selectedTimeForSurgery = {};
          return BlocProvider.value(
            value: ourCubit..displayEmptySurgeryRoom(hoId!),
            child: ShowEmptySurgeryRoom(),
          );
        });
      case '/ShowPatientsForCreateSurgery':
        return MaterialPageRoute(
            builder: (_) {
              return BlocProvider.value(
                  value: ourCubit..displayPatientForSurgery(hoId!),
                  child: ShowPatientsForCreateSurgery(),
                );
            });
      case '/EditPersonalInformationDoctor':
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                  value: ourCubit,
                  child: const EditPersonalInfoDoctor(),
                ));
     case '/EditPersonalInformationPatient':
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                  value: ourCubit,
                  child: const EditPersonalInfoPetient(),
                ));

     case '/CreateMedicalDetails':
        return MaterialPageRoute(builder: (_) {
          ourCubit.allergiesSelcted = {};
          ourCubit.diseasesTypesSelctedForFamily = {};
          ourCubit.diseasesTypesSelctedForChronic = {};
          ourCubit.diseasesSelctedForFamily = {};
          ourCubit.diseasesSelctedForChronic = {};
          return BlocProvider.value(
            value: ourCubit,
            child: CreateMedicalDetails(),
          );
        });

     case '/UpdateMedicalDitails':
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                  value: ourCubit,
                  child: UpdateMedicalDitails(),
                ));

     case '/ShowPreviewForPatient':
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                  value: ourCubit..displayPreviewsForPatient(paId!, hoId!),
                  child: const ShowPreviewsForPatient(),
                ));

     case '/CreatePreviewForPatient':
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                  value: ourCubit..displayDepartmentForCreatePreview(hoId!),
                  child: CreatePreviewForPatient(),
                ));

     case '/PickDateForPatient':
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                  value: ourCubit,
                  child: PickDateForPatient(),
                ));

    }
    return null;
  }

  void dispos() {
    ourCubit.close();
    logCupit.close();
  }
}
