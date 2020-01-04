import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_app/src/blocs/authentication/authentication_state.dart';
import 'package:flutter_base_app/src/blocs/authentication/bloc.dart';
import 'package:flutter_base_app/src/services/localizations/localizations.dart';
import 'package:flutter_base_app/src/services/navigator.dart';
import 'package:flutter_base_app/src/services/routes.dart';
import 'package:flutter_base_app/src/widgets/BlocProvider.dart';
import 'package:flutter_base_app/src/blocs/itemFeed/bloc.dart';
import 'package:flutter_base_app/src/repositories/items/itemRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_base_app/src/blocs/localization/bloc.dart';

class FlutterApp extends StatelessWidget {
  final FirebaseAnalytics analytics = FirebaseAnalytics()
    ..logEvent(name: 'opened_app');
  final _itemBloc = ItemBloc(itemRepository: ItemRepository());
  build(_) {
    return AppBlocProviders(child: Builder(builder: (outerContext) {
      return BlocListener<AuthenticationBloc, AuthenticationState>(
        condition: (prev, curr) {
          if (prev is Uninitialized && curr is Authenticated) {
            return true;
          }
          if (prev is Authenticated && curr is Unauthenticated) {
            return true;
          }
          return false;
        },
        listener: (context, AuthenticationState state) {
          if (state is Authenticated) {
            _itemBloc.add(FetchItems());

            rootNavigationService
                .pushReplacementNamed(FlutterAppRoutes.itemFeed);
          } else if (state is Unauthenticated) {
            rootNavigationService.returnToLogin();
          }
        },
        child: BlocBuilder(
            bloc: BlocProvider.of<LocalizationBloc>(outerContext),
            builder: (context, LocalizationState state) {
              return BlocProvider<ItemBloc>(
                  create: (_) => _itemBloc,
                  child: MaterialApp(
                    localizationsDelegates: [
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                      AppLocalizations.delegate
                    ],
                    locale: state.locale,
                    supportedLocales: AppLocalizations.availableLocalizations
                        .map((item) => Locale(item.languageCode)),
                    onGenerateRoute: Router.generatedRoute,
                    navigatorObservers: [
                      FirebaseAnalyticsObserver(analytics: analytics)
                    ],
                    navigatorKey: rootNavigationService.navigatorKey,
                  ));
            }),
      );
    }));
  }
}
