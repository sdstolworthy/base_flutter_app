import 'package:flutter_base_app/src/models/user.dart';
import 'package:meta/meta.dart';

@immutable
abstract class UserProfileState {}

class InitialUserProfileState extends UserProfileState {}

class UserProfileFetched extends UserProfileState {
  UserProfileFetched(this.user);

  final User user;
}

class UserProfileLoading extends UserProfileState {}
