import 'package:flutter/material.dart';

ThemeData flutterAppTheme = ThemeData(
    accentColor: Color.fromRGBO(200, 200, 200, 1),
    primaryColor: Color.fromRGBO(90, 90, 90, 1),
    appBarTheme: AppBarTheme(iconTheme: IconThemeData(color: Colors.white)),
    primaryTextTheme: TextTheme(
        body1: flutterAppTheme.primaryTextTheme.body1
            .copyWith(color: Colors.white),
        body2: flutterAppTheme.primaryTextTheme.body1.copyWith(
            color: Colors.lightBlue, decoration: TextDecoration.underline),
        headline: flutterAppTheme.primaryTextTheme.headline
            .copyWith(color: Colors.white)));
