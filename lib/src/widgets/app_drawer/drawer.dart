import 'package:flutter/material.dart';
import 'package:flutter_base_app/src/blocs/authentication/bloc.dart';
import 'package:flutter_base_app/src/blocs/user_profile/user_profile_bloc.dart';
import 'package:flutter_base_app/src/blocs/user_profile/user_profile_event.dart';
import 'package:flutter_base_app/src/blocs/user_profile/user_profile_state.dart';
import 'package:flutter_base_app/src/services/localizations/localizations.dart';
import 'package:flutter_base_app/src/services/navigator.dart';
import 'package:flutter_base_app/src/services/routes.dart';
import 'package:flutter_base_app/src/widgets/language_picker.dart';
import 'package:flutter_base_app/src/widgets/user_avatar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_base_app/src/screens/feedback_form/feedback_form.dart';

class AppDrawer extends StatelessWidget {
  build(context) {
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final _userProfileBloc = BlocProvider.of<UserProfileBloc>(context);
    return BlocBuilder<UserProfileBloc, UserProfileState>(
        bloc: _userProfileBloc,
        builder: (context, userProfileState) {
          if (userProfileState is InitialUserProfileState) {
            BlocProvider.of<AuthenticationBloc>(context)
                .getCurrentUserId()
                .then((userId) {
              _userProfileBloc.add(FetchUserProfile(userId));
            });
          }
          return Drawer(
            child: SafeArea(
                child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: <Widget>[
                  Container(
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          rootNavigationService
                              .navigateTo(FlutterAppRoutes.userProfileScreen);
                        },
                        child: userProfileState is UserProfileFetched
                            ? UserAvatar(userProfileState.user)
                            : Center(
                                child: CircularProgressIndicator(),
                              ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  ListTile(
                    title: LanguagePicker(),
                    leading: Icon(Icons.language),
                  ),
                  ListTile(
                      onTap: () {
                        rootNavigationService.goBack();
                        rootNavigationService.navigateTo(
                            FlutterAppRoutes.feedback,
                            arguments: FeedbackFormArgs(Scaffold.of(context)));
                      },
                      leading:
                          Icon(Icons.feedback, color: theme.iconTheme.color),
                      title: Text(localizations.leaveFeedback,
                          style: theme.primaryTextTheme.body1)),
                  ListTile(
                    title: Text(localizations.logOut),
                    onTap: () {
                      BlocProvider.of<AuthenticationBloc>(context)
                          .add(Unauthenticate());
                    },
                    leading: Icon(Icons.vpn_key),
                  ),
                ],
              ),
            )),
          );
        });
  }
}
