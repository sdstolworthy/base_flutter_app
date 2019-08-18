import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_base_app/src/blocs/authentication/bloc.dart';
import 'package:flutter_base_app/src/screens/ItemFeed/ItemFeed.dart';
import 'package:flutter_base_app/src/screens/ItemDetails/ItemDetails.dart';
import 'package:flutter_base_app/src/screens/Onboarding/Login/LoginScreen.dart';
import 'package:flutter_base_app/src/screens/Onboarding/OnboardingRoutes.dart';
import 'package:flutter_base_app/src/screens/Onboarding/Welcome/WelcomeScreen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FlutterAppRoutes {
  static const String itemDetails = 'itemDetails';
  static const String itemFeed = 'itemFeed';
  static const String welcome = 'welcome';
  static const String onboarding = 'onboarding';
}

typedef Route CurriedRouter(RouteSettings settings);

class Router {
  static _pageRoute(Widget widget) {
    return MaterialPageRoute(builder: (context) => widget);
  }

  static Route<dynamic> generatedRoute(RouteSettings settings) {
    switch (settings.name) {
      case FlutterAppRoutes.onboarding:
        return _pageRoute(OnboardingRoutes());
      case FlutterAppRoutes.itemDetails:
        final ItemDetailsArguments args = settings.arguments;
        return _pageRoute(ItemDetails(args.item));
      case FlutterAppRoutes.itemFeed:
        return _pageRoute(ItemFeed());
      default:
        return _pageRoute(OnboardingRoutes());
    }
  }
}
