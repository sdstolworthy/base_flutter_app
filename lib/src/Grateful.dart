import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:grateful/src/blocs/authentication/authentication_state.dart';
import 'package:grateful/src/blocs/authentication/bloc.dart';
import 'package:grateful/src/blocs/journalEntryFeed/bloc.dart';
import 'package:grateful/src/repositories/JournalEntries/JournalEntryRepository.dart';
import 'package:grateful/src/services/localizations/localizations.dart';
import 'package:grateful/src/services/navigator.dart';
import 'package:grateful/src/services/routes.dart';
import 'package:grateful/src/widgets/BlocProvider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:grateful/src/blocs/localization/bloc.dart';

class FlutterApp extends StatelessWidget {
  final FirebaseAnalytics analytics = FirebaseAnalytics()
    ..logEvent(name: 'opened_app');
  final _journalFeedBloc =
      JournalFeedBloc(journalEntryRepository: JournalEntryRepository());
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
            _journalFeedBloc.add(FetchFeed());

            rootNavigationService
                .pushReplacementNamed(FlutterAppRoutes.journalPageView);
          } else if (state is Unauthenticated) {
            rootNavigationService.returnToLogin();
          }
        },
        child: BlocBuilder(
            bloc: BlocProvider.of<LocalizationBloc>(outerContext),
            builder: (context, LocalizationState state) {
              return BlocProvider<JournalFeedBloc>(
                  builder: (_) => _journalFeedBloc,
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
