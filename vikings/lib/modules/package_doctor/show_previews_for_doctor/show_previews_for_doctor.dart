import 'package:HMS/shared/components/components.dart';
import 'package:HMS/shared/components/constants.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:HMS/shared/cubit/cubit.dart';
import 'package:HMS/shared/cubit/states.dart';
import 'package:url_launcher/url_launcher.dart';

class ShowPreviewsForDoctor extends StatefulWidget {
  ShowPreviewsForDoctor({Key? key}) : super(key: key);

  @override
  State<ShowPreviewsForDoctor> createState() => _ShowPreviewsForDoctorState();
}

class _ShowPreviewsForDoctorState extends State<ShowPreviewsForDoctor> {
  List<bool> clicked = [];

  var formKey = GlobalKey<FormState>();

  List<TextEditingController> examninationControllers = [];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OurCubit, OurStates>(
      listener: (context, state) {
        if (state is SuccessAddExam) {
          showToast(message: state.message, color: Colors.green);
          OurCubit.get(context).displayPreviewsForDoctor(docId!);
        } else if (state is SuccesDeletingPreview) {
          if (state.status) {
            showToast(message: state.message.toString(), color: Colors.green);
          } else {
            showToast(message: state.message.toString(), color: Colors.red);
          }
        } else if (state is BannedDoctor) {
          OurCubit.get(context).bannedDoctor(state.message, context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/', (Route<dynamic> route) => false);
              },
            ),
            title: const Text('استعراض المواعيد'),
            backgroundColor: const Color(0xff92cbdf),
            centerTitle: true,
          ), //AppBar
          body: ConditionalBuilder(
              condition: state is! LoadingPreviewsForDoc &&
                  OurCubit.get(context).previews != null,
              builder: (context) => Form(
                    key: formKey,
                    child: Container(
                      color: const Color(0xff92cbdf),
                      width: double.infinity,
                      child: ListView.builder(
                        itemBuilder: (context, index) =>
                            buildPatientsItem(context, index, state),
                        itemCount: OurCubit.get(context).previews.length,
                      ),
                    ),
                  ),
              fallback: (context) {
                if (state is EmptyPreviewsForDoc) {
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

  Widget buildPatientsItem(context, int index, OurStates state) {
    clicked.add(false);
    examninationControllers.add(TextEditingController());
    var cubit = OurCubit.get(context);
    if (cubit.previews[index]['exam'] != null) {
      examninationControllers[index].text = cubit.previews[index]['exam'];
    }
    return Padding(
      key: Key(cubit.previews[index]['previewId'].toString()),
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
                              fontSize: 25,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            cubit.previews[index]['previewDate'].toString(),
                            style: const TextStyle(
                              fontSize: 25,
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
                            cubit.previews[index]['previewHour'].toString(),
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
                            cubit.previews[index]['patientName'].toString(),
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
                            var p = cubit.previews[index]['patientPhoneNumber']
                                as List;
                            showDialog(
                              context: context,
                              builder: (con) => AlertDialog(
                                content: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
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
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                        ),
                                      ],
                                    ),
                                    separatorBuilder: (context, index) =>
                                        Column(
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
                    TextButton(
                      onPressed: (() {
                        setState(() {
                          clicked[index] = !clicked[index];
                        });
                      }),
                      child: Row(
                        children: [
                          const Text(
                            'التشخيص  ',
                            style: TextStyle(
                              fontSize: 23,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          Icon(!clicked[index]
                              ? Icons.keyboard_arrow_down
                              : Icons.keyboard_arrow_up),
                        ],
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
                    Visibility(
                      visible: clicked[index],
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.name,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "الرجاء عدم ترك الحقل فارغاً";
                              }
                              return null;
                            },
                            controller: examninationControllers[index],
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(
                                Icons.local_hospital_outlined,
                              ),
                              labelText: "التشخيص ",
                            ),
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
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  cubit.addExamination(
                                    docId: docId!,
                                    exam: examninationControllers[index].text,
                                    previewId: cubit.previews[index]
                                        ['previewId'],
                                  );
                                }
                              },
                              child: Text(
                                cubit.previews[index]['exam'] != null
                                    ? 'تعديل التشخيص'
                                    : 'إضافة التشخيص',
                                style: const TextStyle(
                                  fontSize: 23,
                                  color: Color(0xff92cbdf),
                                  fontWeight: FontWeight.w500,
                                ),
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
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: MaterialButton(
                        onPressed: () async {
                          await cubit.getMedicalDetailsForDoctor(
                              docId!, cubit.previews[index]['paId']);
                          Navigator.of(context).pushNamed('/MedicalDetails');
                        },
                        child: const Text(
                          " الملف الطبي للمريض ",
                          style: TextStyle(
                            fontSize: 23,
                            color: Color(0xff92cbdf),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.red[400],
                          borderRadius: BorderRadius.circular(20)),
                      child: ConditionalBuilder(
                          condition: state is LoadingDeletingPreview,
                          builder: (context) => Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                          fallback: (context) {
                            return MaterialButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: const Text(
                                          "هل أنت متأكد من إلغاء الموعد؟"),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text("نعم"),
                                          onPressed: () {
                                            cubit.deletePreviewForDoc(
                                                prevId: cubit.previews[index]
                                                        ['previewId']
                                                    .toString());
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
                              },
                              child: const Text(
                                " إلغاء الموعد ",
                                style: TextStyle(
                                  fontSize: 23,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
