import 'package:HMS/modules/package_doctor/show_medical_details/full_screen_image.dart';
import 'package:HMS/shared/cubit/cubit.dart';
import 'package:HMS/shared/cubit/states.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ShowExternalRecordsForPatient extends StatelessWidget {
  const ShowExternalRecordsForPatient({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OurCubit, OurStates>(
      listener: (context, state) => {},
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          title: const Text('السجلات الخارجية'),
          backgroundColor: const Color(0xff92cbdf),
          centerTitle: true,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back,color:Colors.white,),
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/MedicalDetailsForPatient', (Route<dynamic> route) => false);
              },
            ),
        ),
        body: ConditionalBuilder(
          condition: state is! LoadingAllExternalRecords,
          builder: (context) => Container(
            color: const Color(0xff92cbdf),
            width: double.infinity,
            child: ListView.builder(
              itemBuilder: (context, index) => buildExternalRecordItem(context, index),
              itemCount: OurCubit.get(context).showAllExternalRecords.length,
            ),
          ),
          fallback: (context) => Container(
            color: const Color(0xff92cbdf),
            child: const Center(
              child: SpinKitWave(
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildExternalRecordItem(context, int index) => Padding(
        padding: const EdgeInsets.all(15.0),
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (con) => FullScreenImage(
                          path:
                              'https://192.168.1.11:44314/External_Records/${OurCubit.get(context).showAllExternalRecords[index]['externalRecord']}',
                        )));
          },
          child: Center(
            child: Stack(
              children: [
                Card(
                  elevation: 10,
                  shadowColor: Colors.black,
                  color: Colors.cyan[100],
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.50,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.428,
                      child: FittedBox(
                        clipBehavior: Clip.hardEdge,
                        fit: BoxFit.cover,
                        child: Image(
                          image: NetworkImage(
                              'https://192.168.1.11:44314/External_Records/${OurCubit.get(context).showAllExternalRecords[index]['externalRecords']}'),
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: OurCubit.get(context).isEditExternalRecords,
                  child: IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (con) => AlertDialog(
                            content: const Text(
                                'هل أنت متأكد أنك تريد حذف التقرير؟'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    OurCubit.get(context)
                                        .deleteFromExternalRecords();
                                  },
                                  child: const Text('نعم')),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('لا')),
                            ],
                          ),
                        );
                        OurCubit.get(context).chossenExternalRecords();
                      },
                      icon: const Icon(
                        Icons.remove_circle_outline,
                        color: Colors.red,
                        size: 30,
                      )),
                )
              ],
            ),
          ),
        ),
      );
}
