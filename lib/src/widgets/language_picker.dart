import 'package:flutter/material.dart';
import 'package:flutter_base_app/src/blocs/localization/bloc.dart';
import 'package:flutter_base_app/src/blocs/localization/localization_bloc.dart';
import 'package:flutter_base_app/src/services/localizations/localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LanguagePicker extends StatefulWidget {
  const LanguagePicker({Key key}) : super(key: key);
  @override
  _LanguagePicker createState() => _LanguagePicker();
}

class _LanguagePicker extends State<LanguagePicker> {
  String selectedLanguage = 'en';
  @override
  Widget build(BuildContext outerContext) {
    final LocalizationBloc localizationBloc =
        BlocProvider.of<LocalizationBloc>(outerContext);
    return BlocBuilder<LocalizationBloc, LocalizationState>(
      bloc: localizationBloc,
      builder: (BuildContext context, LocalizationState state) {
        return DropdownButton<String>(
          value: state.locale.languageCode,
          items:
              AppLocalizations.availableLocalizations.map((AppLocale locale) {
            return DropdownMenuItem<String>(
                child: Text(
                  '${locale.flag} ${locale.title}',
                  style: Theme.of(outerContext).primaryTextTheme.body1,
                ),
                value: locale.languageCode);
          }).toList(),
          onChanged: (String item) {
            localizationBloc.add(ChangeLocalization(Locale(item)));
          },
        );
      },
    );
  }
}
