import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grateful/src/screens/about_app/about_app.dart';
import 'package:grateful/src/screens/edit_journal_entry/edit_journal_entry.dart';
import 'package:grateful/src/screens/feedback_form/feedback_form.dart';
import 'package:grateful/src/screens/journal_entry_feed/journal_entry_feed.dart';
import 'package:grateful/src/screens/journal_entry_details/journal_entry_details.dart';
import 'package:grateful/src/screens/journal_page_view/journal_page_view.dart';
import 'package:grateful/src/screens/login/login.dart';
import 'package:grateful/src/screens/welcome/welcome.dart';
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
  static const String feedback = 'feedback';
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
      case FlutterAppRoutes.feedback:
        final FeedbackFormArgs feedbackFormArgs = settings.arguments;
        return _pageRoute(FeedbackForm(feedbackFormArgs), FlutterAppRoutes.feedback);
      default:
        return _pageRoute(WelcomeScreen(), FlutterAppRoutes.welcomeScreen);
    }
  }
}
