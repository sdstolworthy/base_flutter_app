import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_app/src/blocs/authentication/authentication_state.dart';
import 'package:flutter_base_app/src/blocs/authentication/bloc.dart';
import 'package:flutter_base_app/src/services/localizations/localizations.dart';
import 'package:flutter_base_app/src/services/navigator.dart';
import 'package:flutter_base_app/src/services/routes.dart';
import 'package:flutter_base_app/src/widgets/app_blocs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_base_app/src/blocs/localization/bloc.dart';

class FlutterApp extends StatelessWidget {
  final FirebaseAnalytics analytics = FirebaseAnalytics()
    ..logEvent(name: 'opened_app');
  @override
  Widget build(BuildContext context) {
    return AppBlocProviders(
        child: Builder(builder: (BuildContext outerContext) {
      return BlocListener<AuthenticationBloc, AuthenticationState>(
        condition: (AuthenticationState prev, AuthenticationState curr) {
          if (prev is Uninitialized && curr is Authenticated) {
            return true;
          }
          if (prev is Authenticated && curr is Unauthenticated) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, AuthenticationState state) {
          if (state is Authenticated) {
            rootNavigationService
                .pushReplacementNamed(FlutterAppRoutes.itemFeed);
          } else if (state is Unauthenticated) {
            rootNavigationService.returnToLogin();
          }
        },
        child: BlocBuilder<LocalizationBloc, LocalizationState>(
            bloc: BlocProvider.of<LocalizationBloc>(outerContext),
            builder: (BuildContext context, LocalizationState state) {
              return MaterialApp(
                localizationsDelegates: <LocalizationsDelegate<dynamic>>[
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  AppLocalizations.delegate
                ],
                locale: state.locale,
                supportedLocales: AppLocalizations.availableLocalizations
                    .map((AppLocale item) => Locale(item.languageCode)),
                onGenerateRoute: Router.generatedRoute,
                navigatorObservers: <NavigatorObserver>[
                  FirebaseAnalyticsObserver(analytics: analytics)
                ],
                navigatorKey: rootNavigationService.navigatorKey,
              );
            }),
      );
    }));
  }
}
