import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:grateful/src/models/Photograph.dart';
import 'package:grateful/src/repositories/files/fileRepository.dart';
import 'package:meta/meta.dart';
import './bloc.dart';

class ImageHandlerBloc extends Bloc<ImageHandlerEvent, ImageHandlerState> {
  @override
  ImageHandlerState get initialState =>
      InitialImageHandlerState(this.photograph);

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

    final StorageTaskSnapshot completedUpload =
        await fileUploadEvent.onComplete;
    final String networkPhotoUrl = await completedUpload.ref.getDownloadURL();
    fileUploadSubscription.cancel();

    if (networkPhotoUrl != null) {
      final NetworkPhoto networkPhoto = NetworkPhoto(imageUrl: networkPhotoUrl);
      this.photograph = networkPhoto;
      this.add(UploadCompleted(networkPhoto, filePhoto));
    }
  }

  @override
  Stream<ImageHandlerState> mapEventToState(
    ImageHandlerEvent event,
  ) async* {
    if (event is UploadHasProgress) {
      yield UploadProgress(event.photograph, event.progress);
    } else if (event is UploadCompleted) {
      yield FileUploaded(event.networkPhoto, event.placeholder);
    }
  }
}
