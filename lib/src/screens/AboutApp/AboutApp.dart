import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_app/src/config/constants.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutApp extends StatelessWidget {
  _launchUrl(String url) {
    return () async {
      if (await canLaunch(url)) {
        launch(url);
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Container(
        color: Theme.of(context).backgroundColor,
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.only(left: 20, right: 20, top: 40),
            children: <Widget>[
              Wrap(
                children: <Widget>[
                  Text(
                    'Base Flutter App',
                    style: theme.primaryTextTheme.headline,
                  ),
                ],
              ),
              Wrap(
                children: <Widget>[
                  Text(
                    '© ${DateFormat.y().format(DateTime.now())} Example Co',
                    style: theme.primaryTextTheme.body1,
                  ),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                      text:
                          'If you have any questions or comments, please email me at ',
                      style: theme.primaryTextTheme.body1,
                    ),
                    TextSpan(
                        text: Constants.supportEmail,
                        style: theme.primaryTextTheme.body2,
                        recognizer: TapGestureRecognizer()
                          ..onTap = _launchUrl(
                              'mailto:${Constants.supportEmail}?subject=Base Flutter App Support&body='))
                  ])),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(text: 'Please read the Grateful '),
                    TextSpan(
                        text: 'Privacy Policy',
                        style: theme.primaryTextTheme.body2,
                        recognizer: TapGestureRecognizer()
                          ..onTap = _launchUrl(Constants.privacyPolicyUrl)),
                    TextSpan(text: 'and', style: theme.primaryTextTheme.body1),
                    TextSpan(
                        text: 'Terms of Service.',
                        style: theme.primaryTextTheme.body2,
                        recognizer: TapGestureRecognizer()
                          ..onTap = _launchUrl(Constants.termsOfServiceUrl))
                  ])),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
