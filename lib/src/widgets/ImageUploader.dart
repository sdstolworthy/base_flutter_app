import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grateful/src/blocs/imageHandler/bloc.dart';
import 'package:grateful/src/models/Photograph.dart';

typedef void OnCompleteFunction(String imageUrl);

class ImageUploader extends StatelessWidget {
  build(context) {
    return BlocBuilder<ImageHandlerBloc, ImageHandlerState>(
        builder: (context, state) {
          if (state is FileUploaded) {
            return CachedNetworkImage(
                imageUrl: (state.photograph as NetworkPhoto).imageUrl);
          }
          return Stack(
            fit: StackFit.passthrough,
            children: <Widget>[
              (state.photograph is FilePhoto)
                  ? Image.file((state.photograph as FilePhoto).file)
                  : CachedNetworkImage(
                      imageUrl: (state.photograph as NetworkPhoto).imageUrl),
              if (state is UploadProgress)
                Positioned.fill(
                    child: Container(
                  color: Colors.black38,
                  child: Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.black38,
                      value: state.fileProgress,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  ),
                ))
              else
                Container()
            ],
          );
        },
        bloc: BlocProvider.of<ImageHandlerBloc>(context));
  }
}
