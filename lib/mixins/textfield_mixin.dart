import 'package:flutter/material.dart';

mixin TextFieldMixin {
  Container buildTextField(
      {Size size, Icon prefixIcon, String hintText, Icon suffixIcon}) {
    return Container(
      width: size.width > 700 ? 300 : size.width,
      child: Card(
        margin: EdgeInsets.only(left: 30, right: 30, top: 30),
        elevation: 11,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(40))),
        child: TextField(
          decoration: InputDecoration(
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.black26),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(40.0)),
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0)),
        ),
      ),
    );
  }
}
