import 'package:HMS/modules/package_doctor/show_medical_details/full_screen_image.dart';
import 'package:HMS/shared/cubit/cubit.dart';
import 'package:HMS/shared/cubit/states.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ShowRaysForPatient extends StatelessWidget {
  const ShowRaysForPatient({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OurCubit, OurStates>(
      listener: (context, state) => {},
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          title: const Text('الأشعة'),
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
          condition: state is! LoadingAllRays,
          builder: (context) => Container(
            color: const Color(0xff92cbdf),
            width: double.infinity,
            child: ListView.builder(
              itemBuilder: (context, index) => buildRayItem(context, index),
              itemCount: OurCubit.get(context).showAllRays.length,
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

  Widget buildRayItem(context, int index) => Padding(
        padding: const EdgeInsets.all(15.0),
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (con) => FullScreenImage(
                          path:
                              'https://192.168.1.11:44314/Ray_Result/${OurCubit.get(context).showAllRays[index]['rayResult']}',
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
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.height * 0.428,
                          child: FittedBox(
                            clipBehavior: Clip.hardEdge,
                            fit: BoxFit.cover,
                            child: Image(
                              image: NetworkImage(
                                  'https://192.168.1.11:44314/Ray_Result/${OurCubit.get(context).showAllRays[index]['rayResult']}'),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 18, right: 18, bottom: 15),
                          child: Row(
                            children: [
                              Text(
                                OurCubit.get(context).showAllRays[index]
                                    ['rayDate'],
                                style: const TextStyle(
                                    fontSize: 25,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              Text(
                                OurCubit.get(context).showAllRays[index]
                                    ['rayType'],
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: OurCubit.get(context).isEditRayResult,
                  child: IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (con) => AlertDialog(
                            content: const Text(
                                'هل أنت متأكد أنك تريد حذف التحليل؟'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    OurCubit.get(context)
                                        .deleteFromRayResult();
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
                        OurCubit.get(context).chossenRayResult();
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
