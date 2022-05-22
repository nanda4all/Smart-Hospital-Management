import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:HMS/shared/components/constants.dart';
import 'package:HMS/shared/cubit/cubit.dart';
import 'package:HMS/shared/cubit/states.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../shared/components/components.dart';

class ShowPatientsForDoctor extends StatelessWidget {
  const ShowPatientsForDoctor({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OurCubit, OurStates>(
        listener: (context, state) {
          if (state is BannedDoctor) {
        OurCubit.get(context).bannedDoctor(state.message, context);
      }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('استعراض المرضى'),
              backgroundColor: const Color(0xff92cbdf),
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            body: ConditionalBuilder(
                condition: state is! LoadingPatientForDoc &&
                    state is! EmptyPatientForDoc,
                builder: (context) => Container(
                      color: const Color(0xff92cbdf),
                      width: double.infinity,
                      child: ListView.builder(
                        itemBuilder: (context, index) =>
                            buildPatientsItem(context, index),
                        itemCount:
                            OurCubit.get(context).patientForDoctor.length,
                      ),
                    ),
                fallback: (context) {
                  if (state is EmptyPatientForDoc) {
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
                }),
          );
        });
  }
}

Widget buildPatientsItem(context, int index) => Padding(
      key: Key(OurCubit.get(context)
          .patientForDoctor[index]['patient_Id']
          .toString()),
      padding: const EdgeInsets.all(15.0),
      child: Card(
        elevation: 10,
        shadowColor: Colors.black,
        color: Colors.cyan[100],
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          height: MediaQuery.of(context).size.height * 0.54,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    OurCubit.get(context)
                        .patientForDoctor[index]['patient_Full_Name']
                        .toString(),
                    style: const TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.black.withOpacity(0.1),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Row(children: [
                  const Text(
                    'العمر :   ',
                    style: TextStyle(
                      fontSize: 23,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    OurCubit.get(context)
                        .patientForDoctor[index]['patient_Age']
                        .toString(),
                    style: const TextStyle(
                      fontSize: 23,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ]),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.black.withOpacity(0.1),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Row(children: [
                  const Text(
                    'السكن :   ',
                    style: TextStyle(
                      fontSize: 23,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    OurCubit.get(context)
                        .patientForDoctor[index]['patient_Place']
                        .toString(),
                    style: const TextStyle(
                      fontSize: 23,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ]),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.black.withOpacity(0.1),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        var p = OurCubit.get(context).patientForDoctor[index]
                            ['patient_Phone'] as List;
                        showDialog(
                          context: context,
                          builder: (con) => AlertDialog(
                            content: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.2,
                              child: ListView.separated(
                                itemBuilder: (context, index) => Row(
                                  children: [
                                    Text(
                                      p[index]['patient_Phone_Number']
                                          .toString(),
                                      style: const TextStyle(
                                        fontSize: 23,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      child: IconButton(
                                        onPressed: () {
                                          launchUrl(Uri(
                                            scheme: 'tel',
                                            path: p[index]
                                                    ['patient_Phone_Number']
                                                .toString(),
                                          ));
                                        },
                                        icon: const Icon(
                                          Icons.call,
                                          color: Colors.green,
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                    ),
                                  ],
                                ),
                                separatorBuilder: (context, index) => Column(
                                  children: [
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
                                  ],
                                ),
                                itemCount: p.length,
                              ),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('إغلاق')),
                            ],
                          ),
                        );
                      },
                      child: const Text(
                        'أرقام المريض',
                        style: TextStyle(
                          fontSize: 23,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.call,
                          color: Colors.green,
                        ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: MaterialButton(
                    onPressed: () {
                      OurCubit.get(context).getMedicalDetailsForDoctor(
                          docId!,
                          OurCubit.get(context).patientForDoctor[index]
                              ['patient_Id']);
                      Navigator.of(context).pushNamed('/MedicalDetails');
                    },
                    child: const Text(
                      " الملف الطبي",
                      style: TextStyle(
                        fontSize: 23,
                        color: Color(0xff92cbdf),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  width: double.infinity,
                  child: MaterialButton(
                    onPressed: () {
                      OurCubit.get(context).paIdForCreatePreview =
                          OurCubit.get(context).patientForDoctor[index]
                              ['patient_Id'];
                      OurCubit.get(context).getWorkDaysForDoctor(docId!).then(
                          (value) =>
                              Navigator.of(context).pushNamed('/PickDate'));
                    },
                    child: const Text(
                      "حجز موعد",
                      style: TextStyle(
                        fontSize: 23,
                        color: Color(0xff92cbdf),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
