import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:grateful/src/config/constants.dart';
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
    final List<Widget> children = <Widget>[
      Wrap(
        children: <Widget>[
          Text(
            'Grateful: Give Thanks Daily',
            style: theme.primaryTextTheme.headline,
          ),
        ],
      ),
      Wrap(children: <Widget>[
        Text(
          '© ${DateFormat.y().format(DateTime.now())} Spencer Stolworthy.',
          style: theme.primaryTextTheme.body1,
        ),
      ]),
      RichText(
        text: TextSpan(style: TextStyle(height: 1.5), children: [
          TextSpan(
              text:
                  'Designs graciously provided by Alicia Wilkin. See more of her work at ',
              style: theme.primaryTextTheme.body1),
          TextSpan(
              text: 'AliciaWilkin.com',
              style: theme.accentTextTheme.body1,
              recognizer: TapGestureRecognizer()
                ..onTap = _launchUrl('https://aliciawilkin.com'))
        ]),
      ),
      RichText(
          text: TextSpan(children: [
        TextSpan(
          text: 'If you have any questions or comments, please email me at ',
          style: theme.primaryTextTheme.body1,
        ),
        TextSpan(
            text: Constants.supportEmail,
            style: theme.primaryTextTheme.body1,
            recognizer: TapGestureRecognizer()
              ..onTap = _launchUrl(
                  'mailto:${Constants.supportEmail}?subject=Grateful App Support&body='))
      ])),
      RichText(
          text: TextSpan(children: [
        TextSpan(text: 'Please read the Grateful '),
        TextSpan(
            text: 'Privacy Policy',
            style: theme.primaryTextTheme.body1,
            recognizer: TapGestureRecognizer()
              ..onTap = _launchUrl(Constants.privacyPolicyUrl)),
        TextSpan(text: ' and ', style: theme.primaryTextTheme.body1),
        TextSpan(
            text: 'Terms of Service.',
            style: theme.primaryTextTheme.body1,
            recognizer: TapGestureRecognizer()
              ..onTap = _launchUrl(Constants.termsOfServiceUrl))
      ])),
    ];
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Container(
        color: Theme.of(context).backgroundColor,
        child: SafeArea(
          child: ListView.builder(
            padding: EdgeInsets.only(left: 20, right: 20, top: 40),
            itemCount: children.length,
            itemBuilder: (c, i) => Padding(
                child: children[i], padding: EdgeInsets.symmetric(vertical: 5)),
          ),
        ),
      ),
    );
  }
}
