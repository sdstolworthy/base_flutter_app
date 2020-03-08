import 'package:flutter/material.dart';

class LoginFormField extends StatelessWidget {
  const LoginFormField(
      {this.icon,
      this.isObscured = false,
      this.label,
      this.controller,
      this.validator,
      this.enabled});

  final TextEditingController controller;
  final bool enabled;
  final IconData icon;
  final bool isObscured;
  final String label;

  final String Function(String) validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
      child: TextFormField(
        controller: controller,
        validator: validator ?? (_) => null,
        autocorrect: false,
        cursorColor: const Color.fromRGBO(255, 255, 255, 0.7),
        obscureText: isObscured,
        style: Theme.of(context).primaryTextTheme.body1,
        enabled: enabled,
        decoration: InputDecoration(
            labelText: label,
            labelStyle: Theme.of(context).inputDecorationTheme.labelStyle,
            prefixIcon: Icon(icon, color: Colors.white70),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white60)),
            focusedBorder: const UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Color.fromRGBO(255, 255, 255, 0.9))),
            border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white60))),
      ),
    );
  }
}
