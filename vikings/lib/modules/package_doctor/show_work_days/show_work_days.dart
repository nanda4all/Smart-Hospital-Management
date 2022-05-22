import 'package:HMS/shared/components/constants.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:HMS/shared/cubit/cubit.dart';
import 'package:HMS/shared/cubit/states.dart';

import '../../../shared/components/components.dart';

class ShowWorkDays extends StatelessWidget {
  const ShowWorkDays({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OurCubit, OurStates>(
      listener: (context, state) {
        if (state is BannedWorkDaysForDoc) {
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
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          title: const Text('جدول الدوام'),
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
        body: ConditionalBuilder(
            condition: state is! LoadingWorkDaysForDoc &&
                state is! EmptyWorkDaysForDoc,
            builder: (context) => Container(
                  color: const Color(0xff92cbdf),
                  width: double.infinity,
                  child: ListView.builder(
                    itemBuilder: (context, index) =>
                        buildWorkDaysItem(context, index),
                    itemCount: OurCubit.get(context).workDays.length,
                  ),
                ),
            fallback: (context) {
              if (state is EmptyWorkDaysForDoc) {
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
      ),
    );
  }
}

Widget buildWorkDaysItem(context, int index) => Padding(
      padding: const EdgeInsets.all(15.0),
      child: Card(
        elevation: 10,
        shadowColor: Colors.black,
        color: Colors.cyan[100],
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.32,
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
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.0156,
                ),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.black.withOpacity(0.1),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.0156,
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
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.0156,
                ),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.black.withOpacity(0.1),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.0156,
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
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.0156,
                ),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.black.withOpacity(0.1),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.0156,
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
