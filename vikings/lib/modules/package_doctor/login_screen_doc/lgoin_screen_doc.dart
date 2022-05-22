// ignore_for_file: camel_case_types, avoid_print, import_of_legacy_library_into_null_safe
import 'package:conditional_builder/conditional_builder.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:HMS/shared/components/components.dart';
import 'package:HMS/shared/components/constants.dart';
import 'package:HMS/shared/cubit/login_cubit.dart';
import 'package:HMS/shared/cubit/login_states.dart';

class LoginScreenDoc extends StatelessWidget {
  LoginScreenDoc({Key? key}) : super(key: key);
  final emailController = TextEditingController();
  final passwprdController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return BlocConsumer<LoginCubit, LogInStates>(listener: (cupit, state) {
      if (state is LogInDoctorSuccessState) {
        if (state.loginModel.status) {
          showToast(
              message: state.loginModel.message.toString(),
              color: Colors.green);
          sharedPreferences.setInt('docId', state.loginModel.data!.id);
          sharedPreferences.setInt('hoId', state.loginModel.data!.hoId);
          sharedPreferences
              .setBool('isManager', state.loginModel.data!.isManager)
              .then((value) {
            docId = sharedPreferences.getInt('docId');
            isManager = sharedPreferences.getBool('isManager');
            hoId = sharedPreferences.getInt('hoId');
            print(hoId!);
            isLogin = true;
            if (!state.loginModel.data!.isManager) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/doctorMaster', (Route<dynamic> route) => false);
            } else {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/MgrdoctorMaster', (Route<dynamic> route) => false);
            }
          });
        } else {
          showToast(
              message: state.loginModel.message.toString(), color: Colors.red);
          print(state.loginModel.message);
        }
      }
    }, builder: (context, state) {
      LoginCubit cupit = LoginCubit.get(context);
      return Scaffold(
        appBar: AppBar(
          leading: const Text(""),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.keyboard_arrow_left,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
          backgroundColor: const Color(0xff92cbdf),
          foregroundColor: Colors.white,
          title: Container(
            alignment: AlignmentDirectional.center,
            child: const Text(
              "تسجيل الدخول",
            ),
          ),
          elevation: 0.0,
        ),
        body: ConditionalBuilder(
          condition: state is! LoadingGetHospitalState,
          builder: (context) => Container(
            color: const Color(0xff92cbdf),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsetsDirectional.only(
                    top: height * 0.05,
                    start: width * 0.05,
                    end: width * 0.05,
                    bottom: height * 0.12),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const CircleAvatar(
                        radius: 60,
                        backgroundImage:
                            AssetImage("lib/assets/images/doctor.jpg"),
                      ),
                      SizedBox(
                        height: height*0.0156,
                      ),
                      const Text(
                        "الدكتور",
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            color: Colors.white),
                      ),
                      SizedBox(
                          height: height*0.0625,
                        ),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "الرجاء عدم ترك الحقل فارغاً";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(
                            Icons.email,
                          ),
                          labelText: "البريد الالكتروني",
                        ),
                      ),
                      SizedBox(
                        height: height*0.03125,
                      ),
                      TextFormField(
                        controller: passwprdController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: cupit.click,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "الرجاء عدم ترك الحقل فارغاً";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(
                            Icons.lock,
                          ),
                          suffixIcon: IconButton(
                              onPressed: () {
                                cupit.clicked();
                              },
                              icon: Icon(
                                cupit.click
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              )),
                          labelText: "كلمة المرور",
                        ),
                      ),
                      SizedBox(
                        height: height*0.024,
                      ),
                      Container(
                        alignment: AlignmentDirectional.topStart,
                        padding: EdgeInsetsDirectional.only(start: width*0.055),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                            isExpanded: true,
                            hint: Text(
                              'المشافي',
                              style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).hintColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            items: cupit.hospitals
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
                            value: cupit.selectedValue,
                            icon: const Icon(
                              Icons.arrow_forward_ios_outlined,
                            ),
                            onChanged: (value) {
                              cupit.selected(value);
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
                      SizedBox(
                        height: height*0.024,
                      ),
                      ConditionalBuilder(
                        condition: state is! LogInLoadingState,
                        builder: (constext) => MaterialButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              if (cupit.selectedValue == null) {
                                showToast(
                                    message: 'الرجاء اختيار مشفى',
                                    color: Colors.red);
                              } else {
                                await cupit.userLoginDoctor(
                                    email: emailController.text,
                                    password: passwprdController.text,
                                    hoId: cupit.selectedValue!);
                              }
                            }
                          },
                          child: Container(
                            width: width * 0.9,
                            padding: EdgeInsets.symmetric(
                              vertical: height*0.0156,
                              horizontal: width*0.028,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                            ),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: const Center(
                              child: Text(
                                "تسجيل الدخول",
                                style: TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff92cbdf),
                                ),
                              ),
                            ),
                          ),
                        ),
                        fallback: (context) => const Center(
                            child: CircularProgressIndicator(
                          color: Colors.white,
                        )),
                      ),
                    ],
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
      );
    });
  }
}
