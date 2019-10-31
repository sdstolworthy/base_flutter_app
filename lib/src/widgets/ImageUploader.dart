import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grateful/src/blocs/fileUpload/bloc.dart';
import 'package:uuid/uuid.dart';

typedef void OnCompleteFunction(String imageUrl);

class ImageUploader extends StatefulWidget {
  final File file;
  final OnCompleteFunction onComplete;
  ImageUploader({@required this.onComplete, @required this.file});
  @override
  State<StatefulWidget> createState() {
    return _ImageUploaderState(this.file, onComplete);
  }
}

class _ImageUploaderState extends State<ImageUploader> {
  File file;
  final FileUploadBloc _fileUploadBloc = FileUploadBloc();
  OnCompleteFunction onComplete;
  _ImageUploaderState(this.file, this.onComplete);

  build(context) {
    return BlocBuilder<FileUploadBloc, FileUploadState>(
        builder: (context, state) {
          if (state is InitialFileUploadState) {
            _fileUploadBloc.add(UploadFile(file, Uuid().v4()));
          }
          if (state is UploadSuccess) {
            onComplete(state.imageUrl);
          }
          return SizedBox(
              height: 100,
              width: 100,
              child: Stack(
                children: <Widget>[
                  Image.file(
                    file,
                    height: 100,
                    width: 100,
                  ),
                  if (state is FileUploadProgress)
                    Container(
                      child: Center(
                        child: CircularProgressIndicator(value: state.progress),
                      ),
                    )
                  else
                    Container()
                ],
              ));
        },
        bloc: _fileUploadBloc);
  }
}
