import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:grateful/src/models/Photograph.dart';
import 'package:grateful/src/repositories/files/fileRepository.dart';
import 'package:meta/meta.dart';
import './bloc.dart';

class ImageHandlerBloc extends Bloc<ImageHandlerEvent, ImageHandlerState> {
  @override
  ImageHandlerState get initialState => InitialImageHandlerState();

  FileRepository fileRepository;

  Photograph photograph;

  get isUploaded {
    if (this.photograph is NetworkPhoto) {
      return true;
    }
    if (this.state is FileUploaded) {
      return true;
    }
    return false;
  }

  ImageHandlerBloc({@required this.fileRepository, @required this.photograph}) {
    if (this.photograph is FilePhoto) {
      _uploadPhoto(this.photograph);
    }
  }

  _uploadPhoto(FilePhoto filePhoto) async {
    final fileUploadEvent = await fileRepository.uploadFile(filePhoto.file);
    final fileUploadSubscription = fileUploadEvent.events.listen((eventData) {
      final uploadProgress = eventData.snapshot.bytesTransferred /
          eventData.snapshot.totalByteCount;
      this.add(
          UploadHasProgress(photograph: filePhoto, progress: uploadProgress));
    });
    final completedUpload = await fileUploadEvent.onComplete;
    final networkPhotoUrl = await completedUpload.ref.getDownloadURL();
    fileUploadSubscription.cancel();
    final NetworkPhoto networkPhoto = NetworkPhoto(imageUrl: networkPhotoUrl);
    this.add(UploadCompleted(networkPhoto));
  }

  @override
  Stream<ImageHandlerState> mapEventToState(
    ImageHandlerEvent event,
  ) async* {
    if (event is UploadHasProgress) {
      yield UploadProgress(event.photograph, event.progress);
    } else if (event is UploadCompleted) {
      yield FileUploaded(event.networkPhoto);
    }
  }
}
