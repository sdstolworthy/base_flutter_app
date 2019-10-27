import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_base_app/src/models/Item.dart';

class ItemRepository {
  static const _userCollectionName = 'users';
  static const _itemCollectionName = 'items';

  FirebaseAuth _firebaseAuth;

  ItemRepository({FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;
  getItems({take = 50, limit = 50, skip = 50}) async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    List<DocumentSnapshot> entries = (await Firestore.instance
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

  saveItem(Item item) async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    await Firestore.instance
        .collection(_userCollectionName)
        .document(user.uid)
        .collection(_itemCollectionName)
        .document(item.id.toString())
        .setData(item.toMap());
    return item;
  }
}
