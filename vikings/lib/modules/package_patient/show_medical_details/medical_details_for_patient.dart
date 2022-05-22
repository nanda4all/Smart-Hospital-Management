// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../shared/cubit/cubit.dart';
import '../../../shared/cubit/states.dart';
class MedicalDetailsForPatient extends StatefulWidget {
  const MedicalDetailsForPatient({Key? key}) : super(key: key);

  @override
  State<MedicalDetailsForPatient> createState() => _MedicalDetailsForPatientState();
}

class _MedicalDetailsForPatientState extends State<MedicalDetailsForPatient> {
  bool isTreatmentPlanShown = false;
  bool isSpecialNeedsShown = false;
  bool isAllergiesShown = false;
  bool isFamilyDiseasesShown = false;
  bool isChronicDiseasesShown = false;
  bool isExaminationRecordsShown = false;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OurCubit, OurStates>(
      listener: (context, state) {
         if (state is BannedPatient) {
          OurCubit.get(context).bannedPatient(state.message, context);
        }
      },
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          title: const Text('التفاصيل الطبية'),
          backgroundColor: const Color(0xff92cbdf),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back,color: Colors.white,),
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/', (Route<dynamic> route) => false);
            },
          ),
        ),
        body: ConditionalBuilder(
          condition: state is! LoadingGetMedicalDetails &&
           OurCubit.get(context).medicalDetails != null
           && state is! ErrorGetMedicalDetailsForPatient,
          builder:(context) =>  Container(
            color:const Color(0xff92cbdf),
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        OurCubit.get(context).medicalDetails['name'],
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: Colors.black.withOpacity(0.1),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Text(
                          'زمرة الدم : ',
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          width: 75,
                        ),
                        Text(
                          OurCubit.get(context).medicalDetails['blood'],
                          style: const TextStyle(
                            fontSize: 23,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: Colors.black.withOpacity(0.1),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          'الخطة العلاجية:',
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              isTreatmentPlanShown = !isTreatmentPlanShown;
                            });
                          },
                          icon: Icon(
                            isTreatmentPlanShown
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                          ),
                        ),
                      ],
                    ),
                    Visibility(
                        visible: isTreatmentPlanShown,
                        child: Text(
                          OurCubit.get(context).medicalDetails['plans'],
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        )),
                    Row(
                      children: [
                        Text(
                          'الاحتياجات الخاصة:',
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              isSpecialNeedsShown = !isSpecialNeedsShown;
                            });
                          },
                          icon: Icon(
                            isSpecialNeedsShown
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                          ),
                        ),
                      ],
                    ),
                    Visibility(
                        visible: isSpecialNeedsShown,
                        child: Text(
                          OurCubit.get(context).medicalDetails['need'],
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        )),
                    Row(
                      children: [
                        const Text(
                          'الحساسيات:',
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              isAllergiesShown = !isAllergiesShown;
                            });
                          },
                          icon: Icon(
                            isAllergiesShown
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                          ),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: isAllergiesShown,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (context, index) => buildItem(
                            OurCubit.get(context)
                                .allergiesForPatient[index]
                                .toString()),
                        itemCount: OurCubit.get(context).allergiesForPatient.length,
                      ),
                    ),
                    Row(
                      children: [
                        const Text(
                          'الأمراض العائلية:',
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              isFamilyDiseasesShown = !isFamilyDiseasesShown;
                            });
                          },
                          icon: Icon(
                            isFamilyDiseasesShown
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                          ),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: isFamilyDiseasesShown,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (context, index) => buildItem(
                            OurCubit.get(context)
                                .familyForPatient[index]
                                .toString()),
                        itemCount: OurCubit.get(context).familyForPatient.length,
                      ),
                    ),
                    Row(
                      children: [
                        const Text(
                          'الأمراض المزمنة:',
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              isChronicDiseasesShown = !isChronicDiseasesShown;
                            });
                          },
                          icon: Icon(
                            isChronicDiseasesShown
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                          ),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: isChronicDiseasesShown,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (context, index) => buildItem(
                            OurCubit.get(context).chronicForPatient[index]),
                        itemCount: OurCubit.get(context).chronicForPatient.length,
                      ),
                    ),
                    Row(
                    children: [
                      const Text(
                        'المعاينات',
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            isExaminationRecordsShown =
                                !isExaminationRecordsShown; 
                          });
                        },
                        icon: Icon(
                          isExaminationRecordsShown
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: isExaminationRecordsShown,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, index) => buildExaminationItem(index),
                      itemCount: OurCubit.get(context).examinations.length,
                    ),
                  ),
                  const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: Colors.black.withOpacity(0.1),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: MaterialButton(
                        child: const Text(
                          'التحاليل',
                          style: TextStyle(
                            fontSize: 25,
                            color: Color(0xff92cbdf),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onPressed: () {
                          OurCubit.get(context).medicalDetailsId =
                              OurCubit.get(context)
                                  .medicalDetails['medicalId'];
                          Navigator.of(context).pushNamed('/ShowTestsForPatient');
                        },
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: MaterialButton(
                        child: const Text(
                          'الأشعة',
                          style: TextStyle(
                            fontSize: 25,
                            color: Color(0xff92cbdf),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/ShowRaysForPatient');
                        },
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: MaterialButton(
                        child: const Text(
                          'التقارير الخارجية',
                          style: TextStyle(
                            fontSize: 25,
                            color: Color(0xff92cbdf),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/ShowExternalRecordsForPatient');
                        },
                        color: Colors.white,
                      ),
                    ),
                    
                  ],
                ),
              ),
            ),
          ),
          fallback: (context) {
            if (state is ErrorGetMedicalDetails) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.menu,
                          size: 100,
                          color: Colors.grey,
                        ),
                        Text(
                          state.message,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black38),
                        ),
                      ],
                    ),
                  );
                }
                return Container(
                  color: const Color(0xff92cbdf),
                  child: const Center(
                    child: SpinKitWave(
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                );
          } ,
        ),
      ),
    );
  }

  Widget buildItem(String item) => Text(
        item,
        style: TextStyle(
          fontSize: 20.0,
        ),
      );

      Widget buildExaminationItem(int index) {
    return MaterialButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext con) {
            // return object of type Dialog
            return AlertDialog(
              content: SingleChildScrollView(
              child: Text(
                  OurCubit.get(context).examinations[index]['examination'],
                ),
                            ),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                TextButton(
                  child: Text("اغلاق"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
      child: Row(
        children: [
           Text(
            OurCubit.get(context).examinations[index]['doctorName'],
            style:const TextStyle(
              fontSize: 20,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          Spacer(),
           Text(
            OurCubit.get(context).examinations[index]['date'],
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
