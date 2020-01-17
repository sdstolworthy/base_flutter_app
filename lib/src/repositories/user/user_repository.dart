import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_base_app/src/models/User.dart';

class UserRepository {
  static const _userCollectionName = 'users';

  Future<User> getProfile(String userId) async {
    DocumentSnapshot profile = await Firestore.instance
        .collection(_userCollectionName)
        .document(userId)
        .get();
    return User.fromMap(profile.data).copyWith(id: userId);
  }

  setProfile(User user) {
    Firestore.instance
        .collection(_userCollectionName)
        .document(user.id)
        .setData(user.toMap());
  }
}
