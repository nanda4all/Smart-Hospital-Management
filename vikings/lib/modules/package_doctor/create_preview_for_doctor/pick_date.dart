// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:conditional_builder/conditional_builder.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

import '../../../shared/components/components.dart';
import '../../../shared/components/constants.dart';
import '../../../shared/cubit/cubit.dart';
import '../../../shared/cubit/states.dart';

class PickDate extends StatelessWidget {
  PickDate({Key? key}) : super(key: key);
  late var DateContorller = TextEditingController();
  late String time;
  var hour;
  var minutes;
  late DateTime fullDate;
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OurCubit, OurStates>(
      listener: (context, state) {
        if (state is FailedValidateDateForCreatePreviewDoctor) {
          showToast(message: state.message, color: Colors.red);
        } else if (state is EmptyFreeTimeForCreatePreviewDoctor) {
          showToast(message: state.message, color: Colors.red);
        }
      },
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              OurCubit.get(context).avalibaleTimeForPreview = {};
              OurCubit.get(context).selectedTimeForPreview = null;
              Navigator.pop(context);
            },
          ),
          title: const Text('حجز موعد '),
          backgroundColor: const Color(0xff92cbdf),
          centerTitle: true,
        ),
        body: ConditionalBuilder(
          condition: state is! LoadingWorkDaysForDoc,
          builder: (context) => Container(
            color: const Color(0xff92cbdf),
            width: double.infinity,
            child: SingleChildScrollView(
              padding: const EdgeInsetsDirectional.all(15),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      '  يرجى اختيار تاريخ الموعد:',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextFormField(
                        keyboardType: TextInputType.none,
                        onTap: () {
                          showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.parse(
                                      '${DateTime.now().year + 1}-12-31'))
                              .then((value) async {
                            OurCubit.get(context).dateOfPreview = value!;
                            DateContorller.text =
                                DateFormat.yMMMd('ar').format(value);
                            if (formKey.currentState!.validate()) {
                              OurCubit.get(context).avalibaleTimeForPreview =
                                  {};
                              OurCubit.get(context).selectedTimeForPreview =
                                  null;
                              await OurCubit.get(context)
                                  .validatePreviewDateForDoctor(
                                date: OurCubit.get(context).dateOfPreview,
                                doctorId: docId!,
                                paId:
                                    OurCubit.get(context).paIdForCreatePreview,
                              );
                            }
                          });
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "الرجاء عدم ترك الحقل فارغاً";
                          }
                          return null;
                        },
                        controller: DateContorller,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(
                            Icons.watch_later_outlined,
                          ),
                          labelText: "تاريخ الموعد ",
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Visibility(
                        visible: state
                                is! FailedValidateDateForCreatePreviewDoctor &&
                            OurCubit.get(context)
                                .avalibaleTimeForPreview
                                .isNotEmpty,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '  يرجى اختيار توقيت الموعد:',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Container(
                              alignment: AlignmentDirectional.topStart,
                              padding:
                                  const EdgeInsetsDirectional.only(start: 20),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton2<String>(
                                  isExpanded: true,
                                  hint: Text(
                                    'الأوقات المتاحة',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Theme.of(context).hintColor,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  items: OurCubit.get(context)
                                      .avalibaleTimeForPreview
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
                                  value: OurCubit.get(context)
                                      .selectedTimeForPreview,
                                  icon: const Icon(
                                    Icons.arrow_forward_ios_outlined,
                                  ),
                                  onChanged: (value) async {
                                    OurCubit.get(context).selctedTime(value);
                                    time = OurCubit.get(context)
                                        .selectedTimeForPreview
                                        .toString();
                                    hour = time.substring(0, time.indexOf(":"));
                                    minutes = time.substring(
                                        time.indexOf(":") + 1,
                                        time.indexOf(":") + 3);
                                    fullDate = OurCubit.get(context)
                                        .dateOfPreview
                                        .add(Duration(
                                            hours: int.parse(hour),
                                            minutes: int.parse(minutes)));
                                    await OurCubit.get(context)
                                        .validateTimeForDoctorPreveiws(
                                      fullDate,
                                      OurCubit.get(context)
                                          .paIdForCreatePreview,
                                    );
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
                            const SizedBox(height: 15),
                            ConditionalBuilder(
                              condition: state is! LoadingCreatePreviewDoctor,
                              
                              builder: (constext) => MaterialButton(
                                onPressed: () async {
                                  if (state is! InvalidDatePreviewDoctor) {
                                    await OurCubit.get(context).createPreview(
                                        doctorId: docId!,
                                        paId: OurCubit.get(context)
                                            .paIdForCreatePreview,
                                        date: fullDate);

                                    OurCubit.get(context)
                                        .avalibaleTimeForPreview = {};
                                    OurCubit.get(context)
                                        .selectedTimeForPreview = null;
                                    showToast(
                                        message: 'تم حجز الموعد بنجاح',
                                        color: Colors.green);
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                            '/showPreviewsForDoc',
                                            (Route<dynamic> route) => false);
                                  } else {
                                    showToast(
                                        message: state.message,
                                        color: Colors.red);
                                  }
                                },
                                child: Container(
                                  height: 50,
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  padding: const EdgeInsetsDirectional.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white,
                                  ),
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  child: const Center(
                                    child: Text(
                                      " حجز الموعد",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w300,
                                        color: Color(0xff92cbdf),
                                      ),
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
                          ],
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      '  جدول الدوام الخاص بك :',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, index) =>
                          buildWorkDaysItem(context, index),
                      itemCount: OurCubit.get(context).workDays.length,
                      physics: const NeverScrollableScrollPhysics(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          fallback: (context) => Container(
            color: const Color(0xff92cbdf),
            child: Container(
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
      ),
    );
  }
}

Widget buildWorkDaysItem(context, int index) => Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 15.0),
      child: Card(
        elevation: 10,
        shadowColor: Colors.black,
        color: Colors.cyan[100],
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.33,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        ' اليوم : ',
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        OurCubit.get(context).workDays[index]['day'],
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
                        'وقت البدء:',
                        style: TextStyle(
                          fontSize: 23,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        OurCubit.get(context).workDays[index]['start'],
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
                        'وقت الانتهاء:',
                        style: TextStyle(
                          fontSize: 23,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        OurCubit.get(context).workDays[index]['end'],
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
                        'عدد الساعات',
                        style: TextStyle(
                          fontSize: 23,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        OurCubit.get(context)
                            .workDays[index]['hourCount']
                            .toString(),
                        style: const TextStyle(
                          fontSize: 23,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
