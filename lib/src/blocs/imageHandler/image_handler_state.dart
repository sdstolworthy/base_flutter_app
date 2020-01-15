import 'package:meta/meta.dart';
import 'package:grateful/src/models/Photograph.dart';

@immutable
abstract class ImageHandlerState {
  final Photograph photograph;
  ImageHandlerState(this.photograph);
}

class InitialImageHandlerState extends ImageHandlerState {
  InitialImageHandlerState() : super(null);
}

class FileUploaded extends ImageHandlerState {
  FileUploaded(NetworkPhoto photograph) : super(photograph);
}

class UploadProgress extends ImageHandlerState {
  final double fileProgress;
  UploadProgress(FilePhoto filePhoto, this.fileProgress) : super(filePhoto);
}
