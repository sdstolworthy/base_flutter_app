import 'package:meta/meta.dart';
import 'package:grateful/src/models/Photograph.dart';

@immutable
abstract class ImageHandlerEvent {}

class AddPhotograph extends ImageHandlerEvent {
  final Photograph photograph;
  AddPhotograph(this.photograph);
}

class ReplaceFilePhotoWithNetworkPhoto extends ImageHandlerEvent {
  final NetworkPhoto photograph;
  final String filePhotoGuid;
  ReplaceFilePhotoWithNetworkPhoto(
      {@required this.photograph, @required this.filePhotoGuid});
}

class UploadHasProgress extends ImageHandlerEvent {
  final Photograph photograph;
  final double progress;
  UploadHasProgress({@required this.progress, @required this.photograph});
}

class UploadCompleted extends ImageHandlerEvent {
  final NetworkPhoto networkPhoto;
  final FilePhoto placeholder;
  UploadCompleted(this.networkPhoto, this.placeholder);
}

class SetPhotographs extends ImageHandlerEvent {
  final List<Photograph> photographs;
  SetPhotographs(this.photographs);
}
