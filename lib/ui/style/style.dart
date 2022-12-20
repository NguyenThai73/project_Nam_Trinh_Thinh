import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'color.dart';

TextStyle textButtonStyle = const TextStyle(color: colorBlack, fontSize: 16);
TextStyle textButtotextAppStylenStyle = const TextStyle(color: colorBlack, fontSize: 16);

class AppStyles {
  static TextStyle appTextStyle({
    double size = 16,
    Color? color,
    FontWeight? weight,
    double letterSpacing = 1.5,
    TextOverflow? overFlow,
    TextDecoration? decoration,
  }) {
    return TextStyle(fontSize: size, color: color, fontWeight: weight, letterSpacing: letterSpacing, overflow: overFlow, decoration: decoration);
  }

  static TextStyle large({Color color = colorBlack}) {
    return appTextStyle(
      size: 38,
      color: color,
      weight: FontWeight.bold,
    );
  }

  static TextStyle medium({Color color = colorBlack}) {
    return appTextStyle(
      size: 18,
      color: color,
      weight: FontWeight.w600,
    );
  }

  static TextStyle title() {
    return appTextStyle(size: 21, color: colorWhite, weight: FontWeight.w600, overFlow: TextOverflow.ellipsis);
  }

  static TextStyle vanban() {
    return appTextStyle(size: 14, color: colorWhite, weight: FontWeight.w400, overFlow: TextOverflow.ellipsis);
  }

  static TextStyle regular({color = colorBlack}) {
    return appTextStyle(
      color: color,
      weight: FontWeight.w500,
    );
  }

  static TextStyle light({TextOverflow? overflow, Color color = colorBlack}) {
    return appTextStyle(size: 12, color: color, weight: FontWeight.w400, overFlow: overflow);
  }

  static TextStyle links() {
    return appTextStyle(
      size: 15,
      color: maincolor,
      weight: FontWeight.w600,
      decoration: TextDecoration.underline,
    );
  }

  static TextStyle titleBox() {
    return appTextStyle(
      size: 16,
      color: maincolor,
      weight: FontWeight.w600,
    );
  }
}

var styleDropDown = const InputDecoration(
  contentPadding: EdgeInsets.only(left: 14, bottom: 10),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(5),
    ),
    borderSide: BorderSide(color: Color.fromARGB(255, 102, 102, 102), width: 1),
  ),
  hintMaxLines: 1,
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(5),
    ),
    borderSide: BorderSide(color: Color.fromARGB(255, 148, 148, 148), width: 1),
  ),
);
