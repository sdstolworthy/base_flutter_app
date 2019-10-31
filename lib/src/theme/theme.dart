import 'package:flutter/material.dart';

ThemeData gratefulTheme(ThemeData appTheme) {
  return appTheme.copyWith(
      accentColor: Color.fromRGBO(200, 200, 200, 1),
      primaryColor: Color.fromRGBO(90, 90, 90, 1),
      appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: Colors.white),
          color: Colors.blue[900]),
      backgroundColor: Colors.blue[900],
      cardTheme: CardTheme(color: Colors.blue[900], elevation: 2.0),
      primaryTextTheme: TextTheme(
          body1: appTheme.primaryTextTheme.body1.copyWith(color: Colors.white),
          headline: appTheme.primaryTextTheme.headline
              .copyWith(color: Colors.white)));
}
