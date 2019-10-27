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
  build(BuildContext outerContext) {
    final localizationBloc = BlocProvider.of<LocalizationBloc>(outerContext);
    return BlocBuilder(
      bloc: localizationBloc,
      builder: (context, LocalizationState state) {
        return DropdownButton(
          value: state.locale.languageCode,
          items: AppLocalizations.availableLocalizations.map((locale) {
            return DropdownMenuItem(
                child: Text('${locale.flag} ${locale.languageCode}'),
                value: locale.languageCode);
          }).toList(),
          onChanged: (item) {
            localizationBloc.add(ChangeLocalization(Locale(item)));
          },
        );
      },
    );
  }
}
