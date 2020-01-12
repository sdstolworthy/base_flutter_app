import 'package:flutter/material.dart';
import 'package:grateful/src/blocs/authentication/bloc.dart';
import 'package:grateful/src/services/localizations/localizations.dart';
import 'package:grateful/src/services/navigator.dart';
import 'package:grateful/src/services/routes.dart';
import 'package:grateful/src/widgets/LanguagePicker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppDrawer extends StatelessWidget {
  build(context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Drawer(
      child: Container(
        color: Theme.of(context).backgroundColor,
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(
                  localizations.aboutGratefulButtonText,
                  style: theme.primaryTextTheme.body1,
                ),
                leading: Icon(Icons.info, color: theme.iconTheme.color),
                onTap: () {
                  rootNavigationService.navigateTo(FlutterAppRoutes.aboutApp);
                },
              ),
              ListTile(
                title: LanguagePicker(),
                leading: Icon(Icons.language, color: theme.iconTheme.color),
              ),
              ListTile(
                leading: Icon(Icons.vpn_key, color: theme.iconTheme.color),
                title: Text(
                  localizations.logOut,
                  style: theme.primaryTextTheme.body1,
                ),
                onTap: () {
                  BlocProvider.of<AuthenticationBloc>(context)
                      .add(Unauthenticate());
                },
              ),
            ],
          ),
        )),
      ),
    );
  }
}
