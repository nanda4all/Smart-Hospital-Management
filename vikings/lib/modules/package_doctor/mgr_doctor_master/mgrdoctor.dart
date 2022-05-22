// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:HMS/shared/components/constants.dart';
import 'package:HMS/shared/cubit/cubit.dart';
import 'package:HMS/shared/cubit/states.dart';

class MgrdoctorMaster extends StatelessWidget {
  int doctorId;
  MgrdoctorMaster({
    Key? key,
    required this.doctorId,
  }) : super(key: key);
  var title = [
    'جدول الدوام',
    'العمليات',
    'حجز موعد',
    'المواعيد',
    'المرضى',
    'الأطباء',
    'التقارير',
  ];
  List<ImageProvider<Object>> images = const [
    AssetImage('lib/assets/images/prev.png'),
    AssetImage('lib/assets/images/surgery.png'),
    AssetImage('lib/assets/images/takeprev.png'),
    AssetImage('lib/assets/images/prev.png'),
    AssetImage('lib/assets/images/pat.png'),
    AssetImage('lib/assets/images/doctor.jpg'),
    AssetImage('lib/assets/images/doctor.jpg'),
  ];
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OurCubit, OurStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
                backgroundColor: const Color(0xff92cbdf),
                leading: IconButton(
                  icon: const Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (con) => AlertDialog(
                        content:
                            const Text('هل أنت متأكد أنك تريد تسجيل الخروج'),
                        actions: [
                          TextButton(
                              onPressed: () {
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
                  },
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      OurCubit.get(context).getPersonalInfoDoctor(docId!);
                      Navigator.of(context)
                          .pushNamed('/EditPersonalInformationDoctor');
                    },
                    icon: const Icon(Icons.person, color: Colors.white),
                  ),
                ]),
            body: Container(
              padding: const EdgeInsetsDirectional.only(top: 10, bottom: 10),
              color: const Color(0xff92cbdf),
              width: double.infinity,
              child: ListView.separated(
                itemBuilder: (context, index) => buildDoctorItem(
                    context, title[index], images[index], index),
                separatorBuilder: (context, index) => const SizedBox(
                  height: 30,
                ),
                itemCount: title.length,
              ),
            ),
          );
        });
  }

  Widget buildDoctorItem(
      context, String title, ImageProvider image, int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            if (index == 0) {
              Navigator.of(context).pushNamed('/ShowWorkDays');
            } else if (index == 1) {
              Navigator.of(context).pushNamed('/SurgeryForDoctor');
            } else if (index == 2) {
              Navigator.of(context).pushNamed('/ShowPatientsForDoctor');
            } else if (index == 3) {
              Navigator.of(context).pushNamed('/showPreviewsForDoc');
            } else if (index == 4) {
              Navigator.of(context).pushNamed('/ShowPatientsForDoctor');
            } else if (index == 5) {
              Navigator.of(context).pushNamed('/ShowDoctors');
            } else if (index == 6) {
              Navigator.of(context).pushNamed('/Requests');
            }
          },
          child: CircleAvatar(
            radius: 60,
            backgroundImage: image,
            backgroundColor: Colors.white,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 25,
          ),
        ),
      ],
    );
  }
}
