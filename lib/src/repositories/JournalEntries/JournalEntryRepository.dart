import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grateful/src/models/JournalEntry.dart';

class JournalEntryRepository {
  static const _userCollectionName = 'users';
  static const _itemCollectionName = 'journal_entries';

  FirebaseAuth _firebaseAuth;

  JournalEntryRepository({FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;
  getFeed({take = 50, limit = 50, skip = 50}) async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    List<DocumentSnapshot> entries = (await Firestore.instance
            .collection(_userCollectionName)
            .document(user.uid)
            .collection(_itemCollectionName)
            .getDocuments())
        .documents
        .where((d) => !(d.data['deleted'] == true))
        .toList();
    return entries.isEmpty
        ? <JournalEntry>[]
        : entries
            .map(
              (DocumentSnapshot entry) => JournalEntry.fromMap(entry.data),
            )
            .toList();
  }

  saveItem(JournalEntry journalEntry) async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    await Firestore.instance
        .collection(_userCollectionName)
        .document(user.uid)
        .collection(_itemCollectionName)
        .document(journalEntry.id.toString())
        .setData(journalEntry.toMap());
    return journalEntry;
  }

  deleteItem(JournalEntry journalEntry) async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    await Firestore.instance
        .collection(_userCollectionName)
        .document(user.uid)
        .collection(_itemCollectionName)
        .document(journalEntry.id.toString())
        .updateData({'deleted': true});
  }
}
