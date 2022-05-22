import 'package:HMS/models/bill.dart';
import 'package:HMS/shared/cubit/cubit.dart';
import 'package:HMS/shared/cubit/states.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:HMS/modules/card/card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ShowBillForPatient extends StatelessWidget {
  const ShowBillForPatient({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OurCubit, OurStates>(
        listener: (context, state) {
          if (state is BannedPatient) {
          OurCubit.get(context).bannedPatient(state.message, context);
        }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('الفواتير'),
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
            ), //AppBar
            body: ConditionalBuilder(
                condition: state is! LoadingBills && state is! EmptyBills,
                fallback: (context) {
                  if (state is EmptyBills) {
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
                builder: (context) {
                  return Container(
                    color: const Color(0xff92cbdf),
                    width: double.infinity,
                    child: ListView.builder(
                      itemBuilder: (context, index) => buildBillItem(
                        OurCubit.get(context).bills[index],
                      ),
                      itemCount: OurCubit.get(context).bills.length,
                    ),
                  );
                }),
          );
        });
  }

  Widget buildBillItem(bill) => Padding(
        padding: const EdgeInsets.all(15.0),
        child: BillCard(
          bill: bill,
        ),
      );
}
