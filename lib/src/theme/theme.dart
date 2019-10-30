import 'package:flutter/material.dart';

ThemeData gratefulTheme(ThemeData appTheme) {
  return appTheme.copyWith(
      accentColor: Color.fromRGBO(200, 200, 200, 1),
      primaryColor: Color.fromRGBO(90, 90, 90, 1),
      appBarTheme: AppBarTheme(iconTheme: IconThemeData(color: Colors.white)),
      backgroundColor: Colors.blue[900]);
}
