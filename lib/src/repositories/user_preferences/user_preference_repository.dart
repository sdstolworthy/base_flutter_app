import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_base_app/src/config/constants.dart';
import 'package:flutter_base_app/src/models/preferences/color_preference.dart';
import 'package:flutter_base_app/src/models/preferences/language_settings.dart';
import 'package:flutter_base_app/src/models/preferences/user_preference.dart';

class UserPreferenceRepository {
  UserPreferenceRepository({FirebaseAuth firebaseAuth, Firestore firestore})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        firestore = firestore ?? Firestore.instance;

  Firestore firestore;

  static const String _languagePreferenceDocument = 'language';
  static const String _preferenceCollectionName = 'preferences';
  static const String _colorPreferenceDocument = 'color';
  static const String _userCollectionName = Constants.userRepositoryName;

  final FirebaseAuth _firebaseAuth;

  Future<UserPreferenceSettings> updateUserPreference<T extends UserPreference>(
      UserPreference preference) async {
    DocumentReference documentReference;
    if (preference.runtimeType == UserLanguageSettings) {
      documentReference =
          await _getDocumentReference(_languagePreferenceDocument);
    } else if (preference.runtimeType == ColorPreference) {
      documentReference = await _getDocumentReference(_colorPreferenceDocument);
    }
    if (documentReference == null) {
      return null;
    }
    await documentReference.setData(preference.toMap(), merge: true);
    return getUserSettings();
  }

  Future<DocumentReference> _getDocumentReference(String documentName) async {
    final FirebaseUser user = await _firebaseAuth.currentUser();

    return firestore
        .collection(_userCollectionName)
        .document(user.uid)
        .collection(_preferenceCollectionName)
        .document(documentName);
  }

  UserPreferenceSettings _serializeDocumentsToUserPreferences(
      List<DocumentSnapshot> documents) {
    final UserPreferenceSettings userPreferenceSettings =
        UserPreferenceSettings();

    for (final DocumentSnapshot document in documents) {
      if (document.documentID == _languagePreferenceDocument) {
        userPreferenceSettings.userLanguageSettings =
            UserLanguageSettings.fromMap(document.data);
      } else if (document.documentID == _colorPreferenceDocument) {
        userPreferenceSettings.colorPreference =
            ColorPreference.fromMap(document.data);
      }
    }

    return userPreferenceSettings;
  }

  Future<UserPreferenceSettings> getUserSettings() async {
    final FirebaseUser user = await _firebaseAuth.currentUser();

    final QuerySnapshot documents = await firestore
        .collection(_userCollectionName)
        .document(user.uid)
        .collection(_preferenceCollectionName)
        .getDocuments();

    final UserPreferenceSettings settings =
        _serializeDocumentsToUserPreferences(documents.documents.toList());

    return settings;
  }
}
