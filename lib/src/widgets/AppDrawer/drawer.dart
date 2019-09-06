import 'package:flutter/material.dart';
import 'package:flutter_base_app/src/widgets/LanguagePicker.dart';

class AppDrawer extends StatelessWidget {
  build(_) {
    return Drawer(
      child: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: LanguagePicker(),
      )),
    );
  }
}
