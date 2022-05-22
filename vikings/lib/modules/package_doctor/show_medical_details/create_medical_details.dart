import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/components/components.dart';
import '../../../shared/cubit/cubit.dart';
import '../../../shared/cubit/states.dart';

class CreateMedicalDetails extends StatefulWidget {
  CreateMedicalDetails({Key? key}) : super(key: key);

  @override
  State<CreateMedicalDetails> createState() => _CreateMedicalDetailsState();
}

class _CreateMedicalDetailsState extends State<CreateMedicalDetails> {
  String? bloodTypeDropdownValue;
  List<String> bloodTypeDropdownItems = [
    'A+',
    'A-',
    'B+',
    'B-',
    'O+',
    'O-',
    'AB+',
    'AB-'
  ];
  Map<int, GlobalKey<FormFieldState>?> allergiesKeys = {};

  Map<int, GlobalKey<FormFieldState>?> familyKeys = {};

  Map<int, GlobalKey<FormFieldState>?> chronicKeys = {};

  final plansControllers = TextEditingController();

  final needControllers = TextEditingController();

  Map<int, Widget?> removeIconForAllergies = {};

  Map<int, Widget?> removeIconForfamily = {};

  Map<int, Widget?> removeIconForchronic = {};

  Map<int, Widget?> widgetlistForAllergies = {};

  Map<int, Widget?> widgetlistForfamily = {};

  Map<int, Widget?> widgetlistForchronic = {};

  bool isAllergiesShown = false;
  bool isFamilyDiseasesShown = false;
  bool isChronicDiseasesShown = false;

  var formKey = GlobalKey<FormState>();

  List<String> allergies = [];
  List<String> family = [];
  List<String> chronic = [];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OurCubit, OurStates>(
      listener: (context, state) {
        if (state is SuccessCreateMedicalDetails) {
          showToast(message: state.message, color: Colors.green);
          Navigator.of(context).pushNamed('/ShowPatientsForDoctor');
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('انشاء ملف طبي'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pushNamed('/ShowPatientsForDoctor');
              },
            ),
            backgroundColor: const Color(0xff92cbdf),
            centerTitle: true,
          ),
          body: Form(
            key: formKey,
            child: Container(
              color: const Color(0xff92cbdf),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text(
                            'زمرة الدم : ',
                            style: TextStyle(
                              fontSize: 23,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Container(
                            alignment: AlignmentDirectional.topStart,
                            padding:
                                const EdgeInsetsDirectional.only(start: 20),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2<String>(
                                isExpanded: true,
                                hint: Text(
                                  'زمرة الدم',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Theme.of(context).hintColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                items: bloodTypeDropdownItems
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                value: bloodTypeDropdownValue,
                                icon: const Icon(
                                  Icons.arrow_forward_ios_outlined,
                                ),
                                onChanged: (String? value) {
                                  setState(() {
                                    bloodTypeDropdownValue = value!;
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
                        color: Colors.black.withOpacity(0.3),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'الخطة العلاجية : ',
                        style: TextStyle(
                          fontSize: 23,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: plansControllers,
                        maxLines: 3,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "الرجاء عدم ترك الحقل فارغاً";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(
                            Icons.text_fields_outlined,
                          ),
                          labelText: 'تعديل الخطة العلاجية',
                        ),
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
                      const Text(
                        'الاحتياجات الخاصة : ',
                        style: TextStyle(
                          fontSize: 23,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: needControllers,
                        maxLines: 3,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "الرجاء عدم ترك الحقل فارغاً";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(
                            Icons.text_fields_outlined,
                          ),
                          labelText: 'تعديل الاحتياجات الخاصة',
                        ),
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
                      const Text(
                        'الحساسيات : ',
                        style: TextStyle(
                          fontSize: 23,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          await OurCubit.get(context).displayAllAllergies();
                          isAllergiesShown = true;
                          var index = widgetlistForAllergies.length;
                          allergiesKeys[index] = GlobalKey<FormFieldState>();
                          removeIconForAllergies[index] = remove(
                              allergiesKeys[index],
                              widgetlistForAllergies,
                              allergiesKeys,
                              removeIconForAllergies,
                              index,
                              deleteList:
                                  OurCubit.get(context).allergiesSelcted);
                          widgetlistForAllergies[index] = (allergyDropDown(
                            index: index,
                            key: allergiesKeys[index],
                          ));
                        },
                        icon: const Icon(
                          Icons.add,
                          color: Colors.black,
                        ),
                      ),
                      Visibility(
                        visible: isAllergiesShown,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                                children: chekList(
                                    widgetlistForAllergies.values.toList())),
                            Column(
                              children: chekList(
                                  removeIconForAllergies.values.toList()),
                            )
                          ],
                        ),
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
                      const Text(
                        'الامراض العائلية : ',
                        style: TextStyle(
                          fontSize: 23,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          await OurCubit.get(context).displayDiseasesTypes();
                          isFamilyDiseasesShown = true;
                          var index = widgetlistForfamily.length;
                          familyKeys[index] = GlobalKey<FormFieldState>();
                          removeIconForfamily[index] = remove(
                              familyKeys[index],
                              widgetlistForfamily,
                              familyKeys,
                              removeIconForfamily,
                              index,
                              deleteList: OurCubit.get(context)
                                  .diseasesTypesSelctedForFamily,
                              disease: OurCubit.get(context)
                                  .diseasesSelctedForFamily);
                          widgetlistForfamily[index] = (familyDropDown(
                            index: index,
                            key: familyKeys[index],
                          ));
                        },
                        icon: const Icon(
                          Icons.add,
                          color: Colors.black,
                        ),
                      ),
                      Visibility(
                        visible: isFamilyDiseasesShown,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                                children: chekList(
                                    widgetlistForfamily.values.toList())),
                            Column(
                              children:
                                  chekList(removeIconForfamily.values.toList()),
                            )
                          ],
                        ),
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
                      const Text(
                        'الامراض المزمنة : ',
                        style: TextStyle(
                          fontSize: 23,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          await OurCubit.get(context).displayDiseasesTypes();
                          isChronicDiseasesShown = true;
                          var index = widgetlistForchronic.length;
                          chronicKeys[index] = GlobalKey<FormFieldState>();
                          removeIconForchronic[index] = remove(
                              chronicKeys[index],
                              widgetlistForchronic,
                              chronicKeys,
                              removeIconForchronic,
                              index,
                              deleteList: OurCubit.get(context)
                                  .diseasesTypesSelctedForChronic,
                              disease: OurCubit.get(context)
                                  .diseasesSelctedForChronic);
                          widgetlistForchronic[index] = (chronicDropDown(
                            index: index,
                            key: chronicKeys[index],
                          ));
                        },
                        icon: const Icon(
                          Icons.add,
                          color: Colors.black,
                        ),
                      ),
                      Visibility(
                        visible: isChronicDiseasesShown,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                                children: chekList(
                                    widgetlistForchronic.values.toList())),
                            Column(
                              children: chekList(
                                  removeIconForchronic.values.toList()),
                            )
                          ],
                        ),
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
                      Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(20)),
                        child: MaterialButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              OurCubit.get(context)
                                  .allergiesSelcted
                                  .forEach((key, value) {
                                allergies.add(value!);
                              });
                              OurCubit.get(context)
                                  .diseasesSelctedForFamily
                                  .forEach((key, value) {
                                family.add(value!);
                              });
                              OurCubit.get(context)
                                  .diseasesSelctedForChronic
                                  .forEach((key, value) {
                                chronic.add(value!);
                              });
                              if (bloodTypeDropdownValue != null) {
                                OurCubit.get(context).createMedicalDetails(
                                    paId: OurCubit.get(context)
                                        .patientIdForMedicalDetails,
                                    bloodType: bloodTypeDropdownValue!,
                                    plans: plansControllers.text,
                                    needs: needControllers.text,
                                    allAllergies: allergies,
                                    family: family,
                                    chronic: chronic);
                              } else {
                                showToast(
                                    message: "الرجاء اختيار زمرة الدم",
                                    color: Colors.red);
                              }
                            }
                          },
                          child: const Text(
                            'إضافة ',
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
          ),
        );
      },
    );
  }

  Widget remove(
      Key? key,
      Map<int, Widget?> widgetList,
      Map<int, GlobalKey<FormFieldState>?> keys,
      Map<int, Widget?> removeIcon,
      int index,
      {Map<int, String?>? deleteList,
      Map<int, String?>? disease}) {
    return Column(
      children: [
        SizedBox(
          height: 50,
          child: IconButton(
            onPressed: () {
              keys[index] = null;
              widgetList[index] = null;
              removeIcon[index] = null;
              deleteList?.remove(index);
              disease?.remove(index);
              setState(() {});
            },
            icon: const Icon(Icons.remove),
          ),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }

  Widget allergyDropDown({required int index, required key}) {
    return BlocBuilder<OurCubit, OurStates>(
        key: key,
        builder: (con, state) {
          return StatefulBuilder(
            builder: (con, state) => Container(
              alignment: AlignmentDirectional.topStart,
              padding: const EdgeInsetsDirectional.only(start: 20),
              child: DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                  isExpanded: true,
                  hint: Text(
                    ' الحساسيات',
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).hintColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  items: OurCubit.get(context)
                      .allergies
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
                  value: OurCubit.get(context).allergiesSelcted[index],
                  icon: const Icon(
                    Icons.arrow_forward_ios_outlined,
                  ),
                  onChanged: (String? value) {
                    OurCubit.get(context).chossenAllergies(value, index);
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
          );
        });
  }

  Widget familyDropDown({required int index, required key}) {
    if (OurCubit.get(context).diseases[index] == null) {
      OurCubit.get(context).diseases[index] = {};
    }
    return BlocBuilder<OurCubit, OurStates>(
        key: key,
        builder: (con, state) {
          return StatefulBuilder(
            builder: (con, setState) => Row(
              children: [
                Container(
                  alignment: AlignmentDirectional.topStart,
                  padding: const EdgeInsetsDirectional.only(start: 10),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      hint: Text(
                        ' أنواع الأمراض',
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).hintColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      items: OurCubit.get(context)
                          .diseasesTypes
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
                          .diseasesTypesSelctedForFamily[index],
                      icon: const Icon(
                        Icons.arrow_forward_ios_outlined,
                      ),
                      onChanged: (String? value) async {
                        OurCubit.get(context)
                            .chossenDiseasesTypes(value, index);
                        OurCubit.get(context).diseasesSelctedForFamily[index] =
                            null;
                        OurCubit.get(context).diseases[index] = {};
                        print(index);
                        await OurCubit.get(context)
                            .displayDiseasesByDiseasesTypes(value!, index);
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
                  padding: const EdgeInsetsDirectional.only(start: 10),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      hint: Text(
                        '  الأمراض',
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).hintColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      items: OurCubit.get(context)
                          .diseases[index]!
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
                      value:
                          OurCubit.get(context).diseasesSelctedForFamily[index],
                      icon: const Icon(
                        Icons.arrow_forward_ios_outlined,
                      ),
                      onChanged: (String? value) {
                        OurCubit.get(context)
                            .chossenDiseasesForFamily(value, index);
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
          );
        });
  }

  Widget chronicDropDown({required int index, required key}) {
    if (OurCubit.get(context).diseasesForChronic[index] == null) {
      OurCubit.get(context).diseasesForChronic[index] = {};
    }
    return BlocBuilder<OurCubit, OurStates>(
        key: key,
        builder: (con, state) {
          return StatefulBuilder(
            builder: (con, setState) => Row(
              children: [
                Container(
                  alignment: AlignmentDirectional.topStart,
                  padding: const EdgeInsetsDirectional.only(start: 10),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      hint: Text(
                        ' أنواع الأمراض',
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).hintColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      items: OurCubit.get(context)
                          .diseasesTypes
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
                          .diseasesTypesSelctedForChronic[index],
                      icon: const Icon(
                        Icons.arrow_forward_ios_outlined,
                      ),
                      onChanged: (String? value) async {
                        OurCubit.get(context)
                            .chossenDiseasesTypesForChronic(value, index);
                        OurCubit.get(context).diseasesSelctedForChronic[index] =
                            null;
                        OurCubit.get(context).diseasesForChronic[index] = {};
                        await OurCubit.get(context)
                            .displayDiseasesByDiseasesTypesForChronic(
                                value!, index);
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
                  padding: const EdgeInsetsDirectional.only(start: 10),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      hint: Text(
                        '  الأمراض',
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).hintColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      items: OurCubit.get(context)
                          .diseasesForChronic[index]!
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
                          .diseasesSelctedForChronic[index],
                      icon: const Icon(
                        Icons.arrow_forward_ios_outlined,
                      ),
                      onChanged: (String? value) {
                        OurCubit.get(context)
                            .chossenDiseasesForChronic(value, index);
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
          );
        });
  }

  List<Widget> chekList(List<Widget?> list) {
    List<Widget> validList = [];
    for (var element in list) {
      if (element != null) {
        validList.add(element);
      }
    }
    return validList;
  }
}
