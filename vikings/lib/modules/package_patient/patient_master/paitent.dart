import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/components/components.dart';
import '../../../shared/components/constants.dart';
import '../../../shared/cubit/cubit.dart';
import '../../../shared/cubit/states.dart';

class PatientScreenMaster extends StatelessWidget {
  PatientScreenMaster({
    Key? key,
  }) : super(key: key);
  var title = ['المواعيد', 'الفاتورة', 'طلب إرسال ممرض', 'الملف الطبي'];
  List<ImageProvider<Object>> images = const [
    AssetImage('lib/assets/images/prev.png'),
    AssetImage('lib/assets/images/bill.png'),
    AssetImage('lib/assets/images/sendpa.png'),
    AssetImage('lib/assets/images/midical.png'),
  ];
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OurCubit, OurStates>(listener: (context, state) {
      if (state is SuccessRequestNurse) {
        showToast(message: state.message, color: Colors.green);
        Navigator.of(context).pop();
      }
      if (state is ErrorRequestNurse) {
        showToast(message: state.message, color: Colors.red);
                Navigator.of(context).pop();

      }
      if (state is LoadingRequestNurse) {
        showDialog(
          builder: (con) => AlertDialog(
            content: Row(
              children: const <Widget>[
                CircularProgressIndicator(
                  color: Color(0xff92cbdf),
                ),
                SizedBox(
                  width: 20.0,
                ),
                Text(
                  'جار إرسال الطلب ...',
                  style: TextStyle(fontSize: 18.0),
                )
              ],
            ),
          ),
          context: context,
        );
      }
    }, builder: (context, state) {
      print(state);
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
                                  sharedPreferences.remove('paId');
                                  sharedPreferences.remove('hoId');
                                  hoId = null;
                                  paId = null;
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
                        ));
              },
            ),
            actions: [
              IconButton(
                onPressed: () {
                  OurCubit.get(context).getPersonalInfoPatient(paId!);
                  Navigator.of(context)
                      .pushNamed('/EditPersonalInformationPatient');
                },
                icon: const Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
            ]),
        body: Container(
          padding: const EdgeInsetsDirectional.only(top: 10, bottom: 10),
          color: const Color(0xff92cbdf),
          width: double.infinity,
          child: ListView.separated(
            itemBuilder: (context, index) =>
                buildDoctorItem(context, title[index], images[index], index),
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
          context, String title, ImageProvider image, int index) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              var cubit = OurCubit.get(context);
              switch (index) {
                case 0:
                  Navigator.of(context).pushNamed('/ShowPreviewForPatient');
                  break;
                case 1:
                  Navigator.of(context).pushNamed('/ShowBillForPatient');
                  break;
                case 2:
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("إرسال طلب ممرض"),
                        content: const Text('هل تريد طلب ممرض إلى منزلك؟'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text("نعم"),
                            onPressed: () {
                              cubit.sendNurseRequest();
                                      Navigator.of(context).pop();

                            },
                          ),
                          TextButton(
                            child: const Text("لا"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );

                  break;
                case 3:
                  Navigator.of(context).pushNamed('/MedicalDetailsForPatient');
                  break;
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
