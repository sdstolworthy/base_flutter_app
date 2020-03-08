import 'package:flutter/material.dart';
import 'package:flutter_base_app/src/models/user.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar(this.user, {Key key}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    final String initials = user.initials;
    return Container(
      child: Center(
        child: CircleAvatar(
          backgroundImage:
              user.photoUrl != null ? NetworkImage(user.photoUrl) : null,
          radius: 48,
          backgroundColor: Colors.brown,
          child: user.photoUrl != null
              ? null
              : Text(
                  initials,
                  style: const TextStyle(fontSize: 25),
                ),
        ),
      ),
    );
  }
}
