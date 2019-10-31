import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:grateful/src/models/Photograph.dart';
import './bloc.dart';

class ImageHandlerBloc extends Bloc<ImageHandlerEvent, ImageHandlerState> {
  @override
  ImageHandlerState get initialState => InitialImageHandlerState();

  List<Photograph> photographs = [];
  @override
  Stream<ImageHandlerState> mapEventToState(
    ImageHandlerEvent event,
  ) async* {
    if (event is AddPhotograph) {
      photographs = List.from(photographs)..add(event.photograph);
      yield PhotographsLoaded(photographs);
    } else if (event is ReplaceFilePhotoWithNetworkPhoto) {
      final index = photographs.indexWhere((p) =>
          p is FilePhoto &&
          p.guid == (event as ReplaceFilePhotoWithNetworkPhoto).filePhotoGuid);
      if (index > -1 && index < photographs.length) {
        photographs.replaceRange(index, index + 1,
            [(event as ReplaceFilePhotoWithNetworkPhoto).photograph]);
        yield PhotographsLoaded(photographs);
      }
    } else if (event is SetPhotographs) {
      photographs = event.photographs;
      yield PhotographsLoaded(photographs);
    }
  }
}
