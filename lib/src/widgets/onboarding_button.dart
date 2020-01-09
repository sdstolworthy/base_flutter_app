import 'package:flutter/material.dart';

class OnboardingButton extends StatelessWidget {
  final String buttonText;
  final Function onPressed;
  final bool isInverted;
  OnboardingButton({this.buttonText, this.onPressed, this.isInverted = false});
  build(context) {
    final theme = Theme.of(context);
    return ButtonTheme(
      height: 50,
      child: RaisedButton(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(this.buttonText,
            style: theme.accentTextTheme.headline.merge(TextStyle(
                color: isInverted
                    ? theme.textTheme.headline.color
                    : theme.primaryTextTheme.headline.color))),
        color: isInverted ? theme.primaryColorLight : theme.primaryColorDark,
        highlightColor: theme.highlightColor,
        onPressed: this.onPressed,
      ),
    );
  }
}
