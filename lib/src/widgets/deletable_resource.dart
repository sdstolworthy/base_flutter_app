import 'package:flutter/material.dart';

typedef void OnRemove();

class DeletableResource extends StatelessWidget {
  final Widget child;
  final OnRemove onRemove;
  DeletableResource({@required this.child, @required this.onRemove});
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      children: <Widget>[
        child,
        Positioned(
          right: 3,
          top: 3,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(35),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(1, 1),
                      spreadRadius: 0,
                      blurRadius: 2,
                      color: Colors.grey[900])
                ]),
            child: Stack(
              children: <Widget>[
                Icon(
                  Icons.remove_circle,
                  color: Colors.red,
                  size: 35,
                ),
                Positioned.fill(
                    child: Material(
                  color: Colors.transparent,
                  child: InkWell(onTap: this.onRemove),
                )),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
