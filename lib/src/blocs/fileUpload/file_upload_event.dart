import 'dart:io';

import 'package:meta/meta.dart';

@immutable
abstract class FileUploadEvent {}

class UploadFile extends FileUploadEvent {
  File file;
  String guid;
  UploadFile(this.file, this.guid);
}

class UploadCompleted extends FileUploadEvent {
  final String imageUrl;
  UploadCompleted(this.imageUrl);
}

class OnProgress extends FileUploadEvent {
  final double progress;
  OnProgress(this.progress);
}
