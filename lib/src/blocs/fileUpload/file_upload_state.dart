import 'package:meta/meta.dart';

@immutable
abstract class FileUploadState {}

class InitialFileUploadState extends FileUploadState {}

class FileUploadProgress extends FileUploadState {
  final double progress;
  FileUploadProgress(this.progress);
}

class UploadSuccess extends FileUploadState {
  final String imageUrl;
  UploadSuccess(this.imageUrl);
}
