import 'package:flutter/material.dart';
import 'package:flutter_base_app/src/services/localizations/localizations.dart';
import 'package:flutter_base_app/src/services/navigator.dart';
import 'package:flutter_base_app/src/services/routes.dart';
import 'package:flutter_base_app/src/theme/theme.dart';
import 'package:flutter_base_app/src/widgets/BlocProvider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class FlutterApp extends StatelessWidget {
  build(_) {
    return AppBlocProviders(child: Builder(builder: (context) {
      return MaterialApp(
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            AppLocalizations.delegate
          ],
          locale: Locale('es', 'MX'),
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
