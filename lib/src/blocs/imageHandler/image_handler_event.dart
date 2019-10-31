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

class SetPhotographs extends ImageHandlerEvent {
  final List<Photograph> photographs;
  SetPhotographs(this.photographs);
}
