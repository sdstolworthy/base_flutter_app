import 'package:flutter/material.dart';

ThemeData gratefulTheme(ThemeData appTheme) {
  return appTheme
      .copyWith(brightness: Brightness.dark, accentColor: Colors.white)
      .copyWith(
          primaryColor: Color.fromRGBO(90, 90, 90, 1),
          appBarTheme: AppBarTheme(
              iconTheme: IconThemeData(color: Colors.white),
              color: Colors.blue[900]),
          backgroundColor: Colors.blue[900],
          cardTheme: CardTheme(color: Colors.blue[900], elevation: 2.0),
          buttonColor: Colors.blue[600],
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.blue[600],
            textTheme: ButtonTextTheme.primary,
          ),
          primaryTextTheme: TextTheme(
              body1:
                  appTheme.primaryTextTheme.body1.copyWith(color: Colors.white),
              body2: appTheme.primaryTextTheme.body1.copyWith(
                  color: Colors.lightBlue[100],
                  decoration: TextDecoration.underline),
              headline: appTheme.primaryTextTheme.headline
                  .copyWith(color: Colors.white)));
}
