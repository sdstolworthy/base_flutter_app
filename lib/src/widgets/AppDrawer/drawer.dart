import 'package:flutter/material.dart';
import 'package:grateful/src/blocs/authentication/bloc.dart';
import 'package:grateful/src/repositories/analytics/AnalyticsRepository.dart';
import 'package:grateful/src/services/localizations/localizations.dart';
import 'package:grateful/src/services/navigator.dart';
import 'package:grateful/src/services/routes.dart';
import 'package:grateful/src/widgets/LanguagePicker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppDrawer extends StatelessWidget {
  build(context) {
    return Drawer(
      child: Container(
        color: Theme.of(context).backgroundColor,
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: <Widget>[
              RaisedButton(
                  child: Text(AppLocalizations.of(context).logOut,
                      style: Theme.of(context).primaryTextTheme.body1),
                  color: Theme.of(context).buttonColor,
                  onPressed: () {
                    AnalyticsRepository().logEvent(name: 'logOut');
                    BlocProvider.of<AuthenticationBloc>(context)
                        .add(Unauthenticate());
                  }),
              FlatButton(
                child: Text('About Grateful'),
                onPressed: () {
                  rootNavigationService.navigateTo(FlutterAppRoutes.aboutApp);
                },
              ),
              LanguagePicker(),
            ],
          ),
        )),
      ),
    );
  }
}
