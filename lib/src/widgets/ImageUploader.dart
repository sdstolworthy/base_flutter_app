import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grateful/src/blocs/fileUpload/bloc.dart';
import 'package:uuid/uuid.dart';

typedef void OnCompleteFunction(String imageUrl);

class ImageUploader extends StatefulWidget {
  final File file;
  final OnCompleteFunction onComplete;
  final Widget child;

  ImageUploader(
      {@required this.file, @required this.onComplete, @required this.child});
  @override
  State<StatefulWidget> createState() {
    return _ImageUploaderState(
        file: this.file, onComplete: onComplete, child: child);
  }
}

class _ImageUploaderState extends State<ImageUploader> {
  File file;
  Widget child;
  final FileUploadBloc _fileUploadBloc = FileUploadBloc();
  OnCompleteFunction onComplete;
  _ImageUploaderState(
      {@required this.file, @required this.onComplete, @required this.child});

  build(context) {
    return BlocBuilder<FileUploadBloc, FileUploadState>(
        builder: (context, state) {
          if (state is InitialFileUploadState) {
            _fileUploadBloc.add(UploadFile(file, Uuid().v4()));
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
                    child: Align(
                  child: CircularProgressIndicator(value: state.progress),
                ))
              else
                Container()
            ],
          );
        },
        bloc: _fileUploadBloc);
  }
}
