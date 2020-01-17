import 'package:flutter/material.dart';
import 'package:flutter_base_app/src/models/User.dart';

class UserAvatar extends StatelessWidget {
  final User user;

  UserAvatar(this.user);
  @override
  Widget build(BuildContext context) {
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
                  user.initials,
                  style: TextStyle(fontSize: 25),
                ),
        ),
      ),
    );
  }
}
