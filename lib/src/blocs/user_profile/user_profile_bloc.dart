import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_base_app/src/models/user.dart';
import 'package:flutter_base_app/src/repositories/user/user_repository.dart';
import './bloc.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  UserProfileBloc(this.userRepository);

  final UserRepository userRepository;

  @override
  UserProfileState get initialState => InitialUserProfileState();

  @override
  Stream<UserProfileState> mapEventToState(
    UserProfileEvent event,
  ) async* {
    if (event is FetchUserProfile) {
      yield UserProfileLoading();

      final User profile =
          await userRepository.getProfile(event.userId);
      yield UserProfileFetched(profile);
    }
    if (event is SetUserProfile) {
      yield UserProfileLoading();
      await userRepository.setProfile(event.user);
    }
  }
}
