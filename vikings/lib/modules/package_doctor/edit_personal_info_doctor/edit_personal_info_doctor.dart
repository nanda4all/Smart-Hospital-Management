// ignore_for_file: prefer_const_constructors
import 'package:conditional_builder/conditional_builder.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../shared/components/components.dart';
import '../../../shared/components/constants.dart';
import '../../../shared/cubit/cubit.dart';
import '../../../shared/cubit/states.dart';

class EditPersonalInfoDoctor extends StatefulWidget {
  const EditPersonalInfoDoctor({Key? key}) : super(key: key);

  @override
  State<EditPersonalInfoDoctor> createState() => _EditPersonalInfoDoctorState();
}

class _EditPersonalInfoDoctorState extends State<EditPersonalInfoDoctor> {
  List<String> socialDropdownItems = [
    'عازب/ة',
    'متزوج/ة',
  ];

  late String socialDropdownValue = 'عازب/ة';
  late List<String> phoneNumbers = [];
  late String? dropdownValueCity = '';
  late String? dropdownValueArea = '';
  var familyMembersController = TextEditingController();
  var qualificationsController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OurCubit, OurStates>(
      listener: (context, state) {
        if (state is SuccessEditPerosnal) {
          showToast(message: state.message, color: Colors.green);
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
        } else if (state is SuccesGetPersonalInfo) {
          familyMembersController.text =
              OurCubit.get(context).docInfo[0]['family'].toString();
          socialDropdownValue = OurCubit.get(context).docInfo[0]['social'];
          qualificationsController.text =
              OurCubit.get(context).docInfo[0]['qual'];
          dropdownValueCity =
              OurCubit.get(context).docInfo[0]['cityId'].toString();
          dropdownValueArea =
              OurCubit.get(context).docInfo[0]['areaId'].toString();
          if (OurCubit.get(context).docInfo[0]['phone'].length > 0) {
            widgetlist = [];
            controllers = [];
            keys = [];
            r = [];
            for (var i = 0;
                i < OurCubit.get(context).docInfo[0]['phone'].length;
                i++) {
              var index = widgetlist.length;
              controllers.add(TextEditingController());
              keys.add(GlobalKey<FormFieldState>());
              r.add(remove(keys[index]));
              widgetlist.add(textInput(
                  controller: controllers[index],
                  key: keys[index],
                  context: context));
              controllers[i].text = OurCubit.get(context).docInfo[0]['phone'][i]
                  ['doctor_Phone_Number'];
            }
          }
        }
      },
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          title: const Text('تعديل البيانات الشخصية'),
          backgroundColor: const Color(0xff92cbdf),
          centerTitle: true,
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
        ),
        body: ConditionalBuilder(
          condition: state is! LoadingGetPersonalInfo,
          builder: (context) => Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        OurCubit.get(context).docInfo[0]['name'],
                        style: const TextStyle(
                          fontSize: 23,
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
                        Expanded(
                          child: Text(
                            ':الحالة الاجتماعية',
                            style: TextStyle(
                              fontSize: 23,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          child: DropdownButton(
                            value: socialDropdownValue,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            onChanged: (String? newValue) {
                              setState(() {
                                socialDropdownValue = newValue!;
                              });
                            },
                            items: socialDropdownItems
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
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
                        Expanded(
                          child: Text(
                            ':عدد أفراد الأسرة',
                            style: TextStyle(
                              fontSize: 23,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: familyMembersController,
                            decoration: InputDecoration(
                                suffixIcon: Icon(Icons.family_restroom)),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "الرجاء عدم ترك الحقل فارغ";
                              }
                              return null;
                            },
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
                    Row(children: [
                      Text(
                        'رقم الموبايل: ',
                        style: TextStyle(
                          fontSize: 23,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () {
                          var index = widgetlist.length;
                          controllers.add(TextEditingController());
                          keys.add(GlobalKey<FormFieldState>());
                          r.add(remove(keys[index]));
                          widgetlist.add(textInput(
                              controller: controllers[index],
                              key: keys[index],
                              context: context));
                          setState(() {});
                        },
                        icon: Icon(
                          Icons.add,
                          color: Colors.black,
                        ),
                      ),
                    ]),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(children: widgetlist),
                        Column(
                          children: r,
                        )
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
                    Text(
                      'السكن: ',
                      style: TextStyle(
                        fontSize: 23,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          alignment: AlignmentDirectional.topStart,
                          padding: const EdgeInsetsDirectional.only(start: 20),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              isExpanded: true,
                              items: OurCubit.get(context)
                                  .cities
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
                              value: dropdownValueCity,
                              icon: const Icon(
                                Icons.arrow_forward_ios_outlined,
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValueArea = null;
                                  OurCubit.get(context).areas = {};
                                  dropdownValueCity = newValue!;
                                  OurCubit.get(context)
                                      .displayAreasByCityId(dropdownValueCity);
                                });
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
                        Container(
                          alignment: AlignmentDirectional.topStart,
                          padding: const EdgeInsetsDirectional.only(start: 20),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              isExpanded: true,
                              hint: Text(
                                ' اختر المنطقة',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Theme.of(context).hintColor,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              items: OurCubit.get(context)
                                  .areas
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
                              value: dropdownValueArea,
                              icon: const Icon(
                                Icons.arrow_forward_ios_outlined,
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValueArea = newValue!;
                                });
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
                        Expanded(
                          child: Text(
                            ':المؤهلات',
                            style: TextStyle(
                              fontSize: 23,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: qualificationsController,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "الرجاء عدم ترك الحقل فارغ";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ConditionalBuilder(
                        condition: state is! LoadingEditPerosnal,
                        fallback: (context) => Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    CircularProgressIndicator(
                                      color: Color(0xff92cbdf),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        builder: (context) {
                          return Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                                color: Color(0xff92cbdf),
                                borderRadius: BorderRadius.circular(20)),
                            child: MaterialButton(
                              onPressed: () {
                                for (var i = 0; i < controllers.length; i++) {
                                  phoneNumbers.add(controllers[i].text);
                                }
                                OurCubit.get(context).editPersonalInfoDoctor(
                                  docId: docId!,
                                  dropdownValueArea: dropdownValueArea!,
                                  familyMembers: familyMembersController.text,
                                  phones: phoneNumbers,
                                  qualifications: qualificationsController.text,
                                  socialDropdownValue: socialDropdownValue,
                                );
                              },
                              child: const Text(
                                'حفظ التعديلات',
                                style: TextStyle(
                                  fontSize: 23,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        }),
                  ],
                ),
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
      ),
    );
  }

  Widget remove(Key? key) {
    return Column(
      children: [
        SizedBox(
          height: 50,
          child: IconButton(
            onPressed: () {
              var index =
                  widgetlist.indexWhere((element) => element.key == key);
              controllers.removeAt(index);
              keys.removeAt(index);
              widgetlist.removeAt(index);
              r.removeAt(index);
              setState(() {});
            },
            icon: Icon(Icons.remove),
          ),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }

  Widget textInput({required controller, required key, required context}) {
    return Column(
      key: key,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.70,
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            validator: (String? value) {
              if (value!.isEmpty) {
                return 'الرجاء عدم ترك الحقل فارغ';
              }
              if (value.length < 10 || value.length > 10) {
                return "يجب أن يحوي الرقم على عشر خانات فقط";
              }
              return null;
            },
            decoration: InputDecoration(
              label: Text('phone'),
              border: const OutlineInputBorder(),
              prefixIcon: Icon(
                Icons.phone,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

List<GlobalKey<FormFieldState>> keys = [];
List<TextEditingController> controllers = [];
List<Widget> r = [];
List<Widget> widgetlist = [];
