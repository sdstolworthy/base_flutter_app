import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class FileRepository {
  static const _storageBucketUrl = 'gs://grateful-journal.appspot.com/';

  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: _storageBucketUrl);
  StorageUploadTask uploadFile(File file) {
    String filePath = 'images/${Uuid().v4()}.png';
    final storageRef = _storage.ref().child(filePath);
    return storageRef.putFile(file);
  }
}
