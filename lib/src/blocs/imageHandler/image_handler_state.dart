import 'package:meta/meta.dart';
import 'package:grateful/src/models/Photograph.dart';

@immutable
abstract class ImageHandlerState {}

class InitialImageHandlerState extends ImageHandlerState {}

class PhotographsLoaded extends ImageHandlerState {
  final List<Photograph> photographs;
  PhotographsLoaded(this.photographs);
}
