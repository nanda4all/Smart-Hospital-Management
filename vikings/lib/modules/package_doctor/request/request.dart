import 'dart:ui';

import 'package:HMS/shared/components/components.dart';
import 'package:HMS/shared/components/constants.dart';
import 'package:HMS/shared/cubit/cubit.dart';
import 'package:HMS/shared/cubit/states.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Requests extends StatelessWidget {
  const Requests({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OurCubit,OurStates>(
      listener: (contex,state){
        if (state is BannedGetRequestsForDeptMgr) {
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
      },
      builder: (contex,state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('الطلبات'),
            backgroundColor: const Color(0xff92cbdf),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back,color: Colors.white,),
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/', (Route<dynamic> route) => false);
              },
            ),
          ),
          body: Container(
            color: const Color(0xff92cbdf),
            width: double.infinity,
            child: ConditionalBuilder(
              condition: state is! LoadingGetRequestsForDeptMgr && OurCubit.get(context).requests != null,
              builder: (context) {
                return ListView.builder(
                  itemBuilder: (context, index) => buildRequestItem(context,OurCubit.get(context).requests[index]),
                  itemCount: OurCubit.get(context).requests.length,
                );
              },
              fallback: (context) {
                if (state is EmptyGetRequestsForDeptMgr) {
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
              },
            ),
          ),
        );
      }
    );
  }
}

Widget buildRequestItem(context,index) => Padding(
      padding: const EdgeInsets.all(15.0),
      child: Card(
        elevation: 10,
        shadowColor: Colors.black,
        color: Colors.cyan[100],
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Flex(
              direction:Axis.vertical,
              children: [
                Center(
                  child: Text(
                    OurCubit.get(context).requests[index]['date'],
                    style: TextStyle(
                      fontSize: 25,
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
                Text(
                  'اليوم الاحد الطلب الثاني للمرض عمر هيجر والمريضة بتول النويلاتي والمريضة هدى شاكر وجميع المرضى ,,ول النويلاتي والمريضة هدى شاكر وجميع المرضى ,,,,,الموجدين في تلك المشفى ......................... ',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: MaterialButton(
                          onPressed: () {},
                          child: const Text(
                            "حذف",
                            style: TextStyle(
                              fontSize: 23,
                              color: Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: MaterialButton(
                          onPressed: () {},
                          child: const Text(
                            " تأكيد ",
                            style: TextStyle(
                              fontSize: 23,
                              color: Colors.green,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
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
