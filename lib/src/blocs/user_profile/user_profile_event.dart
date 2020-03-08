import 'package:flutter_base_app/src/models/user.dart';
import 'package:meta/meta.dart';

@immutable
abstract class UserProfileEvent {}

class FetchUserProfile extends UserProfileEvent {
  FetchUserProfile(this.userId);

  final String userId;
}

class SetUserProfile extends UserProfileEvent {
  SetUserProfile(this.user);

  final User user;
}
