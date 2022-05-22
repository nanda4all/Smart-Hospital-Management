
// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Widget DefultTextFormFeild({
 required TextEditingController controller,required TextInputType type,
  required String text, InputBorder? border ,required IconData preIcon,
  IconData? sufixIcon,  Function? onSubmit, Function? onChange,
  required String? Function(String?) validate,  bool? isPassword=false,
  Function? suffixClicked
}) {
  return TextFormField(
    controller: controller,
    keyboardType: type,
    decoration:  InputDecoration(
     labelText: text,
      border: border ?? const OutlineInputBorder(),
      prefixIcon: Icon(
        preIcon,
      ) ,
      suffixIcon: IconButton(
        icon: Icon(
          sufixIcon,
        ),
        onPressed:() => suffixClicked ,
      ),
      ),
    obscureText: isPassword!,
    validator: validate,
    onFieldSubmitted: (value) => onSubmit,
    onChanged: (value) =>onChange ,
  );
}

Widget BuildTaskItem(tasks)=>Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            child: Text(
              tasks['time'] ,
            ),
          ),
         const SizedBox(
            width: 20,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:CrossAxisAlignment.start,
            children: [
              Text(
              tasks['title'],
              style:const TextStyle(
                fontSize: 16,
                fontWeight:FontWeight.bold,
              ),
            ),
            Text(
              tasks['date'],
              style:const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            ],
            
          ),
        ],
      ),
    );

    void showToast({required String message , required Color? color}) =>Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0
    );


