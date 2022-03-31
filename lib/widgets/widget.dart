import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context){
  return AppBar(
    // title: Text('Hello Phong'),
  );
}

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.white54),
      focusedBorder:
      const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      enabledBorder:
      const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)));
}

TextStyle simpleTextStyle() {
  return TextStyle(color: Colors.white, fontSize: 16);
}

TextStyle biggerTextStyle() {
  return TextStyle(color: Colors.white, fontSize: 18);
}