import 'package:flutter/material.dart';

ThemeData gratefulTheme(ThemeData appTheme) {
  return appTheme
      .copyWith(
        brightness: Brightness.dark,
        // accentColor: Colors.white,
      )
      .copyWith(
        // primaryColor: Color.fromRGBO(90, 90, 90, 1),
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
        canvasColor: Colors.indigo[900],
        inputDecorationTheme: appTheme.inputDecorationTheme.copyWith(
            labelStyle:
                TextStyle(color: Colors.white70, fontFamily: 'Raleway')),
        primaryTextTheme: TextTheme(
            button: appTheme.primaryTextTheme.button
                .copyWith(fontFamily: 'Raleway'),
            body1: appTheme.primaryTextTheme.body1.copyWith(
                color: Colors.white, fontFamily: 'Raleway', fontSize: 16),
            body2: appTheme.primaryTextTheme.body1.copyWith(
                color: Colors.white, fontSize: 20, fontFamily: 'Raleway'),
            headline: appTheme.primaryTextTheme.headline.copyWith(
                color: Colors.white, fontFamily: 'MontserratSemiBold'),
            subhead: appTheme.primaryTextTheme.subhead.copyWith(
                fontFamily: 'MontserratSemiBold',
                fontStyle: FontStyle.italic,
                fontSize: 18),
            title: appTheme.primaryTextTheme.title
                .apply(fontFamily: 'MontSerratRegular'),
            display1: appTheme.primaryTextTheme.display1
                .copyWith(fontFamily: 'MontserratRegular')),
        accentTextTheme: appTheme.accentTextTheme.copyWith(
          headline: appTheme.accentTextTheme.headline.copyWith(
            fontFamily: 'Raleway',
          ),
          body1: appTheme.primaryTextTheme.body1.copyWith(
              color: Colors.lightBlue[100],
              decoration: TextDecoration.underline,
              fontFamily: 'Raleway'),
        ),
      );
}
