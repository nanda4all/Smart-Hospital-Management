import 'dart:io';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../shared/components/components.dart';
import '../../../shared/cubit/cubit.dart';
import '../../../shared/cubit/states.dart';
import 'full_screen_image.dart';

class UploadRayResult extends StatelessWidget {
  UploadRayResult({Key? key}) : super(key: key);
  XFile? _image;
  List<DateTime> dates = [];
    List<int> typeId = [];

  List<XFile> rayResult = [];
  final ImagePicker _picker = ImagePicker();
  List<TextEditingController> dateControllers = [];
  List<GlobalKey<FormFieldState>> keys = [];
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OurCubit, OurStates>(
      listener: (context, state) => {
        if (state is SuccessUploadPhoto)
          {
            showToast(message: state.message, color: Colors.green),
            OurCubit.get(context)
                .showRay(OurCubit.get(context).medicalDetailsId)
                .then((value) => Navigator.of(context).pushNamed('/ShowRays'))
          }
        else if (state is ErrorUploadPhoto)
          {showToast(message: state.message, color: Colors.red)}
      },
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          title: const Text('إضافة الأشعة'),
          backgroundColor: const Color(0xff92cbdf),
          centerTitle: true,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back,color:Colors.white),
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/ShowRays', (Route<dynamic> route) => false);
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
                                        rayResult.add(_image!);
                                        dateControllers
                                            .add(TextEditingController());
                                        keys.add(GlobalKey<FormFieldState>());
                                        OurCubit.get(context).getRayType();
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
                                        rayResult.add(_image!);
                                        dateControllers
                                            .add(TextEditingController());
                                        keys.add(GlobalKey<FormFieldState>());
                                        OurCubit.get(context).getRayType();
                                        Navigator.pop(context);
                                      },
                                      icon: const Icon(
                                          Icons.camera_alt_rounded),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ));
                },
                icon: const Icon(Icons.add,color: Colors.white,)),
          ],
        ),
        body: ConditionalBuilder(
          condition:
              state is! LoadingUploadPhoto && state is! LoadingGetAllRayTypes,
          builder: (context) => Form(
            key: formKey,
            child: Container(
              color: const Color(0xff92cbdf),
              width: double.infinity,
              child: ListView.builder(
                itemBuilder: (context, index) =>
                    buildTestItem(context, rayResult[index], index),
                itemCount: rayResult.length,
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
            OurCubit.get(context).editRayResult();
              if (rayResult.isEmpty) {
                showToast(message: 'الرجاء اضافة صورة أشعة ', color: Colors.red);
                 OurCubit.get(context).editRayResult();
              } else if (OurCubit.get(context).selectedRayType.length !=
                  rayResult.length) {
                showToast(
                    message: 'الرجاء اختيار نوع الأشعة', color: Colors.red);
                    OurCubit.get(context).editRayResult();
              } else if (!formKey.currentState!.validate()) {
                 OurCubit.get(context).editRayResult();
              } else {
                OurCubit.get(context).valueOfSelectedRayType= OurCubit.get(context).selectedRayType.values.toList();
                OurCubit.get(context).uploadPhotoRays(
                    rayResult: rayResult,
                    dates: dates,
                    medicalId: OurCubit.get(context).medicalDetailsId);
              }
            
          },
          backgroundColor: Colors.white,
          child:const Icon( Icons.done,
            color: const Color(0xff92cbdf),
          ),
        ),
      ),
    );
  }

  Widget buildTestItem(context, XFile _image, int index) => Padding(
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
                height: MediaQuery.of(context).size.height * 0.70,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
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
                        IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (con) => AlertDialog(
                                  content: const Text(
                                        'هل أنت متأكد أنك تريد حذف صورة الأشعة؟'),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          rayResult.removeAt(index);
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
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      '  يرجى اختيار تاريخ الأشعة:',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      onTap: () {
                        showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.parse(
                                    '${DateTime.now().year + 1}-12-31'))
                            .then((value) async {
                          dates.add(value!);
                          dateControllers[index].text =
                              DateFormat.yMMMd('ar').format(value);
                        });
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "الرجاء عدم ترك الحقل فارغاً";
                        }
                        return null;
                      },
                      controller: dateControllers[index],
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(
                          Icons.watch_later_outlined,
                        ),
                        labelText: "تاريخ الأشعة ",
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      alignment: AlignmentDirectional.topStart,
                      padding: const EdgeInsetsDirectional.only(start: 20),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          hint: Text(
                            'نوع الأشعة',
                            style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).hintColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          items: OurCubit.get(context)
                              .rayTypes
                              .map((key, value) {
                                return MapEntry(
                                    key,
                                    DropdownMenuItem<String>(
                                      value: key.toString(),
                                      child: Text(value.toString()),
                                    ));
                              })
                              .values
                              .toList(),
                          value: OurCubit.get(context).selectedRayType[index],
                          icon: const Icon(
                            Icons.arrow_forward_ios_outlined,
                          ),
                          onChanged: (value) {
                            OurCubit.get(context)
                                .selectedRayTypes(value, index);
                          },
                          buttonHeight: 40,
                          buttonWidth: 130,
                          itemHeight: 60,
                          dropdownMaxHeight: 200,
                          dropdownWidth: 200,
                          dropdownPadding: null,
                          dropdownDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: Colors.white,
                          ),
                          dropdownElevation: 8,
                          scrollbarRadius: const Radius.circular(40),
                          scrollbarThickness: 6,
                          scrollbarAlwaysShow: true,
                          offset: const Offset(-20, 0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}