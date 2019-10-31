import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:grateful/src/repositories/files/fileRepository.dart';
import './bloc.dart';

class FileUploadBloc extends Bloc<FileUploadEvent, FileUploadState> {
  @override
  FileUploadState get initialState => InitialFileUploadState();
  FileRepository _fileRepository;
  FileUploadBloc({fileRepository})
      : _fileRepository = fileRepository ?? FileRepository();
  @override
  Stream<FileUploadState> mapEventToState(
    FileUploadEvent event,
  ) async* {
    if (event is UploadFile) {
      final task = _fileRepository.uploadFile(event.file);
      task.events.listen((d) {
        final progress =
            d.snapshot.bytesTransferred / d.snapshot.totalByteCount;
        if (progress == 1) {
          return;
        }
        add(OnProgress(progress));
      });
      task.onComplete.then((d) async {
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
