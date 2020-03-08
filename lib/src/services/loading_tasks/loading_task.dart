import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_base_app/src/blocs/localization/localization_bloc.dart';
import 'package:flutter_base_app/src/blocs/user_preference/user_preference_bloc.dart';
import 'package:flutter_base_app/src/services/loading_tasks/load_user_preferences.dart';

abstract class LoadingTask {
  LoadingTask(this.loadingText);

  final String loadingText;

  Future<void> execute();
}

List<LoadingTask> getPreAuthenticationHooks(BuildContext context) {
  return <LoadingTask>[];
}

List<LoadingTask> getPostAuthenticationHooks(BuildContext context) {
  final LocalizationBloc localizationBloc =
      BlocProvider.of<LocalizationBloc>(context);
  final UserPreferenceBloc userPreferenceBloc =
      BlocProvider.of<UserPreferenceBloc>(context);
  return <LoadingTask>[
    LoadUserPreferences(
        localizationBloc: localizationBloc,
        userPreferenceBloc: userPreferenceBloc)
  ];
}
