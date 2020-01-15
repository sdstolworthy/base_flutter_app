import 'package:meta/meta.dart';
import 'package:grateful/src/models/Photograph.dart';

@immutable
abstract class ImageHandlerState {
  final Photograph photograph;
  ImageHandlerState(this.photograph);
}

class InitialImageHandlerState extends ImageHandlerState {
  InitialImageHandlerState(Photograph photograph) : super(photograph);
}

class FileUploaded extends ImageHandlerState {
  final FilePhoto placeholder;
  FileUploaded(NetworkPhoto photograph, this.placeholder) : super(photograph);
}

class UploadProgress extends ImageHandlerState {
  final double fileProgress;
  UploadProgress(FilePhoto filePhoto, this.fileProgress) : super(filePhoto);
}
