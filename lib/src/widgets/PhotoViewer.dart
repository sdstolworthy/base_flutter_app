import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewer extends StatelessWidget {
  final ImageProvider imageProvider;
  PhotoViewer({this.imageProvider});
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black,
        child: Scaffold(
            body: Stack(
          children: <Widget>[
            PhotoView(
              imageProvider: imageProvider,
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AppBar(
                backgroundColor: Colors.black26,
              ),
            )
          ],
        )));
  }
}
