import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grateful/src/screens/AboutApp/AboutApp.dart';
import 'package:grateful/src/screens/EditJournalEntry/EditJournalEntry.dart';
import 'package:grateful/src/screens/JournalEntryFeed/JournalEntryFeed.dart';
import 'package:grateful/src/screens/JournalEntryDetails/JournalEntryDetails.dart';
import 'package:grateful/src/screens/JournalPageView/JournalPageView.dart';
import 'package:grateful/src/screens/Onboarding/Login/LoginScreen.dart';
import 'package:grateful/src/screens/Onboarding/Welcome/WelcomeScreen.dart';
import 'package:grateful/src/theme/theme.dart';

class FlutterAppRoutes {
  static const String journalEntryDetails = 'itemDetails';
  static const String journalFeed = 'itemFeed';
  static const String welcome = 'welcome';
  static const String onboarding = 'onboarding';
  static const String editJournalEntry = 'itemEdit';
  static const String journalPageView = 'journalPageView';
  static const String aboutApp = 'aboutApp';
  static const String welcomeScreen = 'welcomeScreen';
  static const String loginScreen = 'loginScreen';
  static const String signupScreen = 'signupScreen';
}

typedef Route CurriedRouter(RouteSettings settings);

class Router {
  static _pageRoute(Widget widget, String routeName) {
    return PageRouteBuilder(
        pageBuilder: (c, a, s) =>
            Theme(data: gratefulTheme(Theme.of(c)), child: widget),
        transitionsBuilder: (c, a, s, child) {
          return SlideTransition(
            child: child,
            position: new Tween<Offset>(
                    begin: const Offset(1.0, 0.0), end: Offset.zero)
                .animate(a),
          );
        },
        settings: RouteSettings(name: routeName));
  }

  static Route<dynamic> generatedRoute(RouteSettings settings) {
    switch (settings.name) {
      case FlutterAppRoutes.journalPageView:
        final JournalPageArguments args = settings.arguments;
        return _pageRoute(
            JournalPageView(
              journalEntry: args?.entry,
            ),
            FlutterAppRoutes.journalPageView);
      case FlutterAppRoutes.journalEntryDetails:
        final JournalEntryDetailArguments args = settings.arguments;
        return _pageRoute(JournalEntryDetails(args.journalEntry),
            FlutterAppRoutes.journalEntryDetails);
      case FlutterAppRoutes.journalFeed:
        return _pageRoute(JournalEntryFeed(), FlutterAppRoutes.journalFeed);
      case FlutterAppRoutes.editJournalEntry:
        final EditJournalEntryArgs args = settings.arguments;
        return _pageRoute(EditJournalEntry(item: args?.journalEntry),
            FlutterAppRoutes.editJournalEntry);
      case FlutterAppRoutes.loginScreen:
        return _pageRoute(LoginScreen(true), FlutterAppRoutes.loginScreen);
      case FlutterAppRoutes.signupScreen:
        return _pageRoute(LoginScreen(false), FlutterAppRoutes.signupScreen);
      case FlutterAppRoutes.welcomeScreen:
        return _pageRoute(WelcomeScreen(), FlutterAppRoutes.welcomeScreen);
      case FlutterAppRoutes.aboutApp:
        return _pageRoute(AboutApp(), FlutterAppRoutes.aboutApp);
      default:
        return _pageRoute(WelcomeScreen(), FlutterAppRoutes.welcomeScreen);
    }
  }
}
