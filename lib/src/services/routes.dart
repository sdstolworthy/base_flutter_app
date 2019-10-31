import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grateful/src/screens/EditJournalEntry/EditJournalEntry.dart';
import 'package:grateful/src/screens/JournalEntryFeed/JournalEntryFeed.dart';
import 'package:grateful/src/screens/JournalEntryDetails/JournalEntryDetails.dart';
import 'package:grateful/src/screens/JournalPageView/JournalPageView.dart';
import 'package:grateful/src/screens/Onboarding/OnboardingRoutes.dart';
import 'package:grateful/src/theme/theme.dart';

class FlutterAppRoutes {
  static const String journalEntryDetails = 'itemDetails';
  static const String journalFeed = 'itemFeed';
  static const String welcome = 'welcome';
  static const String onboarding = 'onboarding';
  static const String editJournalEntry = 'itemEdit';
  static const String journalPageView = 'journalPageView';
}

typedef Route CurriedRouter(RouteSettings settings);

class Router {
  static _pageRoute(Widget widget, String routeName) {
    return MaterialPageRoute(
        builder: (context) => Theme(
              data: gratefulTheme(Theme.of(context)),
              child: widget,
            ),
        settings: RouteSettings(name: routeName));
  }

  static Route<dynamic> generatedRoute(RouteSettings settings) {
    switch (settings.name) {
      case FlutterAppRoutes.journalPageView:
        return _pageRoute(JournalPageView(), FlutterAppRoutes.journalPageView);
      case FlutterAppRoutes.onboarding:
        return _pageRoute(OnboardingRoutes(), FlutterAppRoutes.onboarding);
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
      default:
        return _pageRoute(OnboardingRoutes(), FlutterAppRoutes.onboarding);
    }
  }
}
