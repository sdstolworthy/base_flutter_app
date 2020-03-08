import 'package:flutter/material.dart';
import 'package:flutter_base_app/src/blocs/authentication/bloc.dart';
import 'package:flutter_base_app/src/blocs/user_profile/bloc.dart';
import 'package:flutter_base_app/src/widgets/user_avatar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final UserProfileBloc _userProfileBloc =
        BlocProvider.of<UserProfileBloc>(context);
    return BlocBuilder<UserProfileBloc, UserProfileState>(
        bloc: _userProfileBloc,
        builder: (BuildContext context, UserProfileState userProfileState) {
          if (userProfileState is InitialUserProfileState) {
            BlocProvider.of<AuthenticationBloc>(context)
                .getCurrentUserId()
                .then((String userId) {
              _userProfileBloc.add(FetchUserProfile(userId));
            });
          }
          return Scaffold(
            body: NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool isScrolled) {
                return <Widget>[const SliverAppBar()];
              },
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView(children: <Widget>[
                  if (userProfileState is UserProfileFetched)
                    UserAvatar(userProfileState.user)
                  else
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                      (userProfileState as UserProfileFetched)
                              ?.user
                              ?.fullName ??
                          '',
                      style: theme.primaryTextTheme.headline
                          .copyWith(color: Colors.black)),
                  Text(
                      (userProfileState as UserProfileFetched)?.user?.email ??
                          '',
                      style: theme.primaryTextTheme.headline
                          .copyWith(color: Colors.black))
                ]),
              ),
            ),
          );
        });
  }
}
