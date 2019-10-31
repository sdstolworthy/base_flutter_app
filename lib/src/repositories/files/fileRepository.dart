import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class FileRepository {
  static const _storageBucketUrl = 'gs://pilot-log-22d2f.appspot.com/';

  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: _storageBucketUrl);
  StorageUploadTask uploadFile(File file) {
    String filePath = 'images/${Uuid().v4()}.png';
    return _storage.ref().child(filePath).putFile(file);
  }
}
