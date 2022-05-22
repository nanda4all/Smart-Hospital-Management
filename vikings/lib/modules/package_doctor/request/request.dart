import 'dart:ui';

import 'package:flutter/material.dart';

class Request extends StatelessWidget {
  const Request({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الطلبات'),
        backgroundColor: const Color(0xff92cbdf),
        centerTitle: true,
      ),
      body: Container(
        color: const Color(0xff92cbdf),
        width: double.infinity,
        child: ListView.builder(
          itemBuilder: (context, index) => buildRequestItem(context),
          itemCount: 4,
        ),
      ),
    );
  }
}

Widget buildRequestItem(context) => Padding(
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
                    '12/12/2020',
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
