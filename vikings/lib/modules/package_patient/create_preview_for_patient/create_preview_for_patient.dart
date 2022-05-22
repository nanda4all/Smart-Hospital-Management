import 'package:conditional_builder/conditional_builder.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../shared/cubit/cubit.dart';
import '../../../shared/cubit/states.dart';

class CreatePreviewForPatient extends StatefulWidget {
  CreatePreviewForPatient({Key? key}) : super(key: key);

  @override
  State<CreatePreviewForPatient> createState() =>
      _CreatePreviewForPatientState();
}

class _CreatePreviewForPatientState extends State<CreatePreviewForPatient> {
  var formKey = GlobalKey<FormState>();

  String? selectedDepartment;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OurCubit, OurStates>(
      listener: (context, state) {},
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          title: const Text('حجز موعد '),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushNamed('/ShowPreviewForPatient');
            },
          ),
          backgroundColor: const Color(0xff92cbdf),
          centerTitle: true,
        ),
        body: ConditionalBuilder(
          condition: state is! LoadingDisplayDepartmentForCreatePreview,
          builder: (context) => Container(
            color: const Color(0xff92cbdf),
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.9,
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
                      '  يرجى اختيار القسم :',
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
                      padding: const EdgeInsetsDirectional.only(start: 15),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          hint: Text(
                            ' الأقسام',
                            style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).hintColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          items: OurCubit.get(context)
                              .departments
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
                          value: selectedDepartment,
                          icon: const Icon(
                            Icons.arrow_forward_ios_outlined,
                          ),
                          onChanged: (String? value) {
                            setState(() {
                              selectedDepartment = value;
                            });
                            OurCubit.get(context)
                                .displayDoctorsForCreatePreview(value);
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
                    ConditionalBuilder(
                      condition: state is SuccessDisplayDoctorForCreatePreview,
                      builder: (context) => Padding(
                        padding: const EdgeInsetsDirectional.only(start: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              ' الأطباء في القسم :',
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
                                  buildItem(context, index),
                              itemCount: OurCubit.get(context)
                                  .doctorsForCreatePreview
                                  .length,
                              physics: const NeverScrollableScrollPhysics(),
                            ),
                          ],
                        ),
                      ),
                    ),
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
}

Widget buildItem(context, int index) => Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 20),
      child: Card(
        elevation: 10,
        shadowColor: Colors.black,
        color: Colors.cyan[100],
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.35,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'اسم الطبيب : ',
                        style: TextStyle(
                          fontSize: 23,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        OurCubit.get(context).doctorsForCreatePreview[index]
                            ['name'],
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
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
                  color: Colors.black.withOpacity(0.3),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      OurCubit.get(context).doctorsForCreatePreview[index]
                          ['phone'][0]['doctor_Phone_Number'],
                      style: const TextStyle(
                        fontSize: 23,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
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
                        color: Colors.white,
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
                  color: Colors.black.withOpacity(0.3),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: MaterialButton(
                    onPressed: () {
                      OurCubit.get(context).docIdForCreatePreview =
                          OurCubit.get(context).doctorsForCreatePreview[index]
                              ['id'];
                      OurCubit.get(context).getWorkDaysForDoctor(
                          OurCubit.get(context).docIdForCreatePreview);
                      Navigator.of(context).pushNamed('/PickDateForPatient');
                    },
                    child: const Text(
                      " اختيار الطبيب ",
                      style: TextStyle(
                        fontSize: 23,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
