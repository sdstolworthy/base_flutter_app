import 'package:flutter/material.dart';
import 'package:grateful/src/blocs/authentication/bloc.dart';
import 'package:grateful/src/widgets/LanguagePicker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppDrawer extends StatelessWidget {
  build(context) {
    return Drawer(
      child: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            RaisedButton(
                child: Text('Log Out'),
                onPressed: () {
                  BlocProvider.of<AuthenticationBloc>(context)
                      .add(LogOut());
                }),
            LanguagePicker(),
          ],
        ),
      )),
    );
  }
}
