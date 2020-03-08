import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_base_app/src/models/item.dart';

class ItemRepository {
  ItemRepository({FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  static const String _itemCollectionName = 'items';
  static const String _userCollectionName = 'users';

  final FirebaseAuth _firebaseAuth;

  Future<List<Item>> getItems(
      {int take = 50, int limit = 50, int skip = 50}) async {
    final FirebaseUser user = await _firebaseAuth.currentUser();
    final List<DocumentSnapshot> entries = (await Firestore.instance
            .collection(_userCollectionName)
            .document(user.uid)
            .collection(_itemCollectionName)
            .getDocuments())
        .documents
        .toList();
    return entries.isEmpty
        ? <Item>[]
        : entries
            .map(
              (DocumentSnapshot entry) => Item.fromMap(entry.data),
            )
            .toList();
  }

  Future<Item> saveItem(Item item) async {
    final FirebaseUser user = await _firebaseAuth.currentUser();
    await Firestore.instance
        .collection(_userCollectionName)
        .document(user.uid)
        .collection(_itemCollectionName)
        .document(item.id.toString())
        .setData(item.toMap());
    return item;
  }

  Future<void> deleteItem(Item item) async {
    final FirebaseUser user = await _firebaseAuth.currentUser();
    await Firestore.instance
        .collection(_userCollectionName)
        .document(user.uid)
        .collection(_itemCollectionName)
        .document(item.id.toString())
        .delete();
  }
}
