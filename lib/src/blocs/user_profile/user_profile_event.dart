import 'package:flutter_base_app/src/models/User.dart';
import 'package:meta/meta.dart';

@immutable
abstract class UserProfileEvent {}

class FetchUserProfile extends UserProfileEvent {
  final String userId;
  FetchUserProfile(this.userId);
}

class SetUserProfile extends UserProfileEvent {
  final User user;
  SetUserProfile(this.user);
}
