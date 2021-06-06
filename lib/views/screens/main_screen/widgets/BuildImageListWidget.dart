

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/views/screens/main_screen/widgets/build_delete_button.dart';

class BuildImageListWidget extends StatelessWidget {
  const BuildImageListWidget({
    Key? key,
    required this.size,
    required this.images,
    required this.onPressedDeleteButton,
  }) : super(key: key);

  final Size size;
  final ValueChanged<int> onPressedDeleteButton;
  final List<PlatformFile> images;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: size.width,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: images.length,
        padding: EdgeInsets.all(3),
        scrollDirection: Axis.horizontal,
        itemBuilder:
            (BuildContext context, int index) {
          return Container(
            width: 150,
            height: 150,
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: FileImage(
                    File(images[index].path!)),
              ),
            ),
            child: Stack(
              children: [
                BuildDeleteButton(
                  onPressed:()=>onPressedDeleteButton(index),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}