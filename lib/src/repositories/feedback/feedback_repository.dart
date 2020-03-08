import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FeedbackRepository {
  FeedbackRepository({FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  static const String _feedbackCollectionName = 'feedback';

  final String _feedbackSubmissions = 'submissions';
  final FirebaseAuth _firebaseAuth;
  final String _userFeedback = 'user_feedback';

  Future<void> saveFeedback(String feedback) async {
    final FirebaseUser user = await _firebaseAuth.currentUser();
    await Firestore.instance
        .collection(_feedbackCollectionName)
        .document(_userFeedback)
        .setData(<String, dynamic>{
      _feedbackSubmissions: FieldValue.arrayUnion(<Map<String, dynamic>>[
        <String, dynamic>{
          'feedback': feedback,
          'userId': user.uid,
          'userEmail': user.email
        }
      ]),
    }, merge: true);
    return;
  }
}
