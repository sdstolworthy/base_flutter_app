import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grateful/src/screens/EditJournalEntry/EditJournalEntry.dart';
import 'package:grateful/src/screens/JournalEntryFeed/JournalEntryFeed.dart';
import 'package:grateful/src/screens/JournalEntryDetails/JournalEntryDetails.dart';
import 'package:grateful/src/screens/Onboarding/OnboardingRoutes.dart';

class FlutterAppRoutes {
  static const String itemDetails = 'itemDetails';
  static const String itemFeed = 'itemFeed';
  static const String welcome = 'welcome';
  static const String onboarding = 'onboarding';
  static const String itemEdit = 'itemEdit';
}

typedef Route CurriedRouter(RouteSettings settings);

class Router {
  static _pageRoute(Widget widget, String routeName) {
    return MaterialPageRoute(
        builder: (context) => widget, settings: RouteSettings(name: routeName));
  }

  static Route<dynamic> generatedRoute(RouteSettings settings) {
    switch (settings.name) {
      case FlutterAppRoutes.onboarding:
        return _pageRoute(OnboardingRoutes(), FlutterAppRoutes.onboarding);
      case FlutterAppRoutes.itemDetails:
        final ItemDetailsArguments args = settings.arguments;
        return _pageRoute(ItemDetails(args.item), FlutterAppRoutes.itemDetails);
      case FlutterAppRoutes.itemFeed:
        return _pageRoute(JournalEntryFeed(), FlutterAppRoutes.itemFeed);
      case FlutterAppRoutes.itemEdit:
        final EditJournalEntryArgs args = settings.arguments;
        return _pageRoute(
            EditItem(item: args?.journalEntry), FlutterAppRoutes.itemEdit);
      default:
        return _pageRoute(OnboardingRoutes(), FlutterAppRoutes.onboarding);
    }
  }
}
