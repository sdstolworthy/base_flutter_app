import 'package:flutter_base_app/src/models/User.dart';
import 'package:meta/meta.dart';

@immutable
abstract class UserProfileState {}

class InitialUserProfileState extends UserProfileState {}

class UserProfileFetched extends UserProfileState {
  final User user;
  UserProfileFetched(this.user);
}

class UserProfileLoading extends UserProfileState {}
