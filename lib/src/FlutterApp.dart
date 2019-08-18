import 'package:flutter/material.dart';
import 'package:flutter_base_app/src/services/localizations/localizations.dart';
import 'package:flutter_base_app/src/services/navigator.dart';
import 'package:flutter_base_app/src/services/routes.dart';
import 'package:flutter_base_app/src/theme/theme.dart';
import 'package:flutter_base_app/src/widgets/BlocProvider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_base_app/src/blocs/localization/bloc.dart';

class FlutterApp extends StatelessWidget {
  build(_) {
    return AppBlocProviders(child: Builder(builder: (context) {
      final localizationBloc = BlocProvider.of<LocalizationBloc>(context);
      return MaterialApp(
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            AppLocalizations.delegate
          ],
          locale: localizationBloc.currentState.locale,
          supportedLocales: [
            const Locale('en'),
            const Locale('es'),
          ],
          theme: flutterAppTheme,
          home: Navigator(
              onGenerateRoute: Router.generatedRoute,
              key: rootNavigationService.navigatorKey));
    }));
  }
}
