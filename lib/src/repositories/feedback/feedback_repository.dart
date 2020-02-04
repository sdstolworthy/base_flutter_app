import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FeedbackRepository {
  static const _feedbackCollectionName = 'feedback';
  final _userFeedback = 'user_feedback';
  final _feedbackSubmissions = 'submissions';
  FirebaseAuth _firebaseAuth;

  FeedbackRepository({FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<void> saveFeedback(String feedback) async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    await Firestore.instance
        .collection(_feedbackCollectionName)
        .document(_userFeedback)
        .setData({
      _feedbackSubmissions: FieldValue.arrayUnion([
        {'feedback': feedback, 'userId': user.uid, 'userEmail': user.email}
      ]),
    }, merge: true);
    return;
  }
}
