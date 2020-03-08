import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_base_app/src/models/preferences/user_preference.dart';
import 'package:flutter_base_app/src/repositories/user_preferences/user_preference_repository.dart';
import 'package:meta/meta.dart';

part 'user_preference_event.dart';
part 'user_preference_state.dart';

class UserPreferenceBloc
    extends Bloc<UserPreferenceEvent, UserPreferenceState> {
  UserPreferenceBloc({@required this.preferenceRepository});

  UserPreferenceRepository preferenceRepository;

  @override
  Stream<UserPreferenceState> mapEventToState(
    UserPreferenceEvent event,
  ) async* {
    if (event is FetchUserPreferences) {
      try {
        final UserPreferenceSettings settings =
            await preferenceRepository.getUserSettings();
        yield UserPreferencesFetched(settings);
      } catch (e) {
        yield UserPreferencesFetched(UserPreferenceSettings());
      }
    } else if (event is UpdateUserPreference) {
      final UserPreferenceSettings settings =
          await preferenceRepository.updateUserPreference(event.userPreference);
      yield UserPreferencesFetched(settings);
    }
  }

  @override
  UserPreferenceState get initialState => UserPreferenceInitial();
}
