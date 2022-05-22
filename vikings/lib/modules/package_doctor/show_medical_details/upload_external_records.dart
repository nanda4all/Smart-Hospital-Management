// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:HMS/modules/package_doctor/show_medical_details/full_screen_image.dart';
import 'package:HMS/shared/components/components.dart';
import 'package:HMS/shared/cubit/cubit.dart';
import 'package:HMS/shared/cubit/states.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';

class UploadExternalRecords extends StatelessWidget {
  UploadExternalRecords({Key? key}) : super(key: key);
  XFile? _image;
  List<XFile> externalRecords = [];
  final ImagePicker _picker = ImagePicker();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OurCubit, OurStates>(
      listener: (context, state) => {
        if (state is SuccessUploadPhoto)
          {
            showToast(message: state.message, color: Colors.green),
            OurCubit.get(context)
                .showExternalRecords(OurCubit.get(context).medicalDetailsId)
                .then((value) => Navigator.of(context).pushNamedAndRemoveUntil(
                    '/ShowExternalRecordsForDoctor',
                    (Route<dynamic> route) => false))
          }
        else if (state is ErrorUploadPhoto)
          {showToast(message: state.message, color: Colors.red)}
      },
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          title: const Text('إضافة التقارير الخارجية'),
          backgroundColor: const Color(0xff92cbdf),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/MedicalDetails', (Route<dynamic> route) => false);
            },
          ),
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (con) => AlertDialog(
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('اختر مصدر الصورة'),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      iconSize: 50,
                                      onPressed: () async {
                                        _image = await _picker.pickImage(
                                            source: ImageSource.gallery);
                                        externalRecords.add(_image!);
                                        OurCubit.get(context)
                                            .addToExternalRecords();
                                        Navigator.pop(context);
                                      },
                                      icon: const Icon(
                                        Icons.image_rounded,
                                        size: 50,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 50,
                                    ),
                                    IconButton(
                                      iconSize: 50,
                                      onPressed: () async {
                                        _image = await _picker.pickImage(
                                            source: ImageSource.camera);
                                        externalRecords.add(_image!);
                                        OurCubit.get(context)
                                            .addToExternalRecords();
                                        Navigator.pop(context);
                                      },
                                      icon:
                                          const Icon(Icons.camera_alt_rounded),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ));
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                )),
          ],
        ),
        body: ConditionalBuilder(
          condition: state is! LoadingUploadPhoto,
          builder: (context) => Form(
            key: formKey,
            child: Container(
              color: const Color(0xff92cbdf),
              width: double.infinity,
              child: ListView.builder(
                itemBuilder: (context, index) => buildExternalRecordItem(
                    context, externalRecords[index], index),
                itemCount: externalRecords.length,
              ),
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
        floatingActionButton: FloatingActionButton(
          mini: false,
          onPressed: () {
            OurCubit.get(context).editExternalRecords();
            if (externalRecords.isEmpty) {
              showToast(message: 'الرجاء اضافة تقرير ', color: Colors.red);
              OurCubit.get(context).editExternalRecords;
            } else {
              OurCubit.get(context).uploadPhotoExternalRecords(
                  externalRecords: externalRecords,
                  medicalId: OurCubit.get(context).medicalDetailsId);
            }
          },
          backgroundColor: Colors.white,
          child: const Icon(
            Icons.done,
            color: Color(0xff92cbdf),
          ),
        ),
      ),
    );
  }

  Widget buildExternalRecordItem(context, XFile _image, int index) => Padding(
        padding: const EdgeInsets.all(15.0),
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FullScreenImage(
                          image: _image,
                        )));
          },
          child: Center(
            child: Card(
              elevation: 10,
              shadowColor: Colors.black,
              color: Colors.cyan[100],
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.428,
                child: Stack(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.428,
                      child: FittedBox(
                        clipBehavior: Clip.hardEdge,
                        fit: BoxFit.cover,
                        child: Image.file(
                          File(_image.path),
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
                                        externalRecords.removeAt(index);
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
          ),
        ),
      );
}
