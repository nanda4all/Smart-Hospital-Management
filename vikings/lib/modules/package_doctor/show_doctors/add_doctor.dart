// ignore_for_file: must_be_immutable

import 'package:HMS/shared/components/components.dart';
import 'package:HMS/shared/cubit/cubit.dart';
import 'package:HMS/shared/cubit/states.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

class AddDoctor extends StatelessWidget {
  AddDoctor({Key? key}) : super(key: key);

  List<GlobalKey<FormFieldState>> keys = [];
  List<TextEditingController> controllers = [];
  List<Widget> r = [];
  List<Widget> widgetlist = [];

  var formKey = GlobalKey<FormState>();

  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var middleNameController = TextEditingController();
  var emailController = TextEditingController();
  var nationalNumberController = TextEditingController();
  var familyMembersController = TextEditingController();
  var qualificationsController = TextEditingController();
  var birthDateController = TextEditingController();
  var hireDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var cubit = OurCubit.get(context);
    return BlocConsumer<OurCubit, OurStates>(
      listener: (context, state) {
        if (state is FailedValidateDoctor) {
          showToast(message: state.message, color: Colors.red);
        } else if (state is SuccessCreateDoctor) {
          showToast(message: "تم إضافة الطبيب بنجاح", color: Colors.green);
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/ShowDoctors', (Route<dynamic> route) => false);
        } else if (state is BannedDoctor) {
          OurCubit.get(context).bannedDoctor(state.message, context);
        } else if (widgetlist.isEmpty) {
          controllers.add(TextEditingController());
          keys.add(GlobalKey<FormFieldState>());
          r.add(remove(keys.first, context));
          widgetlist.add(textInput(
              icon: Icons.phone,
              validate: (value) {
                if (value == '') {
                  return "الرجاء عدم ترك الحقل فارغ";
                }
                if (value.toString().length != 10) {
                  return 'الرجاء وضع رقم صحيح';
                }
                return null;
              },
              controller: controllers[0],
              key: keys.first,
              context: context,
              inputType: TextInputType.number));
        }
      },
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          title: const Text('إضافة طبيب'),
          backgroundColor: const Color(0xff92cbdf),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: ConditionalBuilder(
          condition: state is! LoadingCities,
          fallback: (context) => Container(
            color: const Color(0xff92cbdf),
            child: const Center(
              child: SpinKitWave(
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
          builder: (context) => Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'الاسم:',
                            style: TextStyle(
                              fontSize: 23,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                            child: textInput(
                          controller: firstNameController,
                          context: context,
                          inputType: TextInputType.name,
                          validate: (value) {
                            if (value == '') {
                              return "الرجاء عدم ترك الحقل فارغ";
                            }
                            return null;
                          },
                        )),
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
                            'الكنية:',
                            style: TextStyle(
                              fontSize: 23,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: lastNameController,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value == '') {
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
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'اسم الأب:',
                            style: TextStyle(
                              fontSize: 23,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: middleNameController,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value == '') {
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
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'الاسم الكامل بالانكليزي:',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value == '') {
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
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'الرقم الوطني:',
                            style: TextStyle(
                              fontSize: 23,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: nationalNumberController,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == '') {
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
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'تاريخ الميلاد:',
                            style: TextStyle(
                              fontSize: 23,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            onTap: () {
                              showDatePicker(
                                      context: context,
                                      firstDate: DateTime(1920),
                                      initialDate: DateTime.parse(
                                          '${DateTime.now().year - 23}-12-31'),
                                      lastDate: DateTime.parse(
                                          '${DateTime.now().year - 23}-12-31'))
                                  .then((value) {
                                cubit.selecteBirthDate(value);
                                birthDateController.text =
                                    DateFormat.yMd('ar').format(value!);
                              });
                            },
                            controller: birthDateController,
                            keyboardType: TextInputType.none,
                            validator: (value) {
                              if (value == '') {
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
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'الجنس:',
                            style: TextStyle(
                              fontSize: 23,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              isExpanded: true,
                              items: const [
                                DropdownMenuItem<String>(
                                  value: 'ذكر',
                                  child: Text('ذكر'),
                                ),
                                DropdownMenuItem<String>(
                                  value: 'انثى',
                                  child: Text('انثى'),
                                )
                              ],
                              value: cubit.selectedGender,
                              icon: const Icon(
                                Icons.arrow_forward_ios_outlined,
                              ),
                              onChanged: (value) {
                                cubit.selcteGender(value);
                              },
                              buttonHeight: 40,
                              buttonWidth: 130,
                              itemHeight: 60,
                              dropdownMaxHeight: 200,
                              dropdownWidth: 130,
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
                        const Expanded(
                          child: Text(
                            'الحالة الإجتماعية:',
                            style: TextStyle(
                              fontSize: 23,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              isExpanded: true,
                              items: const [
                                DropdownMenuItem<String>(
                                  value: 'عازب/ة',
                                  child: Text('عازب/ة'),
                                ),
                                DropdownMenuItem<String>(
                                  value: 'متزوج/ة',
                                  child: Text('متزوج/ة'),
                                )
                              ],
                              value: cubit.selectedSocialStatus,
                              icon: const Icon(
                                Icons.arrow_forward_ios_outlined,
                              ),
                              onChanged: (value) {
                                cubit.selecteSocialStatus(value);
                              },
                              buttonHeight: 40,
                              buttonWidth: 130,
                              itemHeight: 60,
                              dropdownMaxHeight: 200,
                              dropdownWidth: 130,
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
                        const Expanded(
                          child: Text(
                            'عدد أفراد الأسرة:',
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
                            decoration: const InputDecoration(
                                suffixIcon: Icon(Icons.family_restroom)),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value != '') {
                                if (int.parse(value!) < 0) {
                                  return "الرجاء ادخال قيمة أكبر من الصفر";
                                }
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
                      const Text(
                        'رقم الموبايل: ',
                        style: TextStyle(
                          fontSize: 23,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          var index = widgetlist.length;
                          controllers.add(TextEditingController());
                          keys.add(GlobalKey<FormFieldState>());
                          r.add(remove(keys[index], context));
                          widgetlist.add(textInput(
                              icon: Icons.phone,
                              validate: (value) {
                                if (value == '') {
                                  return "الرجاء عدم ترك الحقل فارغ";
                                }
                                if (value.toString().length != 10) {
                                  return 'الرجاء وضع رقم صحيح';
                                }
                                return null;
                              },
                              controller: controllers[index],
                              key: keys[index],
                              context: context,
                              inputType: TextInputType.number));
                          cubit.addPhoneNuber();
                        },
                        icon: const Icon(
                          Icons.add,
                          color: Colors.black,
                        ),
                      ),
                    ]),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: widgetlist),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'مواليد:',
                            style: TextStyle(
                              fontSize: 23,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Spacer(),
                        DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                            isExpanded: true,
                            items: cubit.cities
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
                            value: cubit.selectedBirthPlace,
                            icon: const Icon(
                              Icons.arrow_forward_ios_outlined,
                            ),
                            onChanged: (value) {
                              cubit.selectBirthPlace(value);
                            },
                            buttonHeight: 40,
                            buttonWidth: 130,
                            itemHeight: 60,
                            dropdownMaxHeight: 200,
                            dropdownWidth: 130,
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
                    const Text(
                      'السكن: ',
                      style: TextStyle(
                        fontSize: 23,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: [
                        DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                            isExpanded: true,
                            items: cubit.cities
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
                            value: cubit.selectedCity,
                            icon: const Icon(
                              Icons.arrow_forward_ios_outlined,
                            ),
                            onChanged: (value) {
                              cubit.selectCity(value);
                            },
                            buttonHeight: 40,
                            buttonWidth: 130,
                            itemHeight: 60,
                            dropdownMaxHeight: 200,
                            dropdownWidth: 130,
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
                        const Spacer(),
                        ConditionalBuilder(
                            condition: state is! LoadingAreas,
                            fallback: (context) =>
                                const CircularProgressIndicator(
                                  color: Color(0xff92cbdf),
                                ),
                            builder: (context) {
                              return DropdownButtonHideUnderline(
                                child: DropdownButton2<String>(
                                  isExpanded: true,
                                  items: cubit.areas
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
                                  value: cubit.selectedArea,
                                  icon: const Icon(
                                    Icons.arrow_forward_ios_outlined,
                                  ),
                                  onChanged: (value) {
                                    cubit.selectArea(value);
                                  },
                                  buttonHeight: 40,
                                  buttonWidth: 130,
                                  itemHeight: 60,
                                  dropdownMaxHeight: 200,
                                  dropdownWidth: 130,
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
                              );
                            }),
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
                            'تاريخ التعيين:',
                            style: TextStyle(
                              fontSize: 23,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            onTap: () {
                              showDatePicker(
                                      context: context,
                                      firstDate: DateTime(1920),
                                      initialDate: DateTime.now(),
                                      lastDate: DateTime.now())
                                  .then((value) {
                                cubit.selecteHireDate(value);
                                hireDateController.text =
                                    DateFormat.yMd('ar').format(value!);
                              });
                            },
                            controller: hireDateController,
                            keyboardType: TextInputType.none,
                            validator: (value) {
                              if (value == '') {
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
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'المؤهلات:',
                            style: TextStyle(
                              fontSize: 23,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            maxLines: 3,
                            controller: qualificationsController,
                            keyboardType: TextInputType.text,
                            onChanged: (value) {},
                            validator: (value) {
                              if (value == '') {
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
                    Container(
                      padding: const EdgeInsetsDirectional.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color(0xff92cbdf),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: ConditionalBuilder(
                          condition: state is! LoadingCreateDoctor,
                          fallback: (context) => const SizedBox(
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          builder: (context) {
                            return MaterialButton(
                              minWidth: MediaQuery.of(context).size.width * 0.9,
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  if (cubit.selectedGender == null ||
                                      cubit.selectedSocialStatus == null) {
                                    if (cubit.selectedGender == null) {
                                      showToast(
                                          message: 'الرجاء تحديد جنس الطبيب',
                                          color: Colors.red);
                                    }
                                    if (cubit.selectedSocialStatus == null) {
                                      showToast(
                                          message:
                                              'الرجاء تحديد الحالة الاجتماعية',
                                          color: Colors.red);
                                    }
                                  } else {
                                    List<String> numbers = [];
                                    for (var element in controllers) {
                                      numbers.add(element.text);
                                    }
                                    await cubit.addDoctor(
                                      firstName: firstNameController.text,
                                      middleName: middleNameController.text,
                                      lastName: lastNameController.text,
                                      email: emailController.text,
                                      familyMembers:
                                          familyMembersController.text == ''
                                              ? null
                                              : familyMembersController.text,
                                      nationalNumber:
                                          nationalNumberController.text,
                                      qualifications:
                                          qualificationsController.text,
                                      phoneNumbers: numbers,
                                    );
                                  }
                                }
                              },
                              child: const Center(
                                child: Text(
                                  "إضافة",
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white,
                                  ),
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
        ),
      ),
    );
  }

  Widget remove(Key? key, context) {
    return Container(
      alignment: AlignmentDirectional.center,
      height: MediaQuery.of(context).size.height * 0.1,
      child: Visibility(
        visible: key != keys.first,
        child: IconButton(
          onPressed: () {
            var index = widgetlist.indexWhere((element) => element.key == key);
            print(index);
            controllers.removeAt(index);
            keys.removeAt(index);
            widgetlist.removeAt(index);
            r.removeAt(index);
            OurCubit.get(context).removePhoneNuber();
          },
          icon: const Icon(Icons.remove),
        ),
      ),
    );
  }
}

Widget textInput(
    {required controller,
    required context,
    required inputType,
    required validate,
    icon,
    key,
    onChange}) {
  return Container(
    key: key,
    alignment: AlignmentDirectional.center,
    width: MediaQuery.of(context).size.width * 0.70,
    height: MediaQuery.of(context).size.height * 0.1,
    child: TextFormField(
      controller: controller,
      keyboardType: inputType,
      validator: validate,
      onChanged: onChange,
      decoration: InputDecoration(
        border: const UnderlineInputBorder(),
        fillColor: const Color(0xff92cbdf),
        focusColor: const Color(0xff92cbdf),
        prefixIcon: icon == null
            ? null
            : Icon(
                icon,
              ),
      ),
    ),
  );
}
