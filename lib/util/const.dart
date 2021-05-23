import 'package:flutter/material.dart';

class Constants {
  static String appName = 'FlutterS';
  static Color iconColor= Color(0xff0aaf51);
  static Color disableIconColor= Color(0xffbdbdbd);
  static Color bottombarBackgroundColor=Color(0xff171819);
}
const kPrimaryColor = Color(0xFF00BF6D);
const kSecondaryColor = Color(0xFFFE9901);
const kContentColorLightTheme = Color(0xFF1D1D35);
const kContentColorDarkTheme = Color(0xFFF5FCF9);
const kWarninngColor = Color(0xFFF3BB1C);
const kErrorColor = Color(0xFFF03738);
final Color recMesColor = kPrimaryColor.withOpacity(0.1);

const kDefaultPadding = 20.0;

Color getMessageColor(String senderUid,String myUid){
  return senderUid==myUid ? kPrimaryColor : recMesColor;
}

Color getMessageTextColor(String senderUid,String myUid){
  return senderUid==myUid ? Colors.white.withOpacity(0.9) : Colors.black;
}
