// This page is to set and retrive constant configuration values
//for HealthEnsure application. The main purpose of the Config class
//in the provided code is to provide a centralized place to define
//and store global constants and settings that can be used
//throughout the application.

import 'package:flutter/material.dart';

class Config {
  static MediaQueryData? mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;

  //width and height initialization
  void init(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    screenWidth = mediaQueryData!.size.width;
    screenHeight = mediaQueryData!.size.height;
  }

  static get widthSize {
    return screenWidth;
  }

  static get heightSize {
    return screenHeight;
  }

  //define spacing height
  static const tinySpacingBox = SizedBox(
    height: 10,
  );

  static const smallSpacingBox = SizedBox(
    height: 18,
  );
  static final mediumSpacingBox = SizedBox(
    height: screenHeight! * 0.05,
  );
  static final largeSpacingBox = SizedBox(
    height: screenHeight! * 0.08,
  );

  //textform field border changes with different actions
  static const outlinedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(
        width: 1,
      ));

  static const focusBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(
        color: Color.fromARGB(255, 64, 251, 126),
        width: 2,
      ));
  static const errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(
        color: Color.fromARGB(255, 221, 56, 44),
        width: 1,
      ));

  static const focusErrorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(
        color: Color.fromARGB(255, 243, 25, 9),
        width: 1,
      ));

  static const enabledBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(
        color: Colors.grey,
        width: 1,
      ));

  static const primaryColor = Colors.deepPurpleAccent;
  static const secondaryColor = Color.fromARGB(255, 9, 230, 123);
}
