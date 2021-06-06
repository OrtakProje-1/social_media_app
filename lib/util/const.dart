import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Constants {
  static String appName = 'Social Club';
  static Color iconColor = Color(0xff0aaf51);
  static Color disableIconColor = Color(0xffbdbdbd);
  static Color bottombarBackgroundColor = Colors.black;
}

const kPrimaryColor = Color(0xFF00BF6D);
const kSecondaryColor = Color(0xFFFE9901);
const kContentColorLightTheme = Color(0xFF1D1D35);
const kContentColorDarkTheme = Color(0xFFF5FCF9);
const kWarninngColor = Color(0xFFF3BB1C);
const kErrorColor = Color(0xFFF03738);
final Color recMesColor = kPrimaryColor.withOpacity(0.2);

const kDefaultPadding = 20.0;

Color getMessageColor(String? senderUid, String myUid) {
  return senderUid == myUid ? kPrimaryColor : recMesColor;
}

Color getMessageTextColor(String? senderUid, String myUid) {
  return senderUid == myUid
      ? Colors.white.withOpacity(0.9)
      : Colors.white.withOpacity(0.9);
}

int getIdFromUid(String uid){
  AsciiCodec codec=AsciiCodec();
  double id=0;
  codec.encode(uid).asMap().forEach((key, value) {
    id+=value*key;
  });
  print(uid+" === "+id.toInt().toString());
  return id.toInt();
}

Widget logoText({double size1=25,double size2=23,bool isMini=false}) {
  return Text.rich(
    TextSpan(
      text: isMini ? "S" : "Social",
      style: GoogleFonts.lobster(fontSize: size1, color: kPrimaryColor),
      children: [
        TextSpan(
          text:isMini ? "c" : " Club",
          style: GoogleFonts.lobster(fontSize: size2, color: Colors.white),
        ),
      ],
    ),
  );
}

bool isNotNull(List<PlatformFile>? data) {
  if (data != null) {
    if (data.isNotEmpty) {
      return true;
    }
    return false;
  }
  return false;
}

bool isThereData<T>(T data) {
  if (data != null) {
    return true;
  }
  return false;
}
