import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grateful/src/blocs/image_handler/bloc.dart';
import 'package:grateful/src/models/Photograph.dart';
import 'package:grateful/src/widgets/deletable_resource.dart';

typedef void OnRemove(ImageHandlerBloc imageHandlerBloc);

class ImageUploader extends StatelessWidget {
  final OnRemove _onRemove;

  ImageUploader({@required onRemove}) : _onRemove = onRemove;

  build(context) {
    return BlocBuilder<ImageHandlerBloc, ImageHandlerState>(
        builder: (context, state) {
          if (state is FileUploaded) {
            return _makeImageDeletable(
                context,
                CachedNetworkImage(
                    imageUrl: (state.photograph as NetworkPhoto).imageUrl,
                    placeholder: (context, url) {
                      return state.placeholder != null
                          ? Image.file(state.placeholder?.file)
                          : Container();
                    }));
          }
          return Stack(
            fit: StackFit.passthrough,
            children: <Widget>[
              (state.photograph is FilePhoto)
                  ? Image.file((state.photograph as FilePhoto).file)
                  : _makeImageDeletable(
                      context,
                      CachedNetworkImage(
                        imageUrl: (state.photograph as NetworkPhoto).imageUrl,
                      )),
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

  Widget _makeImageDeletable(BuildContext context, Widget child) {
    return DeletableResource(
        child: child,
        onRemove: () {
          this._onRemove(BlocProvider.of<ImageHandlerBloc>(context));
        });
  }
}
