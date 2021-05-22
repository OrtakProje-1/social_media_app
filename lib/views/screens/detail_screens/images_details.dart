import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/util/const.dart';

class ImagesDetail extends StatefulWidget {
  final List<PlatformFile> files;
  ImagesDetail({Key key, this.files}) : super(key: key);

  @override
  _ImagesDetailState createState() => _ImagesDetailState(files: files);
}

class _ImagesDetailState extends State<ImagesDetail> {
  List<PlatformFile> files;
  int selectIndex = 0;
  PageController _pageController;

  _ImagesDetailState({this.files});

  @override
  void initState() { 
    super.initState();
    _pageController=PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: PageView.builder(
              controller: _pageController,
              itemCount: files.length,
              onPageChanged: (i) {
                setState(() {
                  selectIndex=i;
                });
              },
              itemBuilder: (c, i) {
                return Center(
                    child: SafeArea(
                        child: Image.file(
                  File(files[i].path),
                  fit: BoxFit.cover,
                )));
              },
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: AppBar(
              backgroundColor: Colors.grey.shade300.withOpacity(0.6),
              title: Text("User"),
              actions: [
                IconButton(
                  icon: Icon(Icons.delete_outline),
                  onPressed: () {
                    if (files.length == 1) {
                      Navigator.pop(context);
                    } else {
                      files.removeAt(selectIndex);
                      setState(() {
                        selectIndex > 1 ? selectIndex-- : selectIndex = 0;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 60,
              color: Colors.grey.shade300.withOpacity(0.6),
              child: ListView.builder(
                padding: EdgeInsets.all(5),
                scrollDirection: Axis.horizontal,
                itemCount: files.length+1,
                itemBuilder: (c, i) {
                  if(i==0){
                    return DottedBorder(
                      radius: Radius.circular(8),
                      borderType: BorderType.RRect,
                      child: Container(
                        width: 50,
                        child: Center(
                          child: Icon(Icons.add_photo_alternate_outlined),
                        ),
                      ),
                    );
                  }
                  PlatformFile file = files[i-1];
                  return GestureDetector(
                    onTap: () async{
                      setState(() {
                        selectIndex = i-1;
                      });
                    await  _pageController.animateToPage(selectIndex, duration:Duration(milliseconds: 400), curve:Curves.linear);
                    },
                    child: Container(
                      width: 50,
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: selectIndex == i-1
                              ? kPrimaryColor.withOpacity(0.9)
                              : Colors.transparent,
                        ),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: FileImage(File(file.path))),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
