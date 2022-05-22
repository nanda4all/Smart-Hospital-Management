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

class ShowEmptySurgeryRoom extends StatefulWidget {
  ShowEmptySurgeryRoom({Key? key}) : super(key: key);

  @override
  State<ShowEmptySurgeryRoom> createState() => _ShowEmptySurgeryRoomState();
}

class _ShowEmptySurgeryRoomState extends State<ShowEmptySurgeryRoom> {
  List<bool> clicked = [];
  List<int> hourForSurgeryTime = [
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20,
    21,
    22,
    23,
    24
  ];
  List<int> minuteForSurgeryTime = [0, 30];
  late String time;
  var hour;
  var minutes;
  late DateTime fullDate = DateTime.now();
  var formKey = GlobalKey<FormState>();
  List<TextEditingController> surgeryNameControllers = [];
  List<TextEditingController> surgeryDateControllers = [];
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OurCubit, OurStates>(listener: (context, state) {
      if (state is ErrorGetAvalibaleTimeForSurgery) {
        showToast(message: state.message, color: Colors.red);
      } else if (state is SuccessCreateSurgeryDoctor) {
        showToast(message: state.message, color: Colors.green);
      } else if (state is LoadingCreateSurgeryDoctor ||
          state is LoadingGetAvalibaleTimeForSurgery) {}
          else if (state is BannedCreateSurgeryDoctor) {
                      showToast(message: state.message, color: Colors.red);
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

        }
    }, builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('غرف العمليات'),
          backgroundColor: const Color(0xff92cbdf),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: ConditionalBuilder(
            condition: state is! LoadingDisplayEmptySurgeryRoom &&
                state is! ErrorDisplayEmptySurgeryRoom &&
                OurCubit.get(context).emptySergeryRooms != null,
            builder: (context) => Stack(
                  children: [
                    Form(
                      key: formKey,
                      child: Container(
                        color: const Color(0xff92cbdf),
                        width: double.infinity,
                        child: ListView.builder(
                          itemBuilder: (context, index) =>
                              buildSurgeryRoomItem(context, index, state),
                          itemCount:
                              OurCubit.get(context).emptySergeryRooms.length,
                        ),
                      ),
                    ),
                  ],
                ),
            fallback: (context) {
              if (state is ErrorDisplayEmptySurgeryRoom) {
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
    });
  }

  Widget buildSurgeryRoomItem(context, int index, state) {
    clicked.add(false);
    surgeryDateControllers.add(TextEditingController());
    surgeryNameControllers.add(TextEditingController());
    return Padding(
      key: Key(OurCubit.get(context).emptySergeryRooms[index]['id'].toString()),
      padding: const EdgeInsets.all(15.0),
      child: Flex(
        direction: Axis.vertical,
        children: [
          Card(
            elevation: 10,
            shadowColor: Colors.black,
            color: Colors.cyan[100],
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      OurCubit.get(context)
                          .emptySergeryRooms[index]['name']
                          .toString(),
                      style: const TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.black.withOpacity(0.1),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Row(
                    children: [
                      const Text(
                        'الطابق :   ',
                        style: TextStyle(
                          fontSize: 23,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        OurCubit.get(context)
                            .emptySergeryRooms[index]['floor']
                            .toString(),
                        style: const TextStyle(
                          fontSize: 23,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            clicked[index] = !clicked[index];
                          });
                        },
                        icon: Icon(
                          clicked[index]
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: clicked[index],
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            '  يرجى اختيار اسم العملية:',
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
                            keyboardType: TextInputType.name,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "الرجاء عدم ترك الحقل فارغاً";
                              }
                              return null;
                            },
                            controller: surgeryNameControllers[index],
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(
                                Icons.local_hospital_outlined,
                              ),
                              labelText: "اسم العملية",
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            '  يرجى اختيار تاريخ العملية:',
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
                            keyboardType: TextInputType.none,
                            onTap: () {
                              showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse(
                                          '${DateTime.now().year + 1}-12-31'))
                                  .then((value) async {
                                setState(() {
                                  OurCubit.get(context).selectedHourForSurgery =
                                      {};
                                  OurCubit.get(context)
                                      .selectedMinuteForSurgery = {};
                                });
                                OurCubit.get(context).dateOfSurgery = value!;
                                surgeryDateControllers[index].text =
                                    DateFormat.yMMMd('ar').format(value);
                              });
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "الرجاء عدم ترك الحقل فارغاً";
                              }
                              return null;
                            },
                            controller: surgeryDateControllers[index],
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(
                                Icons.date_range_outlined,
                              ),
                              labelText: "تاريخ العملية ",
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03,
                          ),
                          const Text(
                            '  يرجى اختيار مدة العملية:',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              const Text(
                                '  الساعات : ',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  alignment: AlignmentDirectional.topStart,
                                  padding: const EdgeInsetsDirectional.only(
                                      start: 20),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton2<String>(
                                      isExpanded: true,
                                      hint: Text(
                                        ' الساعة',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Theme.of(context).hintColor,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      items: hourForSurgeryTime
                                          .map((item) =>
                                              DropdownMenuItem<String>(
                                                value: item.toString(),
                                                child: Text(
                                                  item.toString(),
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ))
                                          .toList(),
                                      value: OurCubit.get(context)
                                          .selectedHourForSurgery[index],
                                      icon: const Icon(
                                        Icons.arrow_forward_ios_outlined,
                                      ),
                                      onChanged: (value) async {
                                        OurCubit.get(context)
                                            .selctedHourForSurgery(
                                                value, index);
                                        if (formKey.currentState!.validate()) {
                                          if (OurCubit.get(context)
                                                      .selectedMinuteForSurgery[
                                                  index] ==
                                              null) {
                                            showToast(
                                                message:
                                                    'يرجى اختيار الدقائق ثم اختيار الساعة',
                                                color: Colors.red);
                                            OurCubit.get(context)
                                                    .selectedHourForSurgery[
                                                index] = null;
                                          } else {
                                            OurCubit.get(context)
                                                .avalibaleTimeForSurgery = {};
                                            await OurCubit.get(context)
                                                .displayAvalibalTimeForSurgery(
                                              date: OurCubit.get(context)
                                                  .dateOfSurgery,
                                              hour: OurCubit.get(context)
                                                      .selectedHourForSurgery[
                                                  index],
                                              minute: OurCubit.get(context)
                                                      .selectedMinuteForSurgery[
                                                  index],
                                              srId: OurCubit.get(context)
                                                      .emptySergeryRooms[index]
                                                  ['id'],
                                            );
                                          }
                                        }
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
                                      scrollbarRadius:
                                          const Radius.circular(40),
                                      scrollbarThickness: 6,
                                      scrollbarAlwaysShow: true,
                                      offset: const Offset(-20, 0),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.02),
                          Row(
                            children: [
                              const Text(
                                '   الدقائق : ',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  alignment: AlignmentDirectional.topStart,
                                  padding: const EdgeInsetsDirectional.only(
                                      start: 20),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton2<String>(
                                      isExpanded: true,
                                      hint: Text(
                                        ' الدقائق',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Theme.of(context).hintColor,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      items: minuteForSurgeryTime
                                          .map((item) =>
                                              DropdownMenuItem<String>(
                                                value: item.toString(),
                                                child: Text(
                                                  item.toString(),
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ))
                                          .toList(),
                                      value: OurCubit.get(context)
                                          .selectedMinuteForSurgery[index],
                                      icon: const Icon(
                                        Icons.arrow_forward_ios_outlined,
                                      ),
                                      onChanged: (value) async {
                                        print(index);
                                        print(OurCubit.get(context)
                                            .selectedMinuteForSurgery);
                                        OurCubit.get(context)
                                            .selctedMinuteForSurgery(
                                                value, index);
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
                                      scrollbarRadius:
                                          const Radius.circular(40),
                                      scrollbarThickness: 6,
                                      scrollbarAlwaysShow: true,
                                      offset: const Offset(-20, 0),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Visibility(
                            visible:
                                state is! ErrorGetAvalibaleTimeForSurgery &&
                                    OurCubit.get(context)
                                        .avalibaleTimeForSurgery
                                        .isNotEmpty &&
                                    OurCubit.get(context)
                                            .selectedHourForSurgery[index] !=
                                        null,
                            child: Column(
                              children: [
                                Container(
                                  alignment: AlignmentDirectional.topStart,
                                  padding: const EdgeInsetsDirectional.only(
                                      start: 15),
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
                                          .avalibaleTimeForSurgery
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
                                          .selectedTimeForSurgery[index],
                                      icon: const Icon(
                                        Icons.arrow_forward_ios_outlined,
                                      ),
                                      onChanged: (value) {
                                        OurCubit.get(context)
                                            .selctedTimeForSurgery(
                                                value, index);
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
                                      scrollbarRadius:
                                          const Radius.circular(40),
                                      scrollbarThickness: 6,
                                      scrollbarAlwaysShow: true,
                                      offset: const Offset(-20, 0),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                ConditionalBuilder(
                                    condition:
                                        state is! LoadingCreateSurgeryDoctor,
                                    fallback: (context) => const Center(
                                            child: CircularProgressIndicator(
                                          color: Colors.white,
                                        )),
                                    builder: (context) {
                                      return Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        width: double.infinity,
                                        child: MaterialButton(
                                          onPressed: () async {
                                            if (formKey.currentState!
                                                .validate()) {
                                              if (OurCubit.get(context)
                                                              .selectedHourForSurgery[
                                                          index] ==
                                                      null ||
                                                  OurCubit.get(context)
                                                              .selectedMinuteForSurgery[
                                                          index] ==
                                                      null) {
                                                showToast(
                                                    message:
                                                        'الرجاء تعبئة مدة العملية',
                                                    color: Colors.red);
                                              } else if (OurCubit.get(context)
                                                          .selectedTimeForSurgery[
                                                      index] ==
                                                  null) {
                                                showToast(
                                                    message:
                                                        'الرجاء اختيار وقت العملية',
                                                    color: Colors.red);
                                              } else {
                                                time = OurCubit.get(context)
                                                        .selectedTimeForSurgery[
                                                    index]!;
                                                hour = time.substring(
                                                    0, time.indexOf(":"));
                                                minutes = time.substring(
                                                    time.indexOf(":") + 1,
                                                    time.indexOf(":") + 3);
                                                fullDate = OurCubit.get(context)
                                                    .dateOfSurgery
                                                    .add(Duration(
                                                        hours: int.parse(hour),
                                                        minutes: int.parse(
                                                            minutes)));
                                                await OurCubit.get(context).createSurgery(
                                                    doctorId: docId!,
                                                    paId: OurCubit.get(context)
                                                        .paIdForCreateSurgery,
                                                    srId: OurCubit.get(context)
                                                            .emptySergeryRooms[
                                                        index]['id'],
                                                    date: fullDate,
                                                    name:
                                                        surgeryNameControllers[index]
                                                            .text,
                                                    hour: OurCubit.get(context)
                                                            .selectedHourForSurgery[
                                                        index]!,
                                                    minute: OurCubit.get(context)
                                                            .selectedMinuteForSurgery[
                                                        index]!);
                                                Navigator.of(context).pushNamed(
                                                    '/SurgeryForDoctor');
                                              }
                                            }
                                          },
                                          child: const Text(
                                            " حجز الغرفة ",
                                            style: TextStyle(
                                              fontSize: 23,
                                              color: Color(0xff92cbdf),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              ],
                            ),
                          ),
                        ]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
