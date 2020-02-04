import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class FileRepository {
  final String storageBucketUrl;
  FirebaseStorage _storage;

  FileRepository({this.storageBucketUrl}) {
    _storage = FirebaseStorage(storageBucket: storageBucketUrl);
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Future<StorageUploadTask> uploadFile(File file) async {
    final userId = (await _firebaseAuth.currentUser()).uid;
    String filePath = 'images/$userId/${Uuid().v4()}.png';
    final storageRef = _storage.ref().child(filePath);
    return storageRef.putFile(file);
  }
}

// gs://grateful-journal.appspot.com/
