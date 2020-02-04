import 'package:flutter/material.dart';
import 'package:grateful/src/blocs/localization/bloc.dart';
import 'package:grateful/src/blocs/localization/localization_bloc.dart';
import 'package:grateful/src/repositories/analytics/AnalyticsRepository.dart';
import 'package:grateful/src/services/localizations/localizations.dart';
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
                child: Text(
                  '${locale.flag} ${locale.title}',
                  style: Theme.of(outerContext).primaryTextTheme.body1,
                ),
                value: locale.languageCode);
          }).toList(),
          onChanged: (item) {
            AnalyticsRepository().logEvent(
                name: 'selectedLanguage', parameters: {'language': item});
            localizationBloc.add(ChangeLocalization(Locale(item)));
          },
        );
      },
    );
  }
}
