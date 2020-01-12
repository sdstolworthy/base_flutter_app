import 'package:firebase_storage/firebase_storage.dart';
import 'package:meta/meta.dart';

@immutable
abstract class FileUploadEvent {}

class SubscribeToProgress extends FileUploadEvent {
  StorageUploadTask uploadTask;
  SubscribeToProgress(this.uploadTask);
}

class UploadCompleted extends FileUploadEvent {
  final String imageUrl;
  UploadCompleted(this.imageUrl);
}

class OnProgress extends FileUploadEvent {
  final double progress;
  OnProgress(this.progress);
}

class BeginFileUpload extends FileUploadEvent {
  final Future<dynamic> future;
  BeginFileUpload(this.future);
}
