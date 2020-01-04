import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spencerstolworthy_goals/src/screens/EditItem/EditItem.dart';
import 'package:spencerstolworthy_goals/src/screens/ItemFeed/ItemFeed.dart';
import 'package:spencerstolworthy_goals/src/screens/ItemDetails/ItemDetails.dart';
import 'package:spencerstolworthy_goals/src/screens/Onboarding/OnboardingRoutes.dart';
import 'package:spencerstolworthy_goals/src/theme/theme.dart';

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
    return PageRouteBuilder(
      settings: RouteSettings(name: routeName),
      pageBuilder: (context, animation, s) {
        return Theme(data: flutterAppTheme(Theme.of(context)), child: widget);
      },
    );
  }

  static Route<dynamic> generatedRoute(RouteSettings settings) {
    switch (settings.name) {
      case FlutterAppRoutes.onboarding:
        return _pageRoute(OnboardingRoutes(), FlutterAppRoutes.onboarding);
      case FlutterAppRoutes.itemDetails:
        final ItemDetailsArguments args = settings.arguments;
        return _pageRoute(ItemDetails(args.item), FlutterAppRoutes.itemDetails);
      case FlutterAppRoutes.itemFeed:
        return _pageRoute(ItemFeed(), FlutterAppRoutes.itemFeed);
      case FlutterAppRoutes.itemEdit:
        final EditItemArgs args = settings.arguments;
        return _pageRoute(
            EditItem(item: args?.item), FlutterAppRoutes.itemEdit);
      default:
        return _pageRoute(OnboardingRoutes(), FlutterAppRoutes.onboarding);
    }
  }
}
