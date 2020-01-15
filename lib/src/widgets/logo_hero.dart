import 'package:flutter/widgets.dart';

class LogoHero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Hero(
      child: Image.asset(
        'assets/images/transparent@3x.png',
        fit: BoxFit.contain,
      ),
      tag: 'logoHero',
    );
  }
}
