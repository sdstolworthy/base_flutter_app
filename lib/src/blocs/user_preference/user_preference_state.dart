part of 'user_preference_bloc.dart';

@immutable
abstract class UserPreferenceState {}

class UserPreferenceInitial extends UserPreferenceState {}

class UserPreferencesFetched extends UserPreferenceState {
  UserPreferencesFetched(this.userPreferenceSettings);

  final UserPreferenceSettings userPreferenceSettings;
}

class UserPreferenceError extends UserPreferenceState {}
