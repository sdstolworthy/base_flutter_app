import 'package:cloud_firestore/cloud_firestore.dart';

class CloudMessagingRepository {
  final _firebaseSettings = 'settings';
  final _firebaceCloudStoreDocumentName = 'fcm';
  final _firebaseTokens = 'tokens';
  setId(String id) async {
    await Firestore.instance
        .collection(_firebaseSettings)
        .document(_firebaceCloudStoreDocumentName)
        .setData({
      _firebaseTokens: FieldValue.arrayUnion([id]),
    }, merge: true);
  }
}
