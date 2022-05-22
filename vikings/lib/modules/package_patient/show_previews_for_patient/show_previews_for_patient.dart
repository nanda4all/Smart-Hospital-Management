import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../shared/cubit/cubit.dart';
import '../../../shared/cubit/states.dart';

class ShowPreviewsForPatient extends StatefulWidget {
  const ShowPreviewsForPatient({Key? key}) : super(key: key);

  @override
  State<ShowPreviewsForPatient> createState() => _ShowPreviewsForPatientState();
}

class _ShowPreviewsForPatientState extends State<ShowPreviewsForPatient> {
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
          title: const Text('استعراض المواعيد'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
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
            Navigator.of(context).pushNamed('/CreatePreviewForPatient');
          },
          backgroundColor: Colors.white,
          child: const Icon(
            Icons.add,
            color: Color(0xff92cbdf),
          ),
        ),
        body: ConditionalBuilder(
            condition: state is! LoadingPreviews &&
                state is! EmptyPreviews &&
                OurCubit.get(context).previewsPatient != null,
            builder: (context) => Container(
                  color: const Color(0xff92cbdf),
                  width: double.infinity,
                  child: ListView.builder(
                    itemBuilder: (context, index) =>
                        buildPatientsItem(context, index),
                    itemCount: OurCubit.get(context).previewsPatient.length,
                  ),
                ),
            fallback: (context) {
              if (state is EmptyPreviews) {
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
      ),
    );
  }
}

Widget buildPatientsItem(context, int index) => Padding(
      padding: const EdgeInsets.all(15.0),
      child: Flex(
        direction: Axis.vertical,
        children: [
          Card(
            elevation: 10,
            shadowColor: Colors.black,
            color: Colors.cyan[100],
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              // height: MediaQuery.of(context).size.height * 0.50,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            ' التاريخ : ',
                            style: TextStyle(
                              fontSize: 23,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            OurCubit.get(context).previewsPatient[index]
                                ['previewDate'],
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
                      color: Colors.black.withOpacity(0.3),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            ' الوقت :',
                            style: TextStyle(
                              fontSize: 23,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            OurCubit.get(context).previewsPatient[index]
                                ['previewHour'],
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
                      color: Colors.black.withOpacity(0.3),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'اسم الطبيب : ',
                            style: TextStyle(
                              fontSize: 23,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            OurCubit.get(context).previewsPatient[index]
                                ['docName'],
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
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
                      color: Colors.black.withOpacity(0.3),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          OurCubit.get(context).previewsPatient[index]
                              ['doctorPhoneNumber'][0]['doctor_Phone_Number'],
                          style: const TextStyle(
                            fontSize: 23,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
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
                            color: Colors.white,
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
                      color: Colors.black.withOpacity(0.3),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'الاختصاص :   ',
                            style: TextStyle(
                              fontSize: 23,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            OurCubit.get(context).previewsPatient[index]
                                ['speclization'],
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
                      color: Colors.black.withOpacity(0.3),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Visibility(
                      visible: OurCubit.get(context).previewsPatient[index]
                          ['isToday'],
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20)),
                        child: MaterialButton(
                          onPressed: () {},
                          child: const Text(
                            " حذف الموعد ",
                            style: TextStyle(
                              fontSize: 23,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
