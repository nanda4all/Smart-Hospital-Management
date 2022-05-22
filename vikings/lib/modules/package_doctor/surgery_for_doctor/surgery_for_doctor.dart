import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../shared/components/components.dart';
import '../../../shared/components/constants.dart';
import '../../../shared/cubit/cubit.dart';
import '../../../shared/cubit/states.dart';
class SurgeryForDoctor extends StatelessWidget {
  const SurgeryForDoctor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OurCubit, OurStates>(
      listener: (context, state) {
        if (state is BannedSurgeriesForDoc) {
                      showToast(message: state.message, color: Colors.red);
                      Navigator.pop(context);
                                sharedPreferences.remove('docId');
                                sharedPreferences.remove('isManager');
                                sharedPreferences.remove('hoId');
                                docId = null;
                                hoId = null;
                                isManager = false;
                                isLogin = false;
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    "/", (Route<dynamic> route) => false);

        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('العمليات'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back,color:Colors.white),
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/', (Route<dynamic> route) => false);
              },
            ),
            backgroundColor: const Color(0xff92cbdf),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
            mini: false,
            onPressed: () {
              print(hoId);
              Navigator.of(context).pushNamed('/ShowPatientsForCreateSurgery');
            },
            backgroundColor: Colors.white,
            child: const Icon(
              Icons.add,
              color: Color(0xff92cbdf),
            ),
          ),
          body: ConditionalBuilder(
              condition: state is! LoadingSurgeriesForDoc &&
                  state is! EmptySurgeriesForDoc &&
                  OurCubit.get(context).surgeries != null,
              builder: (context) => Container(
                    color: const Color(0xff92cbdf),
                    width: double.infinity,
                    child: ListView.builder(
                      itemBuilder: (context, index) =>
                          buildPatientsItem(context, index),
                      itemCount: OurCubit.get(context).surgeries.length,
                    ),
                  ),
              fallback: (context) {
                if (state is EmptySurgeriesForDoc) {
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
      },
    );
  }
}

Widget buildPatientsItem(context, int index) {
  var cubit=OurCubit.get(context);
  return Padding(
      key: Key(OurCubit.get(context).surgeries[index]['surgeryId'].toString()),
      padding: const EdgeInsets.all(15.0),
      child: Card(
        elevation: 10,
        shadowColor: Colors.black,
        color: Colors.cyan[100],
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.8,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    OurCubit.get(context).surgeries[index]['surgeryName'],
                    style: const TextStyle(
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
                    const Expanded(
                      child: Text(
                        ' التاريخ :  ',
                        style: TextStyle(
                          fontSize: 23,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        OurCubit.get(context)
                            .surgeries[index]['surgeryDate']
                            .toString(),
                        style: const TextStyle(
                          fontSize: 23,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
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
                    const Expanded(
                      child: Text(
                        ' الوقت : ',
                        style: TextStyle(
                          fontSize: 23,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        OurCubit.get(context)
                            .surgeries[index]['surgeryHour']
                            .toString(),
                        style: const TextStyle(
                          fontSize: 23,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
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
                    const Expanded(
                      child: Text(
                        ' مدة العملية : ',
                        style: TextStyle(
                          fontSize: 23,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        OurCubit.get(context)
                            .surgeries[index]['surgeryTime']
                            .toString(),
                        style: const TextStyle(
                          fontSize: 23,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
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
                    const Expanded(
                      child: Text(
                        'رقم الغرفة :   ',
                        style: TextStyle(
                          fontSize: 23,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        OurCubit.get(context)
                            .surgeries[index]['surgeryRoom']
                            .toString(),
                        style: const TextStyle(
                          fontSize: 23,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
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
                    const Expanded(
                      child: Text(
                        'الطابق : ',
                        style: TextStyle(
                          fontSize: 23,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        OurCubit.get(context)
                            .surgeries[index]['floor']
                            .toString(),
                        style: const TextStyle(
                          fontSize: 23,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
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
                    const Expanded(
                      child: Text(
                        'اسم المريض : ',
                        style: TextStyle(
                          fontSize: 23,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        OurCubit.get(context).surgeries[index]['patientName'],
                        style: const TextStyle(
                          fontSize: 23,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
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
                  TextButton(
                    onPressed: () {
                      var p =
                          cubit.surgeries[index]['patientPhoneNumbers'] as List;
                      showDialog(
                        context: context,
                        builder: (con) => AlertDialog(
                          content: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.2,
                            child: ListView.separated(
                              itemBuilder: (context, index) => Row(
                                children: [
                                  Text(
                                    p[index]['patient_Phone_Number'].toString(),
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
                                          path: p[index]['patient_Phone_Number']
                                              .toString(),
                                        ));
                                      },
                                      icon: const Icon(
                                        Icons.call,
                                        color: Colors.green,
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
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
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: MaterialButton(
                    onPressed: () async{
                      await cubit.getMedicalDetailsForDoctor(
                        docId!, cubit.surgeries[index]['patientPhoneNumbers'][0]['patient_Id']);
                    Navigator.of(context).pushNamed('/MedicalDetails');
                    },
                    child:const Text(
                      " الملف الطبي للمريض ",
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
}
