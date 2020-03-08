import 'package:flutter/material.dart';
import 'package:flutter_base_app/src/blocs/localization/bloc.dart';
import 'package:flutter_base_app/src/blocs/localization/localization_bloc.dart';
import 'package:flutter_base_app/src/blocs/user_preference/user_preference_bloc.dart';
import 'package:flutter_base_app/src/services/loading_tasks/loading_task.dart';

class LoadUserPreferences extends LoadingTask {
  LoadUserPreferences({this.localizationBloc, this.userPreferenceBloc})
      : super('Loading User Preferences');

  final LocalizationBloc localizationBloc;
  final UserPreferenceBloc userPreferenceBloc;

  @override
  Future<void> execute() async {
    userPreferenceBloc.add(FetchUserPreferences());

    final UserPreferencesFetched userPreferenceState = await userPreferenceBloc
            .firstWhere((UserPreferenceState state) => state is UserPreferencesFetched)
        as UserPreferencesFetched;

    localizationBloc.add(ChangeLocalization(Locale(userPreferenceState
            .userPreferenceSettings.userLanguageSettings?.locale ??
        'en')));
  }
}
