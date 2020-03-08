import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_base_app/src/models/user.dart';

class UserRepository {
  static const String _userCollectionName = 'users';

  Future<User> getProfile(String userId) async {
    final DocumentSnapshot profile = await Firestore.instance
        .collection(_userCollectionName)
        .document(userId)
        .get();
    return User.fromMap(profile.data).copyWith(id: userId);
  }

  Future<void> setProfile(User user) async {
    await Firestore.instance
        .collection(_userCollectionName)
        .document(user.id)
        .setData(user.toMap());
    return;
  }
}
