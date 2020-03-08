part of 'user_preference_bloc.dart';

@immutable
abstract class UserPreferenceEvent {}

class FetchUserPreferences extends UserPreferenceEvent {}

class UpdateUserPreference<T extends UserPreference>
    extends UserPreferenceEvent {
  UpdateUserPreference(this.userPreference);

  final T userPreference;
}
