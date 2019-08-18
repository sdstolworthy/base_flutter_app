import 'package:flutter/material.dart';
import 'package:flutter_base_app/src/blocs/localization/bloc.dart';
import 'package:flutter_base_app/src/blocs/localization/localization_bloc.dart';
import 'package:flutter_base_app/src/services/localizations/localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LanguagePicker extends StatefulWidget {
  LanguagePicker({Key key}) : super(key: key);
  _LanguagePicker createState() => _LanguagePicker();
}

class _LanguagePicker extends State<LanguagePicker> {
  String selectedLanguage = 'en';
  build(BuildContext context) {
    final localizationBloc = BlocProvider.of<LocalizationBloc>(context);
    return DropdownButton(
      items: AppLocalizations.availableLocalizations.map((locale) {
        return DropdownMenuItem(
            child: Text(locale.flag), value: locale.languageCode);
      }).toList(),
      onChanged: (item) {
        print(item);
        localizationBloc.dispatch(ChangeLocalization(Locale(item)));
      },
    );
  }
}
