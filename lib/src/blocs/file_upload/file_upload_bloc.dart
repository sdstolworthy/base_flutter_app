import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import './bloc.dart';

class FileUploadBloc extends Bloc<FileUploadEvent, FileUploadState> {
  @override
  FileUploadState get initialState => InitialFileUploadState();
  final StorageUploadTask uploadTask;
  FileUploadBloc({fileRepository, @required this.uploadTask});
  @override
  Stream<FileUploadState> mapEventToState(
    FileUploadEvent event,
  ) async* {
    if (event is SubscribeToProgress) {
      event?.uploadTask?.events?.listen((d) {
        final progress =
            d.snapshot.bytesTransferred / d.snapshot.totalByteCount;
        if (progress == 1) {
          return;
        }
        add(OnProgress(progress));
      });
      event?.uploadTask?.onComplete?.then((d) async {
        final imageUrl = await d.ref.getDownloadURL();
        add(UploadCompleted(imageUrl));
      });
    } else if (event is OnProgress) {
      yield FileUploadProgress(event.progress);
    } else if (event is UploadCompleted) {
      yield UploadSuccess(event.imageUrl);
    }
  }
}
