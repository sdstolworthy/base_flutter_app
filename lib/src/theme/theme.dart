import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData gratefulTheme(ThemeData appTheme) {
  final theme = ThemeData(brightness: Brightness.light);
  return theme
      .copyWith(
        floatingActionButtonTheme:
            FloatingActionButtonThemeData(backgroundColor: Colors.blue[300]),
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
        primaryColorLight: Colors.white,
        iconTheme: IconThemeData(color: Colors.white70),
        primaryTextTheme: TextTheme(
            button: appTheme.primaryTextTheme.button
                .copyWith(fontFamily: 'Raleway'),
            body1: GoogleFonts.montserrat()
                .copyWith(color: Colors.white, fontSize: 16),
            body2: appTheme.primaryTextTheme.body1
                .copyWith(color: Colors.white, fontSize: 20),
            headline: GoogleFonts.merriweather()
                .copyWith(color: Colors.white, fontSize: 40),
            subhead: GoogleFonts.merriweatherSans()
                .copyWith(fontStyle: FontStyle.italic, fontSize: 18),
            title: appTheme.primaryTextTheme.title
                .apply(fontFamily: 'MontSerratRegular'),
            display1: appTheme.primaryTextTheme.display1
                .copyWith(fontFamily: 'MontserratRegular')),
      )
      .copyWith(
        accentTextTheme: appTheme.accentTextTheme.copyWith(
            headline: GoogleFonts.merriweatherSans().copyWith(
              color: Colors.black,
            ),
            body1: GoogleFonts.montserrat()
                .copyWith(color: Colors.black, fontSize: 16)),
      );
}
