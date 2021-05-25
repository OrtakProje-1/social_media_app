

import 'package:flutter/material.dart';

mixin TextFieldMixin {
  Container buildTextField(
      {required Size size, Icon? prefixIcon, String? hintText, Icon? suffixIcon,required BuildContext context}) {
    return Container(
      width: size.width > 700 ? 300 : size.width,
      child: Card(
        margin: EdgeInsets.only(left: 30, right: 30, top: 30),
        elevation: 11,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(40))),
        child: TextField(
          cursorColor: Theme.of(context).textTheme.bodyText1!.color,
          cursorRadius: Radius.circular(8),
          cursorWidth: 1.5,
          decoration: InputDecoration(
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              hintText: hintText,
              filled: true,
              fillColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.1),
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
