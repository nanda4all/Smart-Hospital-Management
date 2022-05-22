// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FullScreenImage extends StatelessWidget {
  // FullScreenImage({Key? key, required XFile image}) : super(key: key);
  late XFile? _image;
  late String? imagePath;
  FullScreenImage({Key? key, image, String? path}) : super(key: key) {
    _image = image;
    imagePath = path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff92cbdf),
      ),
      body: SafeArea(
        child: Center(
          child: InteractiveViewer(
            boundaryMargin: const EdgeInsets.all(20.0),
            minScale: 0.1,
            maxScale: 3.6,
            child: Container(
              color: Colors.black,
              width: double.infinity,
              height: double.infinity,
              child: ConditionalBuilder(
                condition: _image != null&& imagePath==null,
                builder:(context) =>  FittedBox(
                    child: Image.file(
                      File(_image!.path),
                    ),
                    fit: BoxFit.contain),
                    fallback: (context) =>Image(
                      image: NetworkImage(imagePath!)
                      ) ,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
