import 'package:flutter/material.dart';
import 'package:flutter_base_app/src/services/navigator.dart';
import 'package:flutter_base_app/src/services/routes.dart';
import 'package:flutter_base_app/src/theme/theme.dart';
import 'package:flutter_base_app/src/widgets/BlocProvider.dart';

class FlutterApp extends StatelessWidget {
  build(_) {
    return AppBlocProviders(child: Builder(builder: (context) {
      return MaterialApp(
          theme: flutterAppTheme,
          home: Navigator(
              onGenerateRoute: Router.generatedRoute,
              key: rootNavigationService.navigatorKey));
    }));
  }
}
