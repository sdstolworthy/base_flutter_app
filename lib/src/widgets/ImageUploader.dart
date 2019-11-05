import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grateful/src/blocs/fileUpload/bloc.dart';

typedef void OnCompleteFunction(String imageUrl);

class ImageUploader extends StatelessWidget {
  final File file;
  final Widget child;
  final OnCompleteFunction onComplete;
  final StorageUploadTask uploadTask;
  FileUploadBloc _fileUploadBloc;

  Future<dynamic> get isComplete => uploadTask.onComplete;

  ImageUploader(
      {@required this.file,
      @required this.onComplete,
      @required this.child,
      @required this.uploadTask}) {
    _fileUploadBloc = FileUploadBloc(uploadTask: this.uploadTask);
  }
  get fileUploadBloc => _fileUploadBloc;
  build(context) {
    return BlocBuilder<FileUploadBloc, FileUploadState>(
        builder: (context, state) {
          if (state is InitialFileUploadState) {
            _fileUploadBloc.add(SubscribeToProgress(this.uploadTask));
          }
          if (state is UploadSuccess) {
            onComplete(state.imageUrl);
          }
          return Stack(
            fit: StackFit.passthrough,
            children: <Widget>[
              child,
              if (state is FileUploadProgress)
                Positioned.fill(
                    child: Container(
                  color: Colors.black38,
                  child: Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.black38,
                      value: state.progress,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  ),
                ))
              else
                Container()
            ],
          );
        },
        bloc: _fileUploadBloc);
  }
}
